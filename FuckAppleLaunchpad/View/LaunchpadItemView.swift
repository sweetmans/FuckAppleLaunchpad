import SwiftUI

struct LaunchpadItemView: View {
    let item: LaunchpadItem
    let onGroupTap: (Group) -> Void
    let onAppTap: (Application) -> Void

    var body: some View {
        switch item {
        case .app(let app):
            AppItemView(app: app, onTap: onAppTap)
        case .group(let group):
            GroupItemView(group: group) {
                onGroupTap(group)
            }
        }
    }
}