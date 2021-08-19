import Foundation

struct Manual {
    let image: String
    let text: String
    
    static let all: [Manual] = [
        .init(image: "GameMain", text: "주어진 그림(언어)이 속한 방향과 같은 방향의 버튼을 터치합니다.\n\n올바른 방향을 선택하면 점수가 올라가고, 잘못된 방향을 선택하면 시간이 줄어듭니다."),
        .init(image: "GameFever", text: "연속해서 정답을 맞추면 피버모드로 진입합니다.\n\n피버모드에서는 잘못된 방향을 선택해도 시간이 줄어들지 않습니다."),
        .init(image: "GameOver", text: "주어진 시간을 모두 사용하면 게임이 종료됩니다.\n\n획득한 랭크에 따라 다른 스토리가 나타납니다."),
        .init(image: "Item", text: "에너지를 사용해 프로그래밍 언어의 레벨을 올릴 수 있습니다.\n\n게임에서 정답을 맞출 시 얻게되는 점수가 레벨에 비례하여 상승합니다.\n\n레벨 업에 필요한 에너지는 게임 플레이나 커피를 통해 얻을 수 있습니다."),
        .init(image: "Reward", text: "커피 버튼을 터치하여 에너지를 얻을 수 있습니다.\n\n재생 표시가 붙은 커피는 광고 플레이 후 에너지를 제공합니다.\n\n커피는 하루 6잔 제공되며, 매일 자정에 리필됩니다!")
    ]
}
