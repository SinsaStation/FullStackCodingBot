import Foundation

struct Manual {
    let image: String
    let text: String
    
    static let all: [Manual] = [
        .init(image: "GameMain", text: "1234"),
        .init(image: "GameFever", text: "3232"),
        .init(image: "GamePause", text: "1233"),
        .init(image: "GameOver", text: "3111"),
        .init(image: "Item", text: "1123")
    ]
}
