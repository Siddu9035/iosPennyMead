//
//  GetSubDropDownsManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 01/02/24.
//

import Foundation

protocol GetSubDropdownsManagerDelegate {
    func didGetError(error: Error)
}

struct GetSubDropdownsManager {
    var delegate: GetSubDropdownsManagerDelegate?
    
    func getSubDropdowns(with category: String) {
        
        let url = URL(string: "\(ApiConstants.baseUrl)view/getsubcat_dropdownlist/\(category)")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                delegate?.didGetError(error: error)
                return
            }
            
            if let safeData = data {
                do {
                   let decode = JSONDecoder()
                    decode.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decode.decode(Welcome.self, from: safeData)
                    print(response)
                } catch {
                    delegate?.didGetError(error: error)
                }
            }
        }
    }
}
