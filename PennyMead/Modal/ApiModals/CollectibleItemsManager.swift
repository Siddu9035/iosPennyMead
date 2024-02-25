//
//  CollectibleItemsManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 24/02/24.
//

import Foundation
protocol CollectibleItemsManagerDelegate {
    func didGetCollectibles(collectible: [Collectableitems])
    func didGetErrors(error: Error, response: HTTPURLResponse?)
}

struct CollectibleItemsManager {
    var delegate: CollectibleItemsManagerDelegate?
    
    func getCollectibles() {
        let urlString = URL(string: "\(ApiConstants.baseUrl)view/collectable_items/")!
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlString) { data, response, error in
            if let error = error {
                delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                return
            }
            if let safeData = data {
                do {
                  let decode = JSONDecoder()
                    decode.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decode.decode(Collectible.self, from: safeData)
                    print(response.collectableitems)
                    delegate?.didGetCollectibles(collectible: response.collectableitems)
                } catch {
                    delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                }
            }
        }
        task.resume()
    }
}
