import SwiftUI

struct CatalogSubtopicView: View {
    let subject: SubjectSummary
    @State private var selectedID: String
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(subject: SubjectSummary, initialBranchID: String) {
        self.subject = subject
        _selectedID = State(initialValue: initialBranchID)
    }

    private var selectedBranch: TopicSummary? {
        subject.subtopics.first { $0.id == selectedID } ?? subject.subtopics.first
    }

    var body: some View {
        VStack(spacing: 0) {
            CatalogCategoryStrip(
                title: "Subtopik",
                items: subject.subtopics.map { .init(id: $0.id, title: $0.title, image: $0.illustrationName) },
                selectedID: selectedBranch?.id
            ) { id in
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.22)) { selectedID = id }
            }

            ScrollView(showsIndicators: false) {
                if let branch = selectedBranch {
                    VStack(spacing: 0) {
                        CatalogBreadcrumb(path: [subject.title, branch.title])
                        ForEach(Array(branch.subtopics.enumerated()), id: \.element.id) { index, topic in
                            Group {
                                if topic.id == "spl" && topic.availability == .available {
                                    NavigationLink { CatalogTopicDetailView(topic: topic, subject: subject, branchTitle: branch.title) } label: {
                                        CatalogCurriculumCard(title: topic.title, detail: status(topic), image: topic.illustrationName, level: .lesson, order: lessonNumber(for: topic.id))
                                    }
                                    .buttonStyle(GentlePressStyle())
                                } else {
                                    CatalogLockedCard(topic: topic, order: lessonNumber(for: topic.id))
                                }
                            }
                            .catalogEntrance(index + 1)
                            if index < branch.subtopics.count - 1 { CatalogConnector() }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 28)
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                }
            }
            .id(selectedBranch?.id)
        }
        .background {
            LinearGradient(colors: [HomeStyle.lavender.opacity(0.4), HomeStyle.sky, Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .navigationTitle(subject.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    private func lessonNumber(for id: String) -> Int {
        let ordered = subject.subtopics.flatMap(\.subtopics)
        return (ordered.firstIndex { $0.id == id } ?? 0) + 1
    }

    private func status(_ topic: TopicSummary) -> String {
        if topic.availability == .available { return "Pemeriksaan tersedia" }
        if topic.availability == .preview { return "Konsep pendukung SPL" }
        return "Belum tersedia"
    }
}
