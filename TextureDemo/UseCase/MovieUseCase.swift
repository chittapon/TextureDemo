//
//  FeedUseCase.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

struct MovieUseCase {
    
    private let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    func getMovies(page: Int) -> Observable<MovieData> {
        
        let parameters: [String : Any] = ["page": page,
                                          "api_key": environment.APIKey]
        
        let target = MovieAPI(baseURL: environment.baseURL, parameters: parameters)
        
        return Network.request(target: target).map({ (response) -> MovieData in
            let json = try response.mapJSON()
            return try MovieData(JSONObject: json)
        })
    }
    
}
