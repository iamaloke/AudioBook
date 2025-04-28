//
//  AudioResponse.swift
//  AudioBook
//
//  Created by Alok Kumar on 27/04/25.
//

import Foundation

struct AudioResponse: Decodable {
    let resultCount: Int
    let results: [Audio]
}

struct Audio: Decodable, Hashable {
    //let artistId: Int
    let artistName: String
    let artworkUrl60: URL
    let artworkUrl100: URL
}
