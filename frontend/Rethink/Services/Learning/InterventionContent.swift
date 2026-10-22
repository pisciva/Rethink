import Foundation

enum InterventionContent {
    /// Prototype content. A mathematics reviewer must approve the questions and rubric.
    static let draftDistributive = InterventionPackage(
        id: "distribution-intervention-v0.1",
        conceptID: "distributive-property",
        conceptTitle: "Sifat Distributif",
        version: "draft-distribution-v0.1",
        reviewStatus: .draft,
        visualExpression: "3(x + 2) = 3x + 6",
        visualGroups: ["x + 2", "x + 2", "x + 2"],
        visualExplanation: "Ada tiga kelompok yang masing-masing berisi x dan 2. Jadi x muncul tiga kali dan 2 juga muncul tiga kali.",
        workedProblem: "4(x + 3) = 20",
        workedSteps: [
            WorkedExampleStep(id: "worked-1", expression: "4x + 12 = 20", reason: "Kalikan 4 dengan x dan dengan 3."),
            WorkedExampleStep(id: "worked-2", expression: "4x = 8", reason: "Kurangi kedua sisi dengan 12."),
            WorkedExampleStep(id: "worked-3", expression: "x = 2", reason: "Bagi kedua sisi dengan 4.")
        ],
        practiceProblem: "5(x + 2) = 25",
        practiceSteps: [
            GuidedPracticeStep(id: "practice-1", prompt: "5x + □ = 25. Isi kotak.", expectedValue: 10, hint: "Kalikan 5 dengan 2 juga.", incorrectFeedback: "Periksa perkalian 5 dengan setiap suku dalam kurung."),
            GuidedPracticeStep(id: "practice-2", prompt: "5x = □. Isi kotak.", expectedValue: 15, hint: "Kurangi 25 dengan 10.", incorrectFeedback: "Kurangi kedua sisi persamaan dengan 10."),
            GuidedPracticeStep(id: "practice-3", prompt: "x = □. Isi kotak.", expectedValue: 3, hint: "Bagi 15 dengan 5.", incorrectFeedback: "Bagi kedua sisi dengan koefisien x.")
        ],
        retryQuestions: [
            NumericValidationQuestion(id: "retry-1", prompt: "Selesaikan 6(x + 1) = 24. Berapa nilai x?", expectedValue: 3),
            NumericValidationQuestion(id: "retry-2", prompt: "Selesaikan 3(x + 2) = 18. Berapa nilai x?", expectedValue: 4)
        ],
        transferQuestion: LinearExpressionQuestion(
            id: "transfer-1",
            prompt: "Ada tiga kotak. Tiap kotak berisi x pensil biru dan 4 pensil merah. Tulis ekspresi jumlah seluruh pensil tanpa tanda kurung.",
            expectedCoefficient: 3,
            expectedConstant: 12
        )
    )
}
