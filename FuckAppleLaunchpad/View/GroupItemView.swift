import SwiftUI
import AppKit

struct GroupItemView: View {
    let group: Group
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 104, height: 104)
                Image(systemName: "folder.fill")
                    .resizable()
                    .frame(width: 60, height: 48)
                    .foregroundColor(.white)
            }
            Text(group.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}