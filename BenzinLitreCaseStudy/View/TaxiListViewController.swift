//
//  TaxiListViewController.swift
//  BenzinLitreCaseStudy
//
//  Created by Ali on 11.03.2022.
//

import UIKit

class TaxiListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedType = ""
    var selectedState = ""
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    
    @IBOutlet weak var tableView: UITableView!
    private var listViewModel: TaxiListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    
    func getData() {
        let url = URL(string: "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891")!
        Webservice().downloadData(url: url) { [weak self] taxiList in
            if let taxiList = taxiList {
                self?.listViewModel = TaxiListViewModel(responseList: taxiList.poiList.filter{$0.state != "INACTIVE"})
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listViewModel == nil ? 0 : self.listViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaxiTableViewCell
        let viewModel = self.listViewModel.listIndex(indexPath.row)
        cell.idLabel.text = "Id: \(viewModel.id)"
        cell.stateLabel.text = "State: \(viewModel.state)"
        cell.typeLabel.text = "Type : \(viewModel.type)"
        cell.latitudeLabel.text = "Latitude: \(viewModel.coordinate.latitude)"
        cell.longitudeLabel.text = "Longitude: \(viewModel.coordinate.longitude)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = listViewModel.listIndex(indexPath.row).type
        selectedState = listViewModel.listIndex(indexPath.row).state
        selectedLatitude = listViewModel.listIndex(indexPath.row).coordinate.latitude
        selectedLongitude = listViewModel.listIndex(indexPath.row).coordinate.longitude
        
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.chosenType = selectedType
            destinationVC.chosenState = selectedState
            destinationVC.chosenLatitude = selectedLatitude
            destinationVC.chosenLongitude = selectedLongitude
        }
    }
}

