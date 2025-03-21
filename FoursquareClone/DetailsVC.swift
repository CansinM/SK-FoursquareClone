//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Cansın Memiş on 14.03.2025.
//

import UIKit
import MapKit
import ParseSwift

class DetailsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        detailsMapView.delegate = self
    }
    
    func getDataFromParse() {
        var query = Place.query("objectId" == chosenPlaceId)
        
        query.first { result in
            switch result {
            case .success(let chosenPlaceObject):
                self.detailsNameLabel.text = chosenPlaceObject.name ?? "No Name"
                self.detailsTypeLabel.text = chosenPlaceObject.type ?? "No Type"
                self.detailsAtmosphereLabel.text = chosenPlaceObject.atmosphere ?? "No Atmosphere"
                
                if let latitude = Double(chosenPlaceObject.latitude ?? "") {
                    self.choosenLatitude = latitude
                }
                
                if let longitude = Double(chosenPlaceObject.longitude ?? "") {
                    self.choosenLongitude = longitude
                }
                
                if let imageFile = chosenPlaceObject.image {
                    imageFile.fetch { result in
                        switch result {
                        case .success(let fetchedFile):
                            if let data = try? Data(contentsOf: fetchedFile.url!) {
                                self.detailsImageView.image = UIImage(data: data)
                            } else {
                                print("Failed to convert file to data")
                            }
                        case .failure(let error):
                            print("Error loading image file: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
            
            let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
            let region = MKCoordinateRegion(center: location, span: span)
            self.detailsMapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.detailsNameLabel.text
            annotation.subtitle = self.detailsTypeLabel.text
            self.detailsMapView.addAnnotation(annotation)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLatitude != 0.0 && self.choosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude:self.choosenLatitude, longitude: self.choosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks{
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}
