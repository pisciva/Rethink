import Foundation

struct GradeCourse: Identifiable {
    let id: String
    let title: String
    let grade: Int
    let isAdvanced: Bool
    let symbol: String
    var isUnlocked: Bool { id == "spl" }
    var isPrerequisite: Bool { id == "spl" || id == "g10-10" }

    static let all: [GradeCourse] = {
        let groups: [(Int, Bool, [String])] = [
            (10, false, ["Eksponen dan logaritma", "Sistem persamaan linear", "Sistem pertidaksamaan linear dua variabel", "Persamaan dan fungsi kuadrat", "Persamaan dan fungsi eksponensial", "Perbandingan trigonometri", "Statistika dan penyajian data", "Kuartil, IQR, dan box plot", "Diagram pencar dan hubungan numerik", "Peluang dasar"]),
            (11, false, ["Fungsi dan domain", "Komposisi dan invers fungsi", "Invers fungsi dan pembatasan domain", "Transformasi grafik fungsi", "Lingkaran, busur, dan juring", "Statistika bivariat dan korelasi", "Regresi linear"]),
            (11, true, ["Polinomial, faktor, dan sisa", "Matriks dan transformasi linear", "Vektor bidang dan geometri", "Lingkaran satuan dan fungsi trigonometri", "Fungsi rasional, logaritma, dan nilai mutlak"]),
            (12, false, ["Barisan dan deret", "Barisan dan deret geometri", "Bunga tunggal dan majemuk", "Anuitas dan pinjaman", "Kaidah pencacahan", "Permutasi dan kombinasi", "Peluang majemuk dan bersyarat", "Peluang bersyarat dan independensi"]),
            (12, true, ["Persamaan lingkaran dan elips", "Distribusi binomial", "Distribusi normal dan standardisasi", "Limit dan kontinuitas", "Turunan dan garis singgung", "Aplikasi turunan: singgung, gerak, dan optimasi", "Integral, luas, dan teorema dasar kalkulus"])
        ]
        let symbols: [Int: [String]] = [
            10: ["power", "equal", "lessthan", "x.squareroot", "chart.line.uptrend.xyaxis", "triangle", "chart.bar", "chart.bar.xaxis", "chart.dots.scatter", "dice"],
            11: ["function", "arrow.triangle.branch", "arrow.uturn.backward", "arrow.up.left.and.arrow.down.right", "circle.lefthalf.filled", "chart.xyaxis.line", "line.diagonal"],
            111: ["sum", "square.grid.3x3", "arrow.up.right", "circle.dotted", "plus.forwardslash.minus"],
            12: ["list.number", "multiply", "percent", "calendar.badge.clock", "number", "shuffle", "dice.fill", "arrow.triangle.merge"],
            112: ["oval", "chart.bar.fill", "bell", "arrow.right.to.line", "point.topleft.down.to.point.bottomright.curvepath", "speedometer", "fx"]
        ]
        return groups.flatMap { grade, advanced, titles in
            titles.enumerated().map { index, title in
                GradeCourse(id: grade == 10 && index == 1 ? "spl" : "g\(grade)-\(advanced ? "advanced-" : "")\(index + 1)", title: title, grade: grade, isAdvanced: advanced, symbol: symbols[advanced ? grade + 100 : grade]![index])
            }
        }
    }()
}
