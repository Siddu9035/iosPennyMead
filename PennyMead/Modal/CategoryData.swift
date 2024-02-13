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

struct ResponseData: Codable {
    let status: Int
    let message: String
    let data: [DropdownGroup]
}
struct DropdownGroup: Codable {
    let name: String
    let dropdownlist: [DropdownItem]
}
struct DropdownItem: Codable {
    let name: String
    let keywords: String
    let toshow: String
    let thegroup: String
    let reference: String
    let icount: String
}
//MARK: onclick get subcat
struct FilteredData: Codable {
    let status: Int
    let message: String
    let data: SecondData
}

struct SecondData: Codable {
    let data: [PerticularItemsFetch]
    let relateddata: [PerticularItemsFetch]
    let totalpages: Int
}
