//
//  ProductDetailManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 16/02/24.
//

import Foundation
import UIKit

protocol ProductDetailManagerDelegate {
    func didRecieveProductDetail(productDetail: Productdetail, relatedItems: [Productdetail])
    func didGetErrors(error: Error, response: HTTPURLResponse?)
}

struct ProductDetailManager {
    
    var delegate: ProductDetailManagerDelegate?
    
    func getProductDetail(sysid: String) {
        let url = "\(ApiConstants.baseUrl)view/product_detail/\(sysid)/"
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
                    let response = try decoder.decode(ProductResponse.self, from: safeData)
                    delegate?.didRecieveProductDetail(productDetail: response.productdetail, relatedItems: response.relateditems)
                } catch {
                    delegate?.didGetErrors(error: error, response: response as? HTTPURLResponse)
                }
            }
        }
        task.resume()
    }
    
}
