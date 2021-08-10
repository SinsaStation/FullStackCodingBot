import Foundation

struct Manual {
    let image: String
    let text: String
    
    static let all: [Manual] = [
        .init(image: "GameMain", text: "주어진 그림(언어)의 방향에 따라 왼쪽/오른쪽 화살표를 클릭합니다. 잘못된 방향을 선택하면 시간이 줄어들고, 정확한 방향을 선택하면 점수가 올라갑니다."),
        .init(image: "GameFever", text: "연속해서 정답을 맞추면 피버모드로 진입합니다. 피버모드에서는 잘못된 방향을 선택해도 시간이 줄어들지 않습니다."),
        .init(image: "GamePause", text: "상단 Pause버튼을 클릭하면 게임이 일시정지됩니다. 재개버튼을 통해 게임으로 돌아갈 수 있고, 홈버튼을 클릭하면 메인화면으로 이동합니다."),
        .init(image: "GameOver", text: "주어진 시간을 모두 사용하면 게임이 종료됩니다. 최종적으로 얻은 점수와 돈을 확인할 수 있습니다."),
        .init(image: "Item", text: "아이템(언어)의 레벨을 올리면 게임에서 정답을 맞출 시 얻게되는 점수가 레벨에 비례하여 상승합니다. 레벨업에 필요한 돈은 게임 또는 광고시청을 통해 얻을 수 있습니다.")
    ]
}
