import SwiftUI

struct AppGridView: View {
    let items: [LaunchpadItem]
    let onGroupTap: (Group) -> Void
    let onAppTap: (Application) -> Void
    @State private var itemWidth: CGFloat = 0
    @State private var itemHeight: CGFloat = 0
    @State private var verticalPadding: CGFloat = 120.0
    @State private var horizontalPadding: CGFloat = 420.0
    
    var body: some View {
        Grid(horizontalSpacing: 2, verticalSpacing: 2) {
            ForEach(0..<5) { rowIndex in
                GridRow {
                    ForEach(0..<7) { columnIndex in
                        let index = rowIndex * 7 + columnIndex
                        if index < items.count {
                            LaunchpadItemView(item: items[index], onGroupTap: onGroupTap, onAppTap: onAppTap)
                                .frame(width: itemWidth, height: itemHeight)
                        } else {
                            Color.clear
                                .frame(width: itemWidth, height: itemHeight)
                        }
                    }
                }
            }
        }
        .onAppear {
            updateItemSize()
        }
    }
    
    func updateItemSize() {
        guard let screenHeight = NSScreen.main?.visibleFrame.height,
              let screenWidth = NSScreen.main?.visibleFrame.width else {
            return
        }
        if screenWidth <= 3456.0 / 2.0 {
            horizontalPadding = 100.0
            verticalPadding = 40.0
        }
        itemWidth = (screenWidth - horizontalPadding * 2) / 7.0
        itemHeight = (screenHeight - verticalPadding * 2) / 5.0
    }
}
