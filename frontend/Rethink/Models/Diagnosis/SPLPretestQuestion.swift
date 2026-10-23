import Foundation

/// Fixed draft items supplied in the Research & Design Blueprint; no answer keys in UI.
struct SPLPretestQuestion: Identifiable {
    let id: Int
    let title: String
    let prompt: String
    let latex: String
    let spokenMath: String

    // Draft distractors: require mathematical/pedagogical review before diagnostic use.
    var options: [String] {
        switch id {
        case 1: ["−11", "−16", "1", "11"]
        case 2: ["−4", "2", "−2", "4"]
        case 3: ["5x − 6", "5x − 3", "2x − 6", "5x + 6"]
        case 4: ["x + 4y", "x + 2y", "5xy", "3x + 4y"]
        case 5: ["Benar", "Salah", "Bergantung pada nilai x", "Belum tahu"]
        case 6: ["x = −4", "x = 4", "x = −9", "x = 9"]
        case 7: ["x = 5, y = 3", "x = 3, y = 5", "x = 7, y = 1", "x = 4, y = 4"]
        case 8: ["x = 3, y = 1", "x = 1, y = 3", "x = 5, y = −3", "x = 2, y = 3"]
        case 9: ["r = 5, s = 8", "r = 8, s = 5", "r = 6, s = 6", "r = 7, s = 7"]
        default: ["(3, 2, 1)", "(2, 3, 1)", "(3, 1, 2)", "(1, 2, 3)"]
        }
    }

    var followUp: String {
        switch id {
        case 1: "Ceritakan urutan perhitungan dan cara menentukan tanda hasilnya."
        case 2: "Tunjukkan bagaimana kamu memasukkan nilai x dan y ke dalam ekspresi."
        case 3: "Bagaimana kamu menghilangkan tanda kurung dan menyederhanakan hasilnya?"
        case 4: "Suku mana yang kamu kelompokkan? Jelaskan alasannya."
        case 5: "Operasi apa yang dilakukan pada masing-masing ruas? Mengapa menurutmu perubahan itu benar atau salah?"
        case 6: "Tuliskan langkah yang kamu gunakan untuk memperoleh nilai x."
        case 7: "Tunjukkan bagaimana persamaan kedua berubah setelah kamu mengganti x."
        case 8: "Persamaan mana yang kamu gabungkan dan mengapa langkah tersebut dapat dilakukan?"
        case 9: "Tuliskan kedua persamaan yang kamu bentuk dan bagaimana memeriksa harga pilihanmu."
        default: "Tunjukkan langkah mengurangi jumlah variabel dan cara memeriksa hasil pada ketiga persamaan."
        }
    }

    static let all: [SPLPretestQuestion] = [
        .init(id: 1, title: "Operasi bilangan bertanda", prompt: "Hitung nilai berikut.", latex: "-5+3(-2)", spokenMath: "Negatif lima ditambah tiga kali negatif dua"),
        .init(id: 2, title: "Bilangan rasional dalam aljabar", prompt: "Jika x = −½ dan y = ¾, berapa nilai ekspresi berikut?", latex: "x=-\\frac{1}{2},\\quad y=\\frac{3}{4}\n2x-4y", spokenMath: "x sama dengan negatif setengah, y sama dengan tiga perempat. Tentukan dua x dikurangi empat y"),
        .init(id: 3, title: "Sifat distributif", prompt: "Sederhanakan ekspresi berikut.", latex: "2(x-3)+3x", spokenMath: "Dua kali buka kurung x dikurangi tiga tutup kurung, ditambah tiga x"),
        .init(id: 4, title: "Suku sejenis", prompt: "Sederhanakan ekspresi berikut.", latex: "2x+3y-x+y", spokenMath: "Dua x ditambah tiga y dikurangi x ditambah y"),
        .init(id: 5, title: "Kesetaraan persamaan", prompt: "Seorang siswa mengubah persamaan pertama menjadi persamaan kedua. Apakah perubahan tersebut benar? Jelaskan.", latex: "3x+4=16\n3x=16+4", spokenMath: "Tiga x ditambah empat sama dengan enam belas, diubah menjadi tiga x sama dengan enam belas ditambah empat"),
        .init(id: 6, title: "Operasi invers", prompt: "Selesaikan persamaan dan tunjukkan langkahnya.", latex: "-2x+5=13", spokenMath: "Negatif dua x ditambah lima sama dengan tiga belas"),
        .init(id: 7, title: "Substitusi SPLDV", prompt: "Tentukan nilai x dan y dari sistem berikut.", latex: "x=2y-1\nx+y=8", spokenMath: "x sama dengan dua y dikurangi satu. x ditambah y sama dengan delapan"),
        .init(id: 8, title: "Eliminasi SPLDV", prompt: "Selesaikan dengan eliminasi dan jelaskan mengapa langkah eliminasi yang kamu pilih dapat dilakukan.", latex: "2x+y=7\n3x-y=8", spokenMath: "Dua x ditambah y sama dengan tujuh. Tiga x dikurangi y sama dengan delapan"),
        .init(id: 9, title: "Memodelkan sistem persamaan", prompt: "Dua roti dan satu susu berharga Rp18.000. Satu roti dan dua susu berharga Rp21.000.\n\nMisalkan r adalah harga satu roti dan s harga satu susu, keduanya dalam ribuan rupiah.\n\nBentuk sistem persamaannya, tentukan kedua harga, dan jelaskan apakah hasilmu memenuhi kedua informasi harga tersebut.", latex: "", spokenMath: ""),
        .init(id: 10, title: "Solusi bersama SPLTV", prompt: "Tentukan (x, y, z), tunjukkan cara mengurangi sistem menjadi lebih sedikit variabel, dan jelaskan bagaimana memastikan solusinya benar.", latex: "x+y+z=6\n2x+y-z=7\nx+2y+z=8", spokenMath: "x ditambah y ditambah z sama dengan enam. Dua x ditambah y dikurangi z sama dengan tujuh. x ditambah dua y ditambah z sama dengan delapan")
    ]
}
