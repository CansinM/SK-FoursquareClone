//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Cansın Memiş on 14.03.2025.
//

import UIKit
import MapKit
import ParseSwift

class DetailsVC: UIViewController {
    
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
                }            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
            
        }
    }
}
