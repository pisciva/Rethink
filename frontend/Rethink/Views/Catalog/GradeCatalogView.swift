import SwiftUI

/// Local presentation catalog. Availability does not come from the backend in this redesign.
struct GradeCatalogView: View {
    @StateObject private var model = GradeCatalogViewModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var gradeSelection
    private var gradeColor: Color {
        switch model.selectedGrade {
        case 10: Color(red: 1.0, green: 0.975, blue: 0.86)
        case 11: Color(red: 0.95, green: 0.98, blue: 0.96)
        default: Color(red: 0.99, green: 0.95, blue: 0.95)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            TabPageHeader(title: "Jelajahi")
                .padding(.horizontal, 24)
                .padding(.top, 12)
            HStack(spacing: 10) {
                ForEach(10...12, id: \.self) { grade in
                    Button {
                        withAnimation(reduceMotion ? nil : .smooth(duration: 0.25)) { model.selectedGrade = grade }
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: "graduationcap")
                            Text("Kelas \(grade)")
                        }
                        .font(.system(size: 13, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .foregroundStyle(model.selectedGrade == grade ? .white : HomeStyle.ink)
                        .background {
                            if model.selectedGrade == grade {
                                Capsule().fill(.black).matchedGeometryEffect(id: "grade", in: gradeSelection)
                            } else {
                                Capsule().fill(Color.gray.opacity(0.06))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(model.selectedGrade == grade ? .isSelected : [])
                }
            }
            .padding(.horizontal, 24)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Materi kelas \(model.selectedGrade)")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Text("\(model.courses.count) materi")
                            .font(.system(size: 12))
                            .foregroundStyle(.black.opacity(0.6))
                    }
                    .padding(.horizontal, 5)
                    courseList(model.general)
                    if !model.advanced.isEmpty {
                        sectionTitle("Tingkat lanjut").padding(.top, 6)
                        courseList(model.advanced)
                    }
                }
                .padding(18)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 36)
                        .fill(gradeColor)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .id(model.selectedGrade)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.black.opacity(0.65))
            .padding(.horizontal, 5)
    }

    private func courseList(_ courses: [GradeCourse]) -> some View {
        VStack(spacing: 9) {
            ForEach(courses) { course in
                if course.isUnlocked {
                    NavigationLink {
                        SPLPretestView()
                    } label: {
                        GradeCourseRow(course: course)
                    }
                    .buttonStyle(GentlePressStyle())
                } else {
                    LockedGradeCourse(course: course)
                }
            }
        }
    }
}

private struct GradeCourseRow: View {
    let course: GradeCourse

    private var cardColor: Color {
        switch course.grade {
        case 10: Color(red: 0.98, green: 0.96, blue: 0.89)
        case 11: Color(red: 0.91, green: 0.95, blue: 0.92)
        default: Color(red: 0.97, green: 0.92, blue: 0.92)
        }
    }

    private var iconColor: Color {
        switch course.grade {
        case 10: Color(red: 0.92, green: 0.87, blue: 0.72)
        case 11: Color(red: 0.80, green: 0.88, blue: 0.82)
        default: Color(red: 0.90, green: 0.80, blue: 0.80)
        }
    }

    var body: some View {
        HStack(spacing: 13) {
            Group {
                if course.id == "g10-1" {
                    Text("xʸ")
                        .font(.system(size: 25, weight: .medium, design: .serif))
                } else {
                    Image(systemName: course.symbol)
                        .font(.system(size: 22, weight: .regular))
                }
            }
                .foregroundStyle(course.isUnlocked ? Color.white : Color.black)
                .frame(width: 48, height: 48)
                .background(course.isUnlocked ? HomeStyle.charcoal : iconColor, in: Circle())
            Text(course.title)
                .font(.system(size: 14, weight: .medium))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            if course.isUnlocked {
                // PROPOSED static activity-progress preview, not assessed understanding.
                ZStack {
                    Circle().stroke(.black.opacity(0.1), lineWidth: 3)
                    Circle()
                        .trim(from: 0, to: 0.3)
                        .stroke(.black, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .medium))
                }
                .frame(width: 34, height: 34)
                .accessibilityLabel("Progres contoh 30 persen")
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(HomeStyle.body.opacity(0.8))
                    .frame(width: 34, height: 34)
            }
        }
        .padding(9)
        .padding(.trailing, 6)
        .frame(minHeight: 68)
        .foregroundStyle(HomeStyle.ink)
        .background(course.isUnlocked ? Color.white : cardColor, in: RoundedRectangle(cornerRadius: 34))
        .shadow(color: .black.opacity(course.isUnlocked ? 0.08 : 0.03), radius: 7, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(course.title), \(course.isUnlocked ? "tersedia, progres contoh 30 persen" : "terkunci")")
    }
}

private struct LockedGradeCourse: View {
    let course: GradeCourse
    @State private var attempts = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button { attempts += 1 } label: {
            GradeCourseRow(course: course)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.warning, trigger: attempts)
        .keyframeAnimator(initialValue: CGFloat.zero, trigger: attempts) { content, offset in
            content.offset(x: reduceMotion ? 0 : offset)
        } keyframes: { _ in
            KeyframeTrack {
                LinearKeyframe(-4, duration: 0.045)
                LinearKeyframe(4, duration: 0.06)
                LinearKeyframe(-3, duration: 0.06)
                LinearKeyframe(0, duration: 0.065)
            }
        }
    }
}

#Preview {
    NavigationStack { GradeCatalogView() }
}
