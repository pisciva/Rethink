import Combine

@MainActor
final class GradeCatalogViewModel: ObservableObject {
    @Published var selectedGrade = 10
    var courses: [GradeCourse] { GradeCourse.all.filter { $0.grade == selectedGrade } }
    var general: [GradeCourse] { courses.filter { !$0.isAdvanced } }
    var advanced: [GradeCourse] { courses.filter(\.isAdvanced) }
}
