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
    func didGetErrors(error: Error)
}

struct FetchPerticularManager {
    
    var delegate: FetchPerticularManagerDelegate?
    
    func getPerticularCategories(with category: String, filterType: String, page: Int) {
        let url = URL(string: "\(ApiConstants.baseUrl)view/category/\(category)/\(filterType)/\(page)/")!
//        print(url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [self] data, response, error in
            if let error = error {
                delegate?.didGetErrors(error: error)
               return
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(PerticularBooks.self, from: safeData)
                    self.delegate?.didUpdateThePerticularCat(response.data.data)
                    
//                    print(response.categorydescription)
                    let catDescription = response.categorydescription
                    self.delegate?.didGetTheCatDes(catDescription)
                    
                    let totalPage = response.data.totalpages
                    self.delegate?.didUpdateTotalPages(totalPage)
                } catch {
                    delegate?.didGetErrors(error: error)
                }
            }
        }
        task.resume()
    }
}
