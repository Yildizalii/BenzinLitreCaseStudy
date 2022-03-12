//
//  MapViewController.swift
//  BenzinLitreCaseStudy
//
//  Created by Ali on 11.03.2022.
//

import UIKit
import MapKit
class MapViewController: UIViewController ,CLLocationManagerDelegate ,MKMapViewDelegate  {
    
    var chosenType = ""
    var chosenState = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        
        prepareRecognizer()
        prepareAnnotation()
    }
    
    func prepareRecognizer() {
        view.isUserInteractionEnabled = true
        let hidenRecognizer = UITapGestureRecognizer(target: self, action: #selector(hiddenAlert))
        view.addGestureRecognizer(hidenRecognizer)
    }
    
    func prepareAnnotation() {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: chosenLatitude, longitude: chosenLongitude)
        annotation.coordinate = coordinate
        annotation.title = chosenState
        annotation.subtitle = chosenType
        self.mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: chosenLatitude, longitude: chosenLongitude), span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func hiddenAlert() {
        view.endEditing(true)
    }
    
    @objc func tappedTaxiPng() {
        let alert = UIAlertController(title: "State", message: chosenState, preferredStyle: UIAlertController.Style.actionSheet)
        let mapsButton = UIAlertAction(title: "Harita", style: UIAlertAction.Style.default) { alertAction in
            if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
                let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                    if let placemarks = placemarks {
                        if placemarks.count > 0 {
                            let mkPlaceMark = MKPlacemark(placemark: placemarks[0])
                            let mapItem = MKMapItem(placemark: mkPlaceMark)
                            mapItem.name = self.chosenType
                            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                            mapItem.openInMaps(launchOptions: launchOptions)
                        }
                    }
                }
            }
        }
        alert.addAction(mapsButton)
        let exitButton = UIAlertAction(title: "Turn Back", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(exitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "annotationView"
        mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout   = true
            pinView?.image = UIImage(named: "taxi")
            pinView?.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedTaxiPng))
            pinView?.addGestureRecognizer(gestureRecognizer)
        }else {
            pinView?.annotation = annotation
        }
        return pinView
    }
}
