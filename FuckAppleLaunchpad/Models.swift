import SwiftUI
import AppKit

struct Application: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let path: URL
    let icon: NSImage?
    var lastOpenedTime: Date
    var openCount: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Application, rhs: Application) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, path, lastOpenedTime, openCount
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(path, forKey: .path)
        try container.encode(lastOpenedTime, forKey: .lastOpenedTime)
        try container.encode(openCount, forKey: .openCount)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        path = try container.decode(URL.self, forKey: .path)
        lastOpenedTime = try container.decode(Date.self, forKey: .lastOpenedTime)
        openCount = try container.decode(Int.self, forKey: .openCount)
        icon = NSWorkspace.shared.icon(forFile: path.path)
    }
    
    init(name: String, path: URL, icon: NSImage?) {
        self.id = UUID()
        self.name = name
        self.path = path
        self.icon = icon
        self.lastOpenedTime = Date()
        self.openCount = 0
    }
}

struct Group: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var apps: [Application]
    var lastOpenedTime: Date
    var openCount: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
    
    init(name: String, apps: [Application]) {
        self.id = UUID()
        self.name = name
        self.apps = apps
        self.lastOpenedTime = Date()
        self.openCount = 0
    }
}

enum LaunchpadItem: Identifiable, Hashable {
    case app(Application)
    case group(Group)

    var id: UUID {
        switch self {
        case .app(let app): return app.id
        case .group(let group): return group.id
        }
    }
}

struct ApplicationPage: Identifiable {
    let id = UUID()
    let items: [LaunchpadItem]
}