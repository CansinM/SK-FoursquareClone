//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Cansın Memiş on 14.03.2025.
//

import UIKit
import MapKit
import ParseSwift

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.done, target: self, action: #selector(backButton))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annocation = MKPointAnnotation()
            annocation.coordinate = coordinates
            annocation.title = PlaceModel.sharedInstance.placeName
            annocation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annocation)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButton() {
        //PARSE
        let placeModel = PlaceModel.sharedInstance
        
        var object = Place()
        object.name = placeModel.placeName
        object.type = placeModel.placeType
        object.atmosphere = placeModel.placeAtmosphere
        object.latitude = placeModel.placeLatitude
        object.longitude = placeModel.placeLongitude

        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object.image = try? ParseFile(name: "image.jpg", data: imageData)
        }
        
        object.save { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
                }
            case .failure(let error):
                let makeAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                makeAlert.addAction(okAction)
                self.present(makeAlert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
