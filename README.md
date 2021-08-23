# ⚡️ Full Stack Coding Master
 <img src="https://user-images.githubusercontent.com/72188416/128889413-e113b03b-9073-4340-8808-37aa19887354.png" width="100">

> `About` 풀스택 개발 마스터를 향한 고군분투를 담은 퍼즐 게임
> 
> `Made by` Team Sinsa-Station - [Team Wiki](https://github.com/SinsaStation/FullStackCodingBot/wiki)
>  
>  `기획기간` **2021.06.16 ~ 2021.07.05**
>    
>  `개발기간` **2021.07.06 ~ 2021.08.20**   
>  
>  `배포날짜` **2021.08.xx**  

<img width="1674" alt="스크린샷 2021-08-20 오후 12 12 56" src="https://user-images.githubusercontent.com/74946802/130173474-f589dad6-26cf-4f27-a71d-323f8e459382.png">

[<img width=150px src=https://user-images.githubusercontent.com/42789819/115149387-d42e1980-a09e-11eb-88e3-94ca9b5b604b.png>](https://apps.apple.com/us/app/풀-스택-코딩-마스터/id1576807697)

<br>

## Development Environment & Libraries

### Development Environment  
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg) ![iOS](https://img.shields.io/badge/Platform-iOS-black.svg)


### Libraries

  | 이름 | 목적 | 사용 버전 |
  |:---:|:----------:|:----:|
  | RxSwift   | 비동기 처리 | 6.2.0|
  | RxCocoa  | View 처리 | 6.2.0 |
  | Firebase  | Database 및 이벤트 로깅 | 8.6.0 |
  | Firebase/Auth | 게임센터 로그인 연동  | 8.6.0 |


<br>


## Scenes & Features

### Intro


|<img src="https://user-images.githubusercontent.com/72188416/128887015-3a116716-880f-43c1-a7de-c57da9e6196e.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/128888308-4f69f5dd-bb53-4bb4-9c73-ebabe09b9578.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/130058366-00825062-a9dc-4280-80b3-5b0be8859fca.png" width="250">|
|:---:|:---:|:---:|
|Launch|Story|Loading|
|- Launch Screen 제공|- 앱 첫 실행 시 게임 스토리 제공<br>- 스킵 가능|- Firebase/Coredata 데이터 로드 제공 <br> - 애플 게임 센터 로그인 제공 <br> - 오프라인 플레이 가능|


### Main & Menu
|<img src="https://user-images.githubusercontent.com/72188416/129713409-905042f7-35e5-418c-b030-7344d8d97517.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/129713406-530c45fb-ed29-4daf-9dca-191f5b764703.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/128892470-01bb0fe3-5d16-47c9-bbd1-3f062e1343a6.png" width="250">|
|:---:|:---:|:---:|
|Title|Item|Reward|
|- 각종 메뉴 및 게임 화면 이동 제어|- 에너지를 사용한 아이템 업그레이드 제공|- 구글 애드몹 연동 보상 광고 제공 <br> - 매일 자정 새로운 리워드 제공|


|<img src="https://user-images.githubusercontent.com/74946802/127594351-73704d42-d60a-4ce4-a2d0-c965bd517975.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/129713402-2a5d35a2-cab7-40b3-b786-743d7136a562.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/130058393-5b8059d4-db5c-414e-b0c8-2c1bad302c4e.png" width="250">|
|:---:|:---:|:---:|
|Ranking|Setting|How To|
|- 온라인 플레이 시 게임센터 랭킹 제공 <br> - All time & Monthly Ranking|- BGM, 효과음, 진동 설정 가능 <br> - 게임 스토리 재시청 제공|- 게임 진행 방법 제공|


### Game
|<img src="https://user-images.githubusercontent.com/72188416/129713395-2e62200e-ecc1-4fcf-83ee-1f7191805f9d.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/130390356-b29dd720-005f-4dbb-ad82-cad4642109d0.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/130390353-ab1bd185-a095-4dc3-93d1-a69bddd96bc9.png" width="250">|
|:---:|:---:|:---:|
|Game1|Game2|Fever|
|- 게임 시작 전 준비 시간 제공|- 게임 플레이 제공 <br> - 유저 하이스코어 연동|- 콤보 달성 시 피버 모드 제공|

|<img src="https://user-images.githubusercontent.com/74946802/127594356-583622b3-0525-4ee3-9d67-6fb2c59edb74.png" width="250">|<img src="https://user-images.githubusercontent.com/72188416/130390396-f4eee1d0-aa17-49e6-a6c4-449f015846a9.png" width="250">|
|:---:|:---:|
|Pause|GameOver|
|- 게임 정지 기능 제공|- 랭킹 및 에너지 자동 저장 제공 <br> - 점수에 따른 게임오버 스토리|

---

## Team Members


|<img src="https://user-images.githubusercontent.com/74946802/127593187-e129cd8a-9146-4e8d-a283-cf3db288b11b.jpeg" width="400">| <img src="https://user-images.githubusercontent.com/74946802/127593249-62465ed4-d221-4543-a7b6-e777ce6c9cc5.jpeg" width="400">|
|:------:|:---:|
|**WooSeok** | **Song**|
|- 앱 개발 <br> - 앱 기획 <br> - 내러티브 기획|- 앱 개발 <br> - 앱 기획 <br> - 픽셀아트 및 일러스트|
|[github](https://github.com/torch-ray)|[github](https://github.com/eeeesong)|


<details markdown="WooSeok">
<summary>WooSeok's Develop History</summary>

#### Summary
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

> ### How To Play
> - [x] 기능 구현
> - [x] 기본 UI

> ### Story
>
> - [x] 스토리 구상
> - [x] 기본 UI
> - [x] StoryScene 로직

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
> - [x] SettingVC 기능 구현

> ### Core Data
>
> - [x] 기존 MemoryStorage -> PersistenceStorage로 객체 변경
> - [x] Core Data Entity
> - [x] CRUD 메서드
 

</details>



<details markdown="Song">
<summary>Song's Develop History</summary>

#### Summary
```
서드파티 라이브러리 사용 없이 Core Graphics와 UIKit만을 활용하여 모든 애니메이션을 구현한 경험이 가장 기억에 남습니다.
또한, 아이폰4s까지 지원할 수 있도록 Auto Layout을 짜야했던 것도 챌린징했습니다. 
게임이라는 특성 상 화면 구성요소가 다양했기 때문에, View를 짜는 것에 있어서도 구조가 중요하다는 것을 느낄 수 있었습니다.
 
```

> ### Main
>
> - [x] Image Asset을 적용한 UI - AutoLayout
> - [x] BackgroundView의 랜덤 구름 Animation
> - [x] Title View 텍스트의 Type Writer Animation
> - [x] Loading View 

> ### How To Play
>
> - [x] Layout 조정 및 assets 적용


> ### Item
>
> - [x] Image Asset을 적용한 UI - AutoLayout
> - [x] 기기 사이즈에 따른 Font Size 적용
> - [x] Item Upgrade 성공 Animation - 이미지 평균 컬러 반영
> - [x] Info View 텍스트의 Fade In Animation
> - [x] Item Upgrade 성공 여부에 따른 Haptic 


> ### Ads
>
> - [x] UI 구축 - AutoLayout
> - [x] Available(Ad or Gift) / Taken 상황에 맞춘 CollectionCell Update
> - [x] Reward Update Logic 구현 - AdStorage
> - [x] Banner Ads 연동

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
> - [x] Match 성공 시 랜덤 코드 Animation
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
> - [x] 랭크에 따른 랜덤 스토리 연동


> ### Unit Test
>
> - [x] AdStorage 테스트

> ### Audio
>
> - [x] 배경음, 효과음 재생 컨트롤 - Sound Station 객체들
> - [x] User Default와 연동

</details>

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

