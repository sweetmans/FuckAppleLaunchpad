import SwiftUI

struct PageView: View {
    @State private var currentPage: Int? = 0
    @StateObject private var viewModel = LaunchpadViewViewModel()
    @State private var openedGroup: Group? = nil
    @State private var appGridViewVerticalPadding: CGFloat = 120.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                         ForEach(viewModel.applicationPages.indices, id: \.self) { index in
                             AppGridView(items: viewModel.applicationPages[index].items, 
                                       onGroupTap: { group in
                                 openedGroup = group
                                 viewModel.recordGroupOpen(group)
                             },
                                       onAppTap: { app in
                                 viewModel.recordAppOpen(app)
                             })
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
                .padding(.bottom, 60)
            }
            .padding(.top, appGridViewVerticalPadding)
        }
        .overlay {
            if let group = openedGroup {
                GroupDetailView(group: group, onClose: { openedGroup = nil }, viewModel: viewModel)
            }
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

struct GroupDetailView: View {
    let group: Group
    let onClose: () -> Void
    @ObservedObject var viewModel: LaunchpadViewViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            VStack(spacing: 24) {
                Text(group.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(110), spacing: 16), count: 6), spacing: 24) {
                        ForEach(group.apps) { app in
                            AppItemView(app: app) { tappedApp in
                                viewModel.recordAppOpen(tappedApp)
                            }
                                .onTapGesture {
                                    if let path = app.path.path(percentEncoded: false) as? String {
                                        NSWorkspace.shared.open(URL(fileURLWithPath: path))
                                        onClose()
                                        NSApplication.shared.terminate(nil)
                                    }
                                }
                        }
                    }
                    .padding(40)
                }
                
                Text("Click outside or press ESC to close")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: 900, maxHeight: 600)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .shadow(radius: 30)
        }
        .onAppear {
            // Focus the window so ESC key works
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}

#Preview {
    PageView()
        .frame(width: 3024/2, height: 1964/2)
}
