//
//  UseCaseProvider.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import Foundation

struct UseCaseProvider {
    
    let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    func makeMovieUseCase() -> MovieUseCase {
        return MovieUseCase(environment: environment)
    }
}
