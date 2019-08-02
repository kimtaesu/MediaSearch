// MARK: - Mocks generated from file: MediaSearch/KakaoServiceType.swift at 2019-08-01 23:05:27 +0000

//
//  KakaoRemoteSourceType.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Cuckoo
@testable import MediaSearch

import Foundation
import RxSwift


 class MockKakaoServiceType: KakaoServiceType, Cuckoo.ProtocolMock {
    
     typealias MocksType = KakaoServiceType
    
     typealias Stubbing = __StubbingProxy_KakaoServiceType
     typealias Verification = __VerificationProxy_KakaoServiceType

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: KakaoServiceType?

     func enableDefaultImplementation(_ stub: KakaoServiceType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func nextImages(_ keyword: String, requests: [(request: ImageRequest, searchOption: SearchOption)]) -> Observable<[GenericPageThumbnail]> {
        
    return cuckoo_manager.call("nextImages(_: String, requests: [(request: ImageRequest, searchOption: SearchOption)]) -> Observable<[GenericPageThumbnail]>",
            parameters: (keyword, requests),
            escapingParameters: (keyword, requests),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.nextImages(keyword, requests: requests))
        
    }
    

	 struct __StubbingProxy_KakaoServiceType: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func nextImages<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ keyword: M1, requests: M2) -> Cuckoo.ProtocolStubFunction<(String, [(request: ImageRequest, searchOption: SearchOption)]), Observable<[GenericPageThumbnail]>> where M1.MatchedType == String, M2.MatchedType == [(request: ImageRequest, searchOption: SearchOption)] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [(request: ImageRequest, searchOption: SearchOption)])>] = [wrap(matchable: keyword) { $0.0 }, wrap(matchable: requests) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockKakaoServiceType.self, method: "nextImages(_: String, requests: [(request: ImageRequest, searchOption: SearchOption)]) -> Observable<[GenericPageThumbnail]>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_KakaoServiceType: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func nextImages<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ keyword: M1, requests: M2) -> Cuckoo.__DoNotUse<(String, [(request: ImageRequest, searchOption: SearchOption)]), Observable<[GenericPageThumbnail]>> where M1.MatchedType == String, M2.MatchedType == [(request: ImageRequest, searchOption: SearchOption)] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [(request: ImageRequest, searchOption: SearchOption)])>] = [wrap(matchable: keyword) { $0.0 }, wrap(matchable: requests) { $0.1 }]
	        return cuckoo_manager.verify("nextImages(_: String, requests: [(request: ImageRequest, searchOption: SearchOption)]) -> Observable<[GenericPageThumbnail]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class KakaoServiceTypeStub: KakaoServiceType {
    

    

    
     func nextImages(_ keyword: String, requests: [(request: ImageRequest, searchOption: SearchOption)]) -> Observable<[GenericPageThumbnail]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[GenericPageThumbnail]>).self)
    }
    
}

