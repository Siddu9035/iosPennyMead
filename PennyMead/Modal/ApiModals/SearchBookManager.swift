//
//  searchBookManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 26/01/24.
//

import Foundation
import UIKit

protocol SearchBookManagerDelegate {
    func didUpdateThePerticularCatSearch(_ perticularCat: [PerticularItemsFetch])
    func didUpdateTotalPages(_ totalPages: Int)
    func didGetErrors(error: Error, response: HTTPURLResponse?)
}

struct SearchBookManager {
    
     var delegate: SearchBookManagerDelegate?
    
    func searchCat(with term: String, adesc: Int, categoryNumber: Int, sortby: String, page: Int) {
        let urlComponents = URLComponents(string: ApiConstants.baseUrl + "view/search-keyword/")!
        print(urlComponents)
        
        let requestBody: [String: Any] = [
            "term": term,
            "adesc": adesc,
            "category_number": categoryNumber,
            "sortby": sortby,
            "page": page
        ]
        print(requestBody)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { [self] data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                        return
                    }
                    
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let response = try decoder.decode(SearchResults.self, from: data)
                            let response2 = response.searchresults
//                            print("search data ----->>>", response2)
                            self.delegate?.didUpdateThePerticularCatSearch(response2)
                            let totalPage = response.totalpages
                            self.delegate?.didUpdateTotalPages(totalPage)
                        } catch {
                            self.delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                            print("error search--->>>", error)
                        }
                    }
                }
            }
            task.resume()
            
        } catch {
            delegate?.didGetErrors(error: error, response: nil)
        }
    }
}
