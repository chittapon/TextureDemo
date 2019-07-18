//
//  Movie.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 17/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieData: ImmutableMappable {
    
    let data: [Movie]
    let page: Int
    let totalPages: Int
    
    init(map: Map) throws {
        data = try map.value("results")
        page = try map.value("page")
        totalPages = try map.value("total_pages")
    }
}

struct Movie: ImmutableMappable {
    
    let title: String
    let overview: String
    var posterURL: URL?
    
    init(map: Map) throws {
        title = try map.value("title")
        overview = try map.value("overview")
        let posterPath: String? = try? map.value("poster_path")
        if let path = posterPath {
            posterURL = URL(string: "https://image.tmdb.org/t/p/w500")?.appendingPathComponent(path)
        }
    }
}
