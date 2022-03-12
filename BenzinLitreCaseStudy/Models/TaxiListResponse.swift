//
//  TaxiListResponse.swift
//  BenzinLitreCaseStudy
//
//  Created by Ali on 11.03.2022.
//

import Foundation

struct TaxiListResponse: Decodable {
    var poiList: [Info]
}

struct Info: Decodable {
    var id: Double
    var coordinate: Coordinate
    var state: String
    var type: String
    var heading: Double
}


struct Coordinate: Decodable {
    var latitude: Double
    var longitude: Double
}
