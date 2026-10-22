import SwiftUI

struct CatalogTopicDetailView: View {
    let topic: TopicSummary
    let subject: SubjectSummary
    var branchTitle: String? = nil

    private var supportedEntry: TopicSummary? {
        guard topic.entryTopicID == "spl" else { return nil }
        return subject.topics.first { $0.id == "spl" && $0.availability == .available }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CatalogLevelHeader(
                    level: .lesson, title: topic.title,
                    path: ["Matematika", subject.title] + (branchTitle.map { [$0] } ?? []) + [topic.title],
                    guidance: "Lihat cakupan bagian belajar ini sebelum mulai."
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .catalogEntrance()
                Image(topic.illustrationName)
                    .resizable().scaledToFit()
                    .frame(height: 180)
                    .padding(.top, 28)
                    .accessibilityHidden(true)
                    .catalogEntrance(1)
                Text(topic.description)
                    .font(.body)
                    .foregroundStyle(HomeStyle.body)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                if let entry = supportedEntry {
                    NavigationLink { TopicOverviewView(topic: entry) } label: {
                        Text(topic.id == "spl" ? "Lihat alur pemeriksaan" : "Lihat alur SPL")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(DarkCapsuleStyle())
                } else {
                    Label("Belum tersedia untuk belajar atau pemeriksaan", systemImage: "lock")
                        .font(.subheadline)
                        .foregroundStyle(HomeStyle.body)
                        .multilineTextAlignment(.center)
                        .padding(18)
                        .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 22))
                }
            }
            .padding(24)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle(subject.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }
}
