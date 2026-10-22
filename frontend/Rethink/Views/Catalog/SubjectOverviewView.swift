import SwiftUI

struct SubjectOverviewView: View {
    let subject: SubjectSummary
    @EnvironmentObject private var catalog: CatalogStore

    var body: some View {
        MathematicsCatalogView(
            subjects: catalog.subjects.isEmpty ? [subject] : catalog.subjects,
            isLoading: catalog.isLoading,
            errorMessage: catalog.errorMessage,
            onRetry: { Task { await catalog.load() } },
            initiallySelectedSubjectID: subject.id,
            showsNavigationBar: true
        )
        .navigationTitle(subject.title)
        .toolbar(.visible, for: .navigationBar)
    }
}
