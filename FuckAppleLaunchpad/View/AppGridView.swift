import SwiftUI

struct AppGridView: View {
    let apps: [Application]
    @State private var appItemViewHeight: CGFloat = 0
    @State private var appItemViewWidth: CGFloat = 0
    @State private var appGridViewVerticalPadding: CGFloat = 120.0
    @State private var appGridViewHorizontalPadding: CGFloat = 420.0
    
    var body: some View {
        Grid(horizontalSpacing: 2, verticalSpacing: 2) {
            ForEach(0..<5) { rowIndex in
                GridRow {
                    ForEach(0..<7) { columnIndex in
                        if rowIndex * 7 + columnIndex < apps.count {
                            AppItemView(app: apps[rowIndex * 7 + columnIndex])
                                .frame(width: appItemViewWidth, height: appItemViewHeight)
                        } else {
                            Color.clear
                                .frame(width: appItemViewWidth, height: appItemViewHeight)
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            updateAppItemViewSize()
        })
    }
    
    func updateAppItemViewSize() {
        guard let screenHeight = NSScreen.main?.visibleFrame.height,
              let screenWidth = NSScreen.main?.visibleFrame.width else {
            return
        }
        if screenWidth <= 3456.0 / 2 {
            appGridViewHorizontalPadding = 100.0
            appGridViewVerticalPadding = 40.0
        }
        print("screenHeight", screenHeight, "screenWidth", screenWidth)
        appItemViewWidth = (screenWidth - appGridViewHorizontalPadding * 2 ) / 7.0
        appItemViewHeight = (screenHeight - appGridViewVerticalPadding * 2 ) / 5.0
    }
}
