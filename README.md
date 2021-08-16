# ⚡️ Full Stack Coding Master
<img src="https://user-images.githubusercontent.com/72188416/128889413-e113b03b-9073-4340-8808-37aa19887354.png" width="100">

> `About` 풀스택 개발 마스터를 향한 고군분투 퍼즐 게임
> 
> `Made by` Team Sinsa-Station - [Team Wiki](https://github.com/SinsaStation/FullStackCodingBot/wiki)
>


## Game Scenes

### Intro


|<img src="https://user-images.githubusercontent.com/72188416/128887015-3a116716-880f-43c1-a7de-c57da9e6196e.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/128888285-f32c7ab0-7a3a-48bf-8327-743d837589c7.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/128888308-4f69f5dd-bb53-4bb4-9c73-ebabe09b9578.png" width="250">|
|:---:|:---:|:---:|
|Launch|Story1|Story2|


### Main & Menu

|<img src="https://user-images.githubusercontent.com/72188416/128887560-439e2887-4088-4a15-9124-0dcaf6d12b46.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/128887871-655093c3-f2d7-4ec0-8320-9f461584691b.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/128892470-01bb0fe3-5d16-47c9-bbd1-3f062e1343a6.png" width="250">|
|:---:|:---:|:---:|
|Title|Item|Reward|


|<img src="https://user-images.githubusercontent.com/74946802/127594351-73704d42-d60a-4ce4-a2d0-c965bd517975.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/128887693-b5b07ccf-7e23-423c-aba5-ea3a3541b55a.png" width="250">||
|:---:|:---:|:---:|
|Ranking|Setting|How To|


### Game

|<img src="https://user-images.githubusercontent.com/74946802/127594353-a601bd3a-236a-4c9d-b450-af533df16c4d.png" width="250">||<img src="https://user-images.githubusercontent.com/74946802/127594354-ea70eaa5-5d4a-4607-8443-de5ce5945cbe.png" width="250">|
|:---:|:---:|:---:|
|Game1|Game2|Fever|

|<img src="https://user-images.githubusercontent.com/74946802/127594356-583622b3-0525-4ee3-9d67-6fb2c59edb74.png" width="250">|<img src="https://user-images.githubusercontent.com/74946802/127594358-97e467cd-bc6d-48ca-93b5-b02b94a1ef98.png" width="250">|
|:---:|:---:|
|Pause|GameOver|

---

## Team Members


|<img src="https://user-images.githubusercontent.com/74946802/127593187-e129cd8a-9146-4e8d-a283-cf3db288b11b.jpeg" width="400">| <img src="https://user-images.githubusercontent.com/74946802/127593249-62465ed4-d221-4543-a7b6-e777ce6c9cc5.jpeg" width="400">|
|:------:|:---:|
|**WooSeok** | **Song**|
|앱 개발 / 앱 기획 / 내러티브 기획|앱 개발 / 앱 기획 / 픽셀아트 및 일러스트|
|[github](https://github.com/torch-ray)|[github](https://github.com/eeeesong)|



### Develop History
#### WooSeok
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
> - [x] 이동 Button
> - [x] 기본 UI
> - [x] 배경음악 on/off
> - [ ] How to play

> ### Story
>
> - [x] 스토리 구상
> -[x] 기본 UI
> -[x] StoryScene 로직

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


#### Song
```
챌린지 했던 내용 요약해서 쓰기 2~3줄
```

> ### Main
>
> - [x] Image Asset을 적용한 UI - AutoLayout
> - [x] BackgroundView의 랜덤 구름 Animation
> - [x] Title View 텍스트의 Type Writer Animation


> ### Item
>
> - [x] Image Asset을 적용한 UI - AutoLayout
> - [x] Item Upgrade 성공 Animation - 이미지 평균 컬러 반영
> - [x] Info View 텍스트의 Fade In Animation
> - [x] Item Upgrade 성공 여부에 따른 Haptic 


> ### Ads
>
> - [x] UI 구축 - AutoLayout
> - [x] Available(Ad or Gift) / Taken 상황에 맞춘 CollectionCell Update
> - [x] Reward Update Logic 구현 - AdStorage

> ### Story
>
> - [x] Image Asset을 적용한 UI - AutoLayout
> - [x] 스토리 관리 모델 구축 - Line, Script, Story Manager 
> - [x] Story View Animations

> ### Launch Screen
>
> - [x] UI 구축 - AutoLayout


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
> - [x] 배경음, 효과음 재생 컨트롤 - Sound Station 객체들
> - [x] User Default와 연동

---

## One more thing!

### Short Interviews

#### [RxSwift](https://github.com/SinsaStation/FullStackCodingBot/wiki/RxSwift)
#### [SwiftLint](https://github.com/SinsaStation/FullStackCodingBot/wiki/SwiftLint)
#### [MVVM](https://github.com/SinsaStation/FullStackCodingBot/wiki/MVVM)



### Team Rules

#### [Ground Rule](https://github.com/SinsaStation/FullStackCodingBot/wiki/Ground-Rule)
#### [Commit Convention](https://github.com/SinsaStation/FullStackCodingBot/wiki/Commit-Convention)
#### [Branch Strategy](https://github.com/SinsaStation/FullStackCodingBot/wiki/Branch-Strategy)

<img width="500" alt="스크린샷 2021-07-30 오후 12 04 43" src="https://user-images.githubusercontent.com/74946802/127593694-63f0c702-e562-4ef7-b1e8-c3c0e4db9a2b.png">

`Thank you for reading!`
