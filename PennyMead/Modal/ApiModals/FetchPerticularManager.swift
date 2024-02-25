//
//  FetchPerticularCat.swift
//  PennyMead
//
//  Created by siddappa tambakad on 24/01/24.
//

import Foundation

protocol FetchPerticularManagerDelegate {
    func didUpdateThePerticularCat(_ perticularCat: [PerticularItemsFetch])
    func didUpdateTotalPages(_ totalPages: Int)
    func didGetTheCatDes(_ categorydescription: [CategoryDescription])
    func didGetErrors(error: Error, response: HTTPURLResponse?)
}

struct FetchPerticularManager {
    
    var delegate: FetchPerticularManagerDelegate?
    
    func getPerticularCategories(with category: String, filterType: String, page: Int) {
        guard let urlString = URL(string: "\(ApiConstants.baseUrl)view/category/\(category)/\(filterType)/\(page)/") else {
            print("Invalid URL")
            return
        }
        
        print(urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlString) { [self] data, response, error in
            if let error = error {
                delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                return
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(PerticularBooks.self, from: safeData)
                    delegate?.didUpdateThePerticularCat(response.data.data)
                    
                    let catDescription = response.categorydescription
                    delegate?.didGetTheCatDes(catDescription)
                    
                    let totalPage = response.data.totalpages
                    delegate?.didUpdateTotalPages(totalPage)
                } catch {
                    delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                    print("mainerror--->>", error)
                }
            }
        }
        task.resume()
    }
    
}
