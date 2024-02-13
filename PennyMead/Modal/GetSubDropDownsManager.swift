//
//  GetSubDropDownsManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 01/02/24.
//

import Foundation

protocol GetSubDropdownsManagerDelegate {
    func didGetSubDropdowns(response: [DropdownGroup])
    func didGetError(error: Error)
}

struct GetSubDropdownsManager {
    var delegate: GetSubDropdownsManagerDelegate?
    
    func getSubDropdowns(with category: String) {
        
        let url = URL(string: "\(ApiConstants.baseUrl)view/getsubcat_dropdownlist/\(category)/")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                delegate?.didGetError(error: error)
                return
            }
            
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(ResponseData.self, from: safeData)
                    let categoryData = responseData
//                    print(categoryData.data[1].dropdownlist)
                    delegate?.didGetSubDropdowns(response: categoryData.data)
                } catch let error {
                    print("Error decoding JSON: \(error)")
                    delegate?.didGetError(error: error)
                }
            }
        }
        task.resume()
    }
}
