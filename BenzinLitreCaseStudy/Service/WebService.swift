//
//  WebService.swift
//  BenzinLitreCaseStudy
//
//  Created by Ali on 11.03.2022.
//

import Foundation


class Webservice {
    func downloadData(url: URL, completion: @escaping (TaxiListResponse?) ->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }else if let data = data {
               let list = try? JSONDecoder().decode(TaxiListResponse.self, from: data)
                if let list = list {
                    completion(list)
                }
            }
        }.resume()
    }
}
