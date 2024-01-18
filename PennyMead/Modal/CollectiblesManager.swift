//
//  CollectiblesManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 12/01/24.
//

import Foundation

protocol collectibleManagerDelegate {
    func didUpdateTheCollectibles(_ collectibles: [CollectibleItem])
    func didUpdateTotalPages(_ totalPages: Int)
    func didGetError(error: Error)
}

struct CollectiblesManager {
    
    var delegate: collectibleManagerDelegate?
    
    
    func getCollectibles(with filterType: String, page: Int) {
        let urlString = URL(string: "\(ApiConstants.baseUrl)view/allCategoryData/\(filterType)/\(page)/")!
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlString) { data, response, error in
            if let error = error{
                self.delegate?.didGetError(error: error)
                return
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let collectibeleResponse = try decoder.decode(CollectibleResponse.self, from: safeData)
                    let collectibleData = collectibeleResponse.data
                    let collectibles = collectibleData.data
                    self.delegate?.didUpdateTheCollectibles(collectibles)
                    
                    let totalPage = collectibleData.totalpages
                    self.delegate?.didUpdateTotalPages(totalPage)
                    print("--------->>\(totalPage)")
                } catch {
                    self.delegate?.didGetError(error: error)
                }
            }
        }
        task.resume()
    }
}
