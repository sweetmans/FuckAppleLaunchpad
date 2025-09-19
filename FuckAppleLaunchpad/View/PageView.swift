import SwiftUI

struct PageView: View {
    @State private var currentPage: Int? = 0
    @StateObject private var viewModel = LaunchpadViewViewModel()
    @State private var appGridViewVerticalPadding: CGFloat = 120.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.applicationPages.indices, id: \.self) { index in
                            AppGridView(apps: viewModel.applicationPages[index].apps)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height - appGridViewVerticalPadding * 2)
                                .containerRelativeFrame(.horizontal)
                                .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .frame(height: geometry.size.height - appGridViewVerticalPadding * 2)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $currentPage)
                HStack(spacing: 8) {
                    ForEach(viewModel.applicationPages.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color(red: 61/255, green: 64/255, blue: 72/255))
                            .frame(width: 9, height: 9)
                    }
                }
            }
            .padding(.top, appGridViewVerticalPadding)
        }
        .onAppear {
            viewModel.loadApplications()
            updateAppItemViewSize()
        }
    }
    
    func updateAppItemViewSize() {
        guard let screenWidth = NSScreen.main?.visibleFrame.width else {
            return
        }
        if screenWidth <= 3456.0 / 2 {
            appGridViewVerticalPadding = 60.0
        }
    }
}

#Preview {
    PageView()
        .frame(width: 3024/2, height: 1964/2)
}
