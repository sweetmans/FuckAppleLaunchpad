import SwiftUI
import AppKit
import Combine

struct LaunchpadView: View {
    var body: some View {
        ZStack {
            VisualEffectView(material: .contentBackground, blendingMode: .behindWindow)
                .ignoresSafeArea()
            PageView()
                .ignoresSafeArea()
        }
        .onTapGesture {
            NSApplication.shared.terminate(nil)
        }
    }
}

#Preview {
    LaunchpadView()
        .frame(width: 3024/2, height: 1964/2)
}
