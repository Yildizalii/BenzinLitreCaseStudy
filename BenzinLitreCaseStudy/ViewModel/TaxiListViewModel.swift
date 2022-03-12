//
//  TaxiListViewModel.swift
//  BenzinLitreCaseStudy
//
//  Created by Ali on 11.03.2022.
//

import Foundation

struct TaxiListViewModel {
    let responseList: [Info]
    
    func numberOfRowsInSection() -> Int {
        return self.responseList.count
    }
    
    func listIndex(_ index: Int) -> TaxiViewModel {
        let list = self.responseList[index]
        return TaxiViewModel(responseView: list)
    }
}


struct TaxiViewModel {
    
    let responseView: Info
    
    var id: Double {
        return responseView.id
    }
    
    var type: String {
        return responseView.type
    }
    
    var state: String {
        return responseView.state
    }
    
    var heading: Double {
        return responseView.heading
    }
    
    var coordinate: Coordinate {
        return responseView.coordinate
    }
}
