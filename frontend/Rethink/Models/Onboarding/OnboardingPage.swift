import Foundation

enum OnboardingPage: Int, CaseIterable, Identifiable {
    case welcome
    case concept
    case quickCheck
    case chatbot
    case ready

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .welcome: "Kenalan"
        case .concept: "Cara kerja"
        case .quickCheck: "Cek singkat"
        case .chatbot: "Tanya konsep"
        case .ready: "Siap"
        }
    }

    var title: String {
        switch self {
        case .welcome: "Hai, aku Jimmy!\nAku akan membimbing kamu."
        case .concept: "Pernah nyangkut\ndi tengah soal?"
        case .quickCheck: "Kenalan lewat 5 contoh"
        case .chatbot: "Bingung saat mengerjakan?\nTanya Jimmy!"
        case .ready: "Siap mulai?"
        }
    }

    /// Kept for accessibility/audio-script consumers; the UI shows only the title.
    var message: String {
        switch self {
        case .welcome: "Siapa nama kamu?"
        case .concept: "Kadang kita tahu rumusnya, tapi belum paham kapan dipakai."
        case .quickCheck: "Pilih Belum, Ragu, atau Bisa untuk tiap contoh. Ini bukan diagnosis."
        case .chatbot: "Ketuk pertanyaan untuk melihat jawabannya."
        case .ready: "Kamu bisa mulai tanpa akun."
        }
    }

    var audioResourceName: String {
        switch self {
        case .welcome: "onboarding-1a"
        case .concept: "onboarding-3"
        case .quickCheck: "onboarding-3"
        case .chatbot: "onboarding-4"
        case .ready: "onboarding-6"
        }
    }

    var voiceScript: String {
        switch self {
        case .welcome: "Hai, aku Jimmy. Aku akan membimbing kamu. Siapa nama kamu?"
        case .concept: "Pernah nyangkut di tengah soal? Kadang kita tahu rumusnya, tapi belum paham kapan dipakai. Dari jawabanmu, Rethink mencoba melihat konsep mana yang mungkin perlu diperhatikan. Cek pemahaman, belajar terarah, lalu coba sendiri."
        case .quickCheck: "Aku punya lima contoh soal. Apakah kamu bisa mengerjakannya? Ini contoh perkenalan, bukan diagnosis."
        case .chatbot: "Chatbot membantu menjelaskan konsep, bukan menggantikan proses berpikirmu."
        case .ready: "Siap? Yuk mulai sesi pertamamu."
        }
    }
}
