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

struct CollectibleResposnse: Codable {
    let status: Int
    let message: String
    let data: [Collectibles]
}

struct Collectibles: Codable {
    let author: String
    let title: String
    let description: String
    let price: String
    let image: [String]
}
