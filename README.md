# Full Stack Coding Master
### Team Sinsa-Station - [Team Wiki](https://github.com/SinsaStation/FullStackCodingBot/wiki)


|<img src="https://user-images.githubusercontent.com/74946802/127594347-2f471137-5a26-458f-957e-3f0dcecba018.png" width="300">|<img src="https://user-images.githubusercontent.com/74946802/127594350-3c15a26b-f19a-4734-9b00-e424a68c83db.png" width="300">|<img src="https://user-images.githubusercontent.com/74946802/127594351-73704d42-d60a-4ce4-a2d0-c965bd517975.png" width="300">|
|:---:|:---:|:---:|
|MainScene|ItemScene|RankScene|

|<img src="https://user-images.githubusercontent.com/74946802/127594352-7cbee772-52ca-4e0a-a126-625940dd4f1c.png" width="300">|<img src="https://user-images.githubusercontent.com/74946802/127594353-a601bd3a-236a-4c9d-b450-af533df16c4d.png" width="300">|<img src="https://user-images.githubusercontent.com/74946802/127594354-ea70eaa5-5d4a-4607-8443-de5ce5945cbe.png" width="300">|
|:---:|:---:|:---:|
|AdsScene|GameScene|FeverScene|

|<img src="https://user-images.githubusercontent.com/74946802/127594356-583622b3-0525-4ee3-9d67-6fb2c59edb74.png" width="300">|<img src="https://user-images.githubusercontent.com/74946802/127594358-97e467cd-bc6d-48ca-93b5-b02b94a1ef98.png" width="300">|<img src="https://user-images.githubusercontent.com/74946802/127594354-ea70eaa5-5d4a-4607-8443-de5ce5945cbe.png" width="300">|
|:---:|:---:|:---:|
|PauseScene|GameOverScene|SettingScene|

## Team Members

|![74946802](https://user-images.githubusercontent.com/74946802/127593187-e129cd8a-9146-4e8d-a283-cf3db288b11b.jpeg)| ![72188416](https://user-images.githubusercontent.com/74946802/127593249-62465ed4-d221-4543-a7b6-e777ce6c9cc5.jpeg)|
|:------:|:---:|
|**서우석** | **이송**|
|[github](https://github.com/torch-ray)|[github](https://github.com/eeeesong)|

---

## History
### 서우석
```
프로젝트 초반에 생성해두었던 MemoryStorage를 PersistenceStorage로 수정했던 작업이 기억에 남습니다.  
MemoryStorageType이라는 protocol을 활용하여 viewModel객체들에 의존성을 주입해서 코드를 설계했던 덕분에 쉽게 객체 바꿔치기가 가능했습니다.  
적절한 protocol 사용과 의존성 주입이 유연한 코드 작성에 얼마나 효과적인지 직접 느낄 수 있었습니다.
```

> ### Main 
>
> - [x] 기본 UI
> - [x] Auto Layout 확인 ((iPod touch, 8, 11, 12)
> - [x] ButtonController (Button 다형성) 
> - [x] SceneCoordinator
> - [x] Scene  객체
> - [x] TransitionManager 객체
> - [x] 화면 이동
> - [x] CommonViewModel (모든 viewModel의 super class)
> - [x] MemoryStorage 및 CRUD 메서드
> - [x] Loading ViewController & Activity Indicator

> ### Setting
>
> - [ ] 이동 Button
> - [ ] 기본 UI
> - [ ] 배경음악 on/off
> - [ ] How to play

> ### Item
>
> - [x] 기본 UI
> - [x] cell tap시 Main Image 변경
> - [x] Levelup Button 기능
> - [x] Required Money View
> - [x] Balance View

> ### Ads
>
> - [x] Test App 등록
> - [x] GAD ID 발급
> - [x] Google Ads 삽입


> ### Game
>
> - [x] Dynamic Level 코드


> ### Unit Test
>
> - [x] Storage Protocol 테스트


> ### Apple Game Center
>
> - [x] AGC 로그인 구현
> - [x] Firebase와 로그인 연동
> - [x] Leader Boards

> ### Firebase
>
> - [x] Firebase 관리객체 생성
> - [x] Firebase와 Data 통신을 위한  DataFormatManager 생성
> - [x] Coredata와 Data 연동(background 진입 / 앱 종료 시)
> - [x] Real Time DB json
> - [x] Data 다운로드 완료시 LoadingVC dismiss

> ### User Defaults
>
> - [x] hasLaunchedOnce 기능 구현

> ### Core Data
>
> - [x] 기존 MemoryStorage -> PersistenceStorage로 객체 변경
> - [x] Core Data Entity
> - [x] CRUD 메서드


### 이송
```
챌린지 했던 내용 요약해서 쓰기 2~3줄
```

> ### Main
>
> - [x] Image Asset을 적용한 UI - AutoLayout
> - [x] BackgroundView의 랜덤 구름 Animation



> ### Item
>
> - [x] Image Asset을 적용한 UI - AutoLayout
> - [x] Item Upgrade 성공 Animation - 이미지 평균 컬러 반영
> - [ ] Item Scene Notice Label Animation
> - [x] Item Upgrade 성공 여부에 따른 Haptic 


> ### Ads
>
> - [x] UI 구축 - AutoLayout
> - [x] Available(Ad or Gift) / Taken 상황에 맞춘 CollectionCell Update
> - [x] Reward Update Logic 구현 - AdStorage



> ### Game
>
> - [x] UI 구축 - AutoLayout
> - [x] Game Play Logic 구현 - GameUnitManager
> - [ ] Match 성공 시 랜덤 코드 Animation
> - [x] Match 실패 대응 - Haptic 적용, Wrong Animation, 버튼 Cool time
> - [x] 게임 유닛 릴즈의 PerspectiveView & Animation 
> - [x] Game Over Logic 구현 - TimeManager
> - [x] Game Over / Pause Scene 흐름 컨트롤
> - [x] Fever Time Logic 구현 - FeverManager
> - [x] 게임 BackgroundView의 FeverAnimation
> - [x] NormalTimeView / FeverTimeView & Animation
> - [x] Game Ready Mode 구현 



> ### Pause
>
> - [x] UI 구축 - AutoLayout
> - [x] Resume / Restart / Home 흐름 컨트롤
> - [x] BackgroundView Animation



> ### Game Over
>
> - [x] UI 구축 - AutoLayout
> - [x] High Score 연동
> - [x] Restart / Home 흐름 컨트롤
> - [x] BackgroundView Animation


> ### Unit Test
>
> - [x] AdStorage 테스트

> ### Audio
>
> - [x] 배경음, 효과음 재생 컨트롤

---

## Short Interviews

### [RxSwift](https://github.com/SinsaStation/FullStackCodingBot/wiki/RxSwift)
### [SwiftLint](https://github.com/SinsaStation/FullStackCodingBot/wiki/SwiftLint)
### [MVVM](https://github.com/SinsaStation/FullStackCodingBot/wiki/MVVM)



# About Team

<img width="500" alt="스크린샷 2021-07-30 오후 12 04 43" src="https://user-images.githubusercontent.com/74946802/127593694-63f0c702-e562-4ef7-b1e8-c3c0e4db9a2b.png">

## Ground Rule

### [Ground Rule](https://github.com/SinsaStation/FullStackCodingBot/wiki/Ground-Rule)

---

## Commit Convention

### [Commit Convention](https://github.com/SinsaStation/FullStackCodingBot/wiki/Commit-Convention)

---

## Branch Strategy

### [Branch Strategy](https://github.com/SinsaStation/FullStackCodingBot/wiki/Branch-Strategy)

---
