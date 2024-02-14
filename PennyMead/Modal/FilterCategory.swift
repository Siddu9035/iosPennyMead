//
//  FilterCategory.swift
//  PennyMead
//
//  Created by siddappa tambakad on 13/02/24.
//

import Foundation
import UIKit

protocol FilterItemsBySubCatDelegate {
    func didGetErrors(error: Error, response: HTTPURLResponse?)
    func didUpdateTotalPages(_ totalPages: Int)
    func didRecieveDataForGetSub(response: [PerticularItemsFetch])
}

struct FilterItemsBySubCat {
    
    var delegate: FilterItemsBySubCatDelegate?
    
    func getFilterItemsBySubCat(category: String, referenceId: String, filterType: String, page: Int) {
        let url = "\(ApiConstants.baseUrl)view/search-by-subcat/\(category)/\(referenceId)/\(filterType)/\(page)/"
        print(url)
        let urlString = URL(string: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlString!) { data, response, error in
            if let error = error {
                delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
            }
            
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(FilteredData.self, from: safeData)
                    delegate?.didRecieveDataForGetSub(response: response.data.data)
                    let totaPage = response.data.totalpages
                    delegate?.didUpdateTotalPages(totaPage)
                } catch {
                    delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                }
            }
        }
        task.resume()
    }
}
