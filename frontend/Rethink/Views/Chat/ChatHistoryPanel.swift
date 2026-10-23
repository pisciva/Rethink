import SwiftUI

struct ChatHistoryPanel: View {
    @ObservedObject var model: ChatViewModel
    @Binding var isPresented: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack {
                Text("Riwayat chat")
                    .font(.system(size: 23, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Button { isPresented = false } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .medium))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .accessibilityLabel("Tutup riwayat")
            }
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 4) {
                    if model.history.isEmpty {
                        Text("Belum ada percakapan. Mulai chat bersama Jimmy.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 16)
                    }
                    ForEach(model.history) { thread in
                        Button {
                            model.open(thread)
                            isPresented = false
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text(thread.title)
                                    .font(.system(size: 16))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                Text(thread.updatedAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 14)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            Button {
                model.reset()
                isPresented = false
            } label: {
                Label("Chat baru", systemImage: "square.and.pencil")
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 20)
                    .frame(height: 54)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.tint(HomeStyle.powder).interactive(), in: .capsule)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, -10)
        .foregroundStyle(HomeStyle.ink)
        .accessibilityAddTraits(.isModal)
    }
}
