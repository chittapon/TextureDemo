//
//  Environment.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import Foundation

struct Environment {
    #if DEBUG
    let baseURL = URL(string: "https://api.themoviedb.org")!
    let APIKey: String = "939df263ab4c2ba18a68a2f1a77e7507"
    #else
    let baseURL = URL(string: "https://api.themoviedb.org")!
    let APIKey: String = "939df263ab4c2ba18a68a2f1a77e7507"
    #endif
}
