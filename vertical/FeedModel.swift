//
//  FeedModel.swift
//  vertical
//
//  Created by Ari Fajrianda Alfi on 27/10/25.
//

struct Item: Hashable, Codable {
    let id: Int
    let title: String
    let subtitle: String
    let colourName: String
    let videoUrl: String
}

struct ItemList: Codable { let items: [Item] }
