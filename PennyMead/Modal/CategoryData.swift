//
//  CategoryData.swift
//  PennyMead
//
//  Created by siddappa tambakad on 05/01/24.
//

import Foundation

struct CategoryResponse: Codable {
    let status: Int
    let message: String
    let data: [Book]
}

struct Book: Codable {
    let name: String
    let author: String?
    let title: String?
    let category: String
    let image: [String]?
}

//Mark: COllectibles

struct CollectibleResponse: Codable {
    let status: Int
    let message: String
    let data: CollectiblesBook
}
struct CollectiblesBook: Codable {
    let totalpages: Int
    let data: [CollectibleItem]
}

struct CollectibleItem: Codable {
    let author: String
    let title: String
    let description: String
    let price: String
    let image: [String]
}

