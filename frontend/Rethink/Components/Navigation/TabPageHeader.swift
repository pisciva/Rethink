import SwiftUI
import UIKit

/// Shared local avatar; the same image is shown across all three tabs.
struct ProfileAvatar: View {
    @AppStorage("rethink.profile.avatar") private var avatar = ""
    var size: CGFloat = 48

    var body: some View {
        Group {
            if let data = Data(base64Encoded: avatar), let image = UIImage(data: data) {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                Image("ProfileAvatar")
                    .resizable().scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .accessibilityHidden(true)
    }
}

/// Profile is presented outside each tab's navigation history.
struct ProfileButton: View {
    var size: CGFloat = 48
    @State private var isPresented = false

    var body: some View {
        Button { isPresented = true } label: {
            ProfileAvatar(size: size)
        }
        .buttonStyle(GentlePressStyle())
        .accessibilityLabel("Buka profil")
        .fullScreenCover(isPresented: $isPresented) {
            NavigationStack {
                ProfileView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Tutup") { isPresented = false }
                        }
                    }
            }
        }
    }
}

struct TabPageHeader: View {
    let title: String
    var iconName: String? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let iconName {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityHidden(true)
            }
            Text(title)
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(HomeStyle.ink)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            ProfileButton()
        }
        .frame(maxWidth: .infinity)
    }
}
