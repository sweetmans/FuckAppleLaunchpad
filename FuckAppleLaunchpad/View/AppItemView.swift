import SwiftUI
import AppKit

struct AppItemView: View {
    let app: Application

    var body: some View {
        VStack(spacing: 12) {
            if let icon = app.icon {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 104, height: 104)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Image(systemName: "app.fill")
                    .resizable()
                    .frame(width: 104, height: 104)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.gray)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            }
            Text(app.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            NSWorkspace.shared.open(app.path)
            NSApplication.shared.terminate(nil)
        }
    }
}

struct AppItemView_Previews: PreviewProvider {
    static var previews: some View {
        AppItemView(app: .init(name: "Xcode",
                               path: URL(string: "abc")!,
                               icon: NSImage(named: "launchIcon")))
            .frame(width: 400, height: 400)
            .background(Color.gray)
    }
}
