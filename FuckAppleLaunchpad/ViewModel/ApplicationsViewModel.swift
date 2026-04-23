import SwiftUI
import AppKit
import Combine

struct AppStatistics: Codable {
    let openCount: Int
    let lastOpenedTime: Date
}

class LaunchpadViewViewModel: ObservableObject {
    @Published var applications: [Application] = []
    @Published var groups: [Group] = []
    
    private let appStatsKey = "com.launchpad.appStats"
    private let groupStatsKey = "com.launchpad.groupStats"
    private let fileManager = FileManager.default
    
    var launchpadItems: [LaunchpadItem] {
        var items: [LaunchpadItem] = groups.map { .group($0) }
        items.append(contentsOf: applications.map { .app($0) })
        return items
    }

    var applicationPages: [ApplicationPage] {
        stride(from: 0, to: launchpadItems.count, by: 35).map { index in
            ApplicationPage(items: Array(launchpadItems[index..<min(index + 35, launchpadItems.count)]))
        }
    }
    
    func recordAppOpen(_ app: Application) {
        var updated = app
        updated.openCount += 1
        updated.lastOpenedTime = Date()
        saveAppStats(for: updated)
    }
    
    func recordGroupOpen(_ group: Group) {
        var updated = group
        updated.openCount += 1
        updated.lastOpenedTime = Date()
        saveGroupStats(for: updated)
    }
    
    func loadApplications() {
        let systemApplicationUrl = URL(fileURLWithPath: "/System/Applications")
        let applicationUrl = URL(fileURLWithPath: "/Applications")
        
        var applications: [Application] = []
        var groups: [Group] = []
        
        // Load apps and groups from each directory
        let (systemApps, systemGroups) = loadApplicationsAndFolders(from: systemApplicationUrl)
        applications.append(contentsOf: systemApps)
        groups.append(contentsOf: systemGroups)
        
        let (appDirApps, appDirGroups) = loadApplicationsAndFolders(from: applicationUrl)
        applications.append(contentsOf: appDirApps)
        groups.append(contentsOf: appDirGroups)
        
        if let userApplicationsPath = getUserApplicationsPath() {
            let userApplicationUrl = URL(fileURLWithPath: userApplicationsPath)
            let (userApps, userGroups) = loadApplicationsAndFolders(from: userApplicationUrl)
            applications.append(contentsOf: userApps)
            groups.append(contentsOf: userGroups)
        }
        
        DispatchQueue.main.async {
            // Load stats and merge with apps/groups
            var statsApps = applications.map { self.loadAppStats(for: $0) ?? $0 }
            var statsGroups = groups.map { self.loadGroupStats(for: $0) ?? $0 }
            
            // Sort by most recently opened and most frequently used
            statsApps.sort { app1, app2 in
                if app1.openCount != app2.openCount {
                    return app1.openCount > app2.openCount
                }
                return app1.lastOpenedTime > app2.lastOpenedTime
            }
            
            statsGroups.sort { group1, group2 in
                if group1.openCount != group2.openCount {
                    return group1.openCount > group2.openCount
                }
                return group1.lastOpenedTime > group2.lastOpenedTime
            }
            
            self.applications = statsApps
            self.groups = statsGroups
            print("total apps loaded:", applications.count, "groups:", groups.count)
        }
    }
    
    private func saveAppStats(for app: Application) {
        var stats = loadAllAppStats()
        stats[app.id.uuidString] = AppStatistics(openCount: app.openCount, lastOpenedTime: app.lastOpenedTime)
        UserDefaults.standard.set(try? JSONEncoder().encode(stats), forKey: appStatsKey)
    }
    
    private func saveGroupStats(for group: Group) {
        var stats = loadAllGroupStats()
        stats[group.id.uuidString] = AppStatistics(openCount: group.openCount, lastOpenedTime: group.lastOpenedTime)
        UserDefaults.standard.set(try? JSONEncoder().encode(stats), forKey: groupStatsKey)
    }
    
