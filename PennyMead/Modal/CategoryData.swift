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

//MARK: COllectibles

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

//MARK: catlouge page
struct PerticularBooks: Codable {
    let data: PerticularItemsData
    let categorydescription: [CategoryDescription]
}

struct PerticularItemsData: Codable {
    let data: [PerticularItemsFetch]
    let totalpages: Int
}

struct PerticularItemsFetch: Codable {
    let sysid: String
    let author: String
    let title: String
    let description: String
    let price: String
    let image: [String]
}

struct CategoryDescription: Codable {
    let categoryDescription: String
}
//MARK: search cat
struct SearchResults: Codable {
    let searchresults: [PerticularItemsFetch]
    let totalpages: Int
}

//MARK: subdropdowncat
// MARK: - Welcome
struct Welcome: Codable {
    let status: Int
    let message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let name: Name
    let dropdownlist: [Dropdownlist]
}

// MARK: - Dropdownlist
struct Dropdownlist: Codable {
    let name: String
    let thegroup: Name
    let reference: String
}

enum Name: String, Codable {
    case subject = "Subject"
    case wIIslands = "W. I. islands"
}
