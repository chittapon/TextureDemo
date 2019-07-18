//
//  Network.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct Network {
    
    static func request<Target: TargetType>(target: Target) -> Observable<Response> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let provider = MoyaProvider<Target>()

            let task = provider.request(target, completion: { (result) in
                do {
                    let response = try result.get()
                    observer.onNext(response)
                    observer.onCompleted()
                }catch let error {
                    observer.onError(error)
                }
            })
            
            return Disposables.create {
                task.cancel()
            }
        })
        
    }
    
}
