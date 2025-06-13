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

class ApplicationsViewModel: ObservableObject {
    @Published var applications: [Application] = []
    var applicationPages: [ApplicationPage] {
        stride(from: 0, to: applications.count, by: 35).map { index in
            ApplicationPage(apps: Array(applications[index..<min(index + 35, applications.count)]))
        }
    }

    func loadApplications() {
        let fileManager = FileManager.default
        let applicationsURL = URL(fileURLWithPath: "/Applications")
        
        do {
            let contents = try fileManager.contentsOfDirectory(
                at: applicationsURL,
                includingPropertiesForKeys: [.isApplicationKey]
            )
            
            let apps = contents
                .filter { url in
                    let resourceValues = try? url.resourceValues(forKeys: [.isApplicationKey])
                    return resourceValues?.isApplication == true
                }
                .map { url in
                    let name = url.deletingPathExtension().lastPathComponent
                    let icon = NSWorkspace.shared.icon(forFile: url.path)
                    return Application(name: name, path: url, icon: icon)
                }
                .sorted { $0.name < $1.name }
            
            DispatchQueue.main.async {
                self.applications = apps
            }
        } catch {
            print("Error loading applications: \(error)")
        }
    }
}
