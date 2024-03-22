# Menú del Día
<img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/449228f6-1665-4ad9-8092-bf19c73565e8.png" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/807f0b44-2ecf-4e0c-9b91-2050d80245c1.png" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/d383bc64-914c-4bee-8b8f-78d1e659d1af.png" width="23%" height="23%">
 <img src = "https://github.com/yeonupark/CommunityProject/assets/130972950/5583322a-e773-4899-a38e-658efabfd6ce.png" width="23%" height="23%">

## 개발 기간
2023.11.19 ~ 2023.12.24 (5주)

## 한 줄 소개
사용자들이 그 날 먹은 음식에 대해 포스팅하고 다른 유저들과 소통할 수 있는 소셜 애플리케이션

## 기능 소개
- 회원가입 및 로그인 기능
- 개인 프로필 구성 기능
- 그날의 식사 사진을 담은 게시물 업로드
- 다른 사용자 게시물 및 프로필 열람 가능
- 댓글, 팔로우, 좋아요 기능

## 핵심 기술
- 로그인 후, 토큰이 만료되었을 경우 자동으로 Refresh Token을 호출하여 토큰을 갱신하는 로직을 구현. 이를 통해 사용자의 로그인 상태 자동 연장
- MVVM과 MVC 아키텍처를 통해 UI와 비즈니스 로직을 분리하고, 코드의 유지보수성과 확장성 증진
- PhotosUI를 활용하여 사용자가 선택한 사진이 비동기적으로 업로드. 선택된 사진 데이터는 Kingfisher를 통해 JPEG 형식으로 압축되어 처리
- 이미지가 화면에 표시될 때 Kingfisher를 이용하여 이미지 캐싱 및 다운샘플링이 이루어짐
- Moya를 통해 네트워크 계층을 추상화하여 서버와 효율적으로 통신

## 기술 스택 및 라이브러리
- UIKit
- RxSwift
- MVVM, MCV
- PhotosUI
- SnapKit
- Moya
- KingFisher
- UserDefaults, Extension, Protocol, Closure, Codable, UUID

