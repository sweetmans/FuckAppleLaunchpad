import SwiftUI
import AppKit
import Combine

struct Application: Identifiable {
    let id = UUID()
    let name: String
    let path: URL
    let icon: NSImage?
}

struct ApplicationPage: Identifiable {
    let id = UUID()
    let apps: [Application]
}

class LaunchpadViewViewModel: ObservableObject {
    @Published var applications: [Application] = []
    var applicationPages: [ApplicationPage] {
        stride(from: 0, to: applications.count, by: 35).map { index in
            ApplicationPage(apps: Array(applications[index..<min(index + 35, applications.count)]))
        }
    }
    
    func loadApplications() {
        let systemApplicationUrl = URL(fileURLWithPath: "/System/Applications")
        let applicationUrl = URL(fileURLWithPath: "/Applications")
        var applications = loadApplications(from: systemApplicationUrl, isLoadingDirectory: true)
        applications.append(contentsOf: loadApplications(from: applicationUrl, isLoadingDirectory: true))
        if let userApplicationsPath = getUserApplicationsPath() {
            let userApplicationUrl = URL(fileURLWithPath: userApplicationsPath)
            applications.append(contentsOf: loadApplications(from: userApplicationUrl, isLoadingDirectory: true))
        }
        DispatchQueue.main.async {
            self.applications = applications.sorted { $0.name < $1.name }
            print("total apps loaded:", applications.count)
        }
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
    
    private func loadApplications(from folderUrl: URL, isLoadingDirectory: Bool) ->  [Application] {
        let fileManager = FileManager.default
        var applications: [Application] = []
        do {
            let resourceKeys: [URLResourceKey] = [.isApplicationKey, .isDirectoryKey]
            guard let enumerator = fileManager.enumerator(at: folderUrl,
                                                    includingPropertiesForKeys: resourceKeys,
                                                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants],
                                                    errorHandler: { url, error in
                print("Error accessing \(url): \(error)")
                return true
            }) else {
                return []
            }
            while let url = enumerator.nextObject() as? URL {
                if url.lastPathComponent.contains("app") {
                    let name = url.deletingPathExtension().lastPathComponent
                    let icon = NSWorkspace.shared.icon(forFile: url.path)
                    applications.append(Application(name: name, path: url, icon: icon))
                    continue
                }
                guard isLoadingDirectory else { continue }
                let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
                if resourceValues.isDirectory == true {
                    applications.append(contentsOf: loadApplications(from: url, isLoadingDirectory: false))
                }
            }
        } catch let error {
            print("Error loading applications: \(error)")
        }
        return applications
    }
}
