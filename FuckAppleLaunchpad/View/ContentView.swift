import SwiftUI
import AppKit
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ApplicationsViewModel()
    @State private var currentPage = 0
    @State private var appItemViewHeight: CGFloat = 0
    @State private var appItemViewWidth: CGFloat = 0
    @State private var appGridViewVerticalPadding: CGFloat = 120.0
    @State private var appGridViewHorizontalPadding: CGFloat = 420.0
    
    var body: some View {
        ZStack {
            // Background with gradient and blur effect
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.6), Color.blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(viewModel.applicationPages) { page in
                            AppGridView(apps: page.apps)
                                .padding(.vertical)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height)
                        }
                    }
                    .offset(x: -CGFloat(currentPage) * geometry.size.width)
                    .animation(.easeInOut, value: currentPage)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -50 && currentPage < viewModel.applicationPages.count - 1 {
                                    currentPage += 1
                                } else if value.translation.width > 50 && currentPage > 0 {
                                    currentPage -= 1
                                }
                            }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            viewModel.loadApplications()
        }
        .onTapGesture {
            NSApplication.shared.terminate(nil)
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 1440, height: 900)
}
