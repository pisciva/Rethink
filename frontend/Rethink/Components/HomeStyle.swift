import SwiftUI

enum HomeStyle {
    static let background = Color.white
    static let sky = Color("SkyTint")
    static let paper = Color("Paper")
    static let ink = Color("Ink")
    static let charcoal = Color("Charcoal")
    static let body = Color("Body")
    static let muted = Color("Muted")
    static let blue = Color("IrisBlue")
    static let lavender = Color("LavenderWash")
    static let mint = Color("MintWash")
    static let powder = Color("PowderBlue")
    static let peach = Color("Peach")
    static let butter = Color("Butter")
    static let line = Color("Line")

    static func subjectColor(_ id: String) -> Color {
        switch id {
        case "algebra": powder
        case "geometry": mint
        case "trigonometry": lavender
        default: butter
        }
    }
}
