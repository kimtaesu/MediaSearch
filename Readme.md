


 ## 적용 범위	
* iOS 11 ~ 최신	
* iPhone	

 ## 환경	
* XCode 10.2.1	
* Swift5	

 ## Languages, libraries and tools used	

 * [Swift](https://developer.apple.com/kr/swift/)	
* [RxSwift](https://github.com/ReactiveX/RxSwift)	
* [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa)	
* [RxOptional](https://github.com/RxSwiftCommunity/RxOptional)	
* [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)	
* [NotificationView](https://github.com/pikachu987/NotificationView)	
* [SwiftLint](https://github.com/realm/SwiftLint)	
* [SwiftGen](https://github.com/SwiftGen/SwiftGen)	
* [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver)	
* [Then](https://github.com/devxoul/Then)	
* [DeallocationChecker](https://github.com/fastred/DeallocationChecker)	

Todo: 
* 이미지 View 로 이동할때 Favorite 등록여부와 함께 전달하고 이미지 View 에서 Favorite update 할 수 있도록 함.	
* 이미지 캐시 적용	
> 한번 다운로드 받은 Thumbnail 은 Cache 영역에 저장할 수 있도록 합니다.	
> In Memory Cache (Limit 300MB)	

> In Disk Cache (Limit 1GB) 	

* 이미지 placeholder 구현 	
> Thumbnail 을 다운로드 하는 동안 사용자에게 빈 화면을 보여지게 됩니다.	

> Thumbnail Download 시도하기 전의 사전의 정의한 이미지를 보여주도록 합니다.	

> Shimmer, 대체 이미지를 적용할 수 있도록 합니다.	
* 이미지 retry 정책 필요	
> Thumbnail Download 를 실패할 경우 최소 3회 재요청 이후 실패할 수 있도록 합니다.	
* 이미지 다운로드 cancel	
> DispatchWorkItem 단위로 Thumbnail 을 download 하도록 합니다.	

`func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)`	

`didEndDisplaying` 가 호출된다면 해당 작업의 다운로드는 취소할 수 있도록 합니다.	

* 이미지 prefetching 	
> 설명 : DataSource 에 로드되었지만 보여지지 않은 영역의 Thumbnail 을 download 하여 cache에 저장할 수 있도록 합니다.	

`func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])`	

> 만약 스크롤 방향이 아래 쪽인 경우 위쪽은 cancel 할 수 있도록 합니다.	

`func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {`	

* 마지막 페이지에서 맨밑에 Footer 위치 조정
* 모델이 너무 복잡합니다.
> Network 로 받은 시점에 Image, VClip을 Thumbnail 단일 객체로 만드는 게 더 효율적입니다.

> Sort 로직은 ViewModel이 아닌 Service에서 실행하는 것이 좋습니다.
* RxCocoa의 bind 보다 UI에 안전한 drive 로 바꾸는 것이 좋습니다.
> Error 가 발생했을 때 Observable이 종료되지 않습니다.
* Optional Closure 는 Default로 @escape 이기 때문에 weak 키워드가 필요합니다.
* try? 로 값을 저장하는 부분이 있습니다. 
> 에러를 확실하게 처리해야 합니다.
* TestCode로 실행로직을 충분히 검증할 수 없습니다.
* ImageViewController 에서 마지막에 도달하면 다음 페이지를 가지고 와야 합니다.
