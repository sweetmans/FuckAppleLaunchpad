import SwiftUI

struct AppItemView: View {
    let app: Application

    var body: some View {
        VStack(spacing: 16) {
            if let icon = app.icon {
                Image(nsImage: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 104, height: 104)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            } else {
                Image(systemName: "app.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 104, height: 104)
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
