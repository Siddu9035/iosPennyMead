//
//  CategoryManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 12/01/24.
//

import Foundation
import UIKit

protocol categoryManagerDelegate {
    func categoriesDidFetch(categories: [Book])
    func didFailWithError(error: Error, response: HTTPURLResponse?)
}


struct CategoryManager {
    
    var delegate: categoryManagerDelegate?
    func getCategories() {
        let urlString = URL(string: "\(ApiConstants.baseUrl)view/categories/")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlString) { data, response, error in
            if let error = error {
                self.delegate?.didFailWithError(error: error, response: response as? HTTPURLResponse)
                return
            }
            
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let categoryResponse = try decoder.decode(CategoryResponse.self, from: safeData)
                    let categories = categoryResponse.data
                    self.delegate?.categoriesDidFetch(categories: categories)
                } catch {
                    self.delegate?.didFailWithError(error: error, response: response as? HTTPURLResponse)
                }
            }
        }
        task.resume()
    }
    
}
