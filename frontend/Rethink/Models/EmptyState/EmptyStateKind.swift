import Foundation

enum EmptyStateKind: CaseIterable, Identifiable, Hashable {
    case noLearning
    case noAssessment
    case catalogUnavailable
    case connectionLost

    var id: Self { self }

    var navigationTitle: String {
        switch self {
        case .noLearning: "Sesi belajar"
        case .noAssessment: "Hasil belajar"
        case .catalogUnavailable: "Jelajahi"
        case .connectionLost: "Ruang belajar"
        }
    }

    var label: String {
        switch self {
        case .noLearning: "Awal yang baru"
        case .noAssessment: "Belum ada hasil"
        case .catalogUnavailable: "Belum ada materi"
        case .connectionLost: "Belum terhubung"
        }
    }

    var title: String {
        switch self {
        case .noLearning: "Lembaran baru,\ncerita baru."
        case .noAssessment: "Hasilnya belum\nada di sini."
        case .catalogUnavailable: "Ruang belajar\nsedang disiapkan."
        case .connectionLost: "Kita sambung\nlagi, yuk."
        }
    }

    var message: String {
        switch self {
        case .noLearning:
            "Belum ada sesi belajar di sini. Pilih topik yang tersedia dan mulai dari satu konsep."
        case .noAssessment:
            "Belum ada hasil validasi konsep. Mulai dari pemeriksaan dan ikuti langkah belajar yang tersedia."
        case .catalogUnavailable:
            "Belum ada materi yang dapat ditampilkan saat ini. Coba muat ulang katalog sebentar lagi."
        case .connectionLost:
            "Belum bisa terhubung ke ruang belajarmu. Periksa koneksi internet, lalu coba lagi."
        }
    }

    var illustration: String {
        switch self {
        case .noLearning: "asset 04"
        case .noAssessment: "asset 23"
        case .catalogUnavailable: "asset 35"
        case .connectionLost: "asset 08"
        }
    }

    var symbol: String {
        switch self {
        case .noLearning: "book.closed"
        case .noAssessment: "doc.text.magnifyingglass"
        case .catalogUnavailable: "square.grid.2x2"
        case .connectionLost: "wifi.slash"
        }
    }

    var actionTitle: String {
        switch self {
        case .noLearning, .noAssessment: "Jelajahi materi"
        case .catalogUnavailable: "Muat ulang katalog"
        case .connectionLost: "Coba hubungkan lagi"
        }
    }
}
