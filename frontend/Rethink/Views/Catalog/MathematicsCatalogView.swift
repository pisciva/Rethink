import SwiftUI

struct MathematicsCatalogView: View {
    let subjects: [SubjectSummary]
    let isLoading: Bool
    var errorMessage: String? = nil
    var onRetry: () -> Void = {}
    var initiallySelectedSubjectID: String? = nil
    var showsNavigationBar = false
    @State private var selectedID: String?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var selectedSubject: SubjectSummary? {
        subjects.first { $0.id == (selectedID ?? initiallySelectedSubjectID) } ?? subjects.first
    }

    var body: some View {
        VStack(spacing: 0) {
            if let subject = selectedSubject {
                CatalogCategoryStrip(
                    items: subjects.map { .init(id: $0.id, title: $0.title, image: $0.illustrationName) },
                    selectedID: subject.id
                ) { id in
                    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.22)) { selectedID = id }
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        CatalogBreadcrumb(path: ["Matematika", subject.title])
                        if !subject.subtopics.isEmpty {
                            ForEach(Array(subject.subtopics.enumerated()), id: \.element.id) { index, branch in
                                NavigationLink {
                                    CatalogSubtopicView(subject: subject, initialBranchID: branch.id)
                                } label: {
                                    CatalogCurriculumCard(title: branch.title, detail: "\(branch.subtopics.count) bagian belajar", image: branch.illustrationName, level: .subtopic, order: index + 1)
                                }
                                .buttonStyle(GentlePressStyle())
                                .catalogEntrance(index + 1)
                                if index < subject.subtopics.count - 1 { CatalogConnector() }
                            }
                        } else {
                            // Older deployed backends remain readable; never fabricate active branches.
                            ForEach(Array(subject.topics.enumerated()), id: \.element.id) { index, topic in
                                NavigationLink { TopicOverviewView(topic: topic) } label: {
                                    CatalogCurriculumCard(title: topic.title, detail: topic.availability == .available ? "Pemeriksaan tersedia" : "Belum tersedia", image: topic.illustrationName, level: .lesson)
                                }
                                .buttonStyle(GentlePressStyle())
                                if index < subject.topics.count - 1 { CatalogConnector() }
                            }
                            if subject.topics.isEmpty {
                                BrandEmptyState(illustration: subject.illustrationName, title: "Materi sedang disiapkan", message: "Subtopik untuk materi ini belum tersedia.")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 28)
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                }
                .id(subject.id)
            } else if isLoading {
                ProgressView("Menyiapkan materi…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 20) {
                    BrandEmptyState(illustration: "asset 02", title: "Katalog belum terbuka", message: errorMessage ?? "Materi belum tersedia. Coba kembali sebentar lagi.")
                    Button("Coba lagi", action: onRetry).buttonStyle(DarkCapsuleStyle())
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background {
            LinearGradient(colors: [HomeStyle.lavender.opacity(0.4), HomeStyle.sky, Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .toolbar(showsNavigationBar ? .visible : .hidden, for: .navigationBar)
    }
}