    private func loadAppStats(for app: Application) -> Application? {
        let stats = loadAllAppStats()
        guard let stat = stats[app.id.uuidString] else { return nil }
        var updated = app
        updated.openCount = stat.openCount
        updated.lastOpenedTime = stat.lastOpenedTime
        return updated
    }
    
    private func loadGroupStats(for group: Group) -> Group? {
        let stats = loadAllGroupStats()
        guard let stat = stats[group.id.uuidString] else { return nil }
        var updated = group
        updated.openCount = stat.openCount
        updated.lastOpenedTime = stat.lastOpenedTime
        return updated
    }
    
    private func loadAllAppStats() -> [String: AppStatistics] {
        guard let data = UserDefaults.standard.data(forKey: appStatsKey),
              let stats = try? JSONDecoder().decode([String: AppStatistics].self, from: data) else {
            return [:]
        }
        return stats
    }
    
    private func loadAllGroupStats() -> [String: AppStatistics] {
        guard let data = UserDefaults.standard.data(forKey: groupStatsKey),
              let stats = try? JSONDecoder().decode([String: AppStatistics].self, from: data) else {
            return [:]
        }
        return stats
    }

    
    private func loadApplicationsAndFolders(from folderUrl: URL) -> (apps: [Application], groups: [Group]) {
        let fileManager = FileManager.default
        var applications: [Application] = []
        var groups: [Group] = []
        
        do {
            let resourceKeys: [URLResourceKey] = [.isApplicationKey, .isDirectoryKey]
            guard let enumerator = fileManager.enumerator(at: folderUrl,
                                                    includingPropertiesForKeys: resourceKeys,
                                                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants],
                                                    errorHandler: { url, error in
                print("Error accessing \(url): \(error)")
                return true
            }) else {
                return ([], [])
            }
            
            while let url = enumerator.nextObject() as? URL {
                let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
                
                // Check if it's an app bundle
                if url.lastPathComponent.contains(".app") {
                    let name = url.deletingPathExtension().lastPathComponent
                    let icon = NSWorkspace.shared.icon(forFile: url.path)
                    applications.append(Application(name: name, path: url, icon: icon))
                    continue
                }
                
                // Check if it's a folder (not an app bundle)
                if resourceValues.isDirectory == true && !url.lastPathComponent.contains(".app") {
                    let folderName = url.lastPathComponent
                    let appsInFolder = loadApplicationsInFolder(from: url)
                    
                    // Only create a group if folder has more than 2 apps
                    if appsInFolder.count > 2 {
                        let group = Group(name: folderName, apps: appsInFolder)
                        groups.append(group)
                    }
                }
            }
        } catch let error {
            print("Error loading applications and folders: \(error)")
        }
        
        return (applications, groups)
    }
    
    private func loadApplicationsInFolder(from folderUrl: URL) -> [Application] {
        let fileManager = FileManager.default
        var applications: [Application] = []
        
        do {
            let resourceKeys: [URLResourceKey] = [.isApplicationKey, .isDirectoryKey]
            guard let enumerator = fileManager.enumerator(at: folderUrl,
                                                    includingPropertiesForKeys: resourceKeys,
                                                    options: [.skipsHiddenFiles],
                                                    errorHandler: { _, _ in true }) else {
                return []
            }
            
            while let url = enumerator.nextObject() as? URL {
                if url.lastPathComponent.contains(".app") {
                    let name = url.deletingPathExtension().lastPathComponent
                    let icon = NSWorkspace.shared.icon(forFile: url.path)
                    applications.append(Application(name: name, path: url, icon: icon))
                }
            }
        } catch {
            print("Error loading applications in folder: \(error)")
        }
        
        return applications
    }
    
    // TODO: Fix issue on Error accessing User Applications
    private func getUserApplicationsPath() -> String? {
        let userHomePath = FileManager.default.homeDirectoryForCurrentUser.path
        let components = userHomePath.components(separatedBy: "/")
        if components.count >= 3,
           components[1] == "Users" {
            let homePath = "/\(components[1])/\(components[2])/Applications"
            return homePath
         } else {
             return nil
         }
     }
}
