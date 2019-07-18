//
//  MovieAPI.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import Foundation
import Moya

struct MovieAPI: TargetType {
    
    let baseURL: URL
    let path: String = "/3/movie/upcoming"
    let method: Moya.Method = .get
    let sampleData: Data = Data()
    let task: Task
    let headers: [String : String]? = nil
    let validationType: ValidationType = .successCodes
    
    init(baseURL: URL, parameters: [String: Any] = [:]) {
        self.baseURL = baseURL
        task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

}
