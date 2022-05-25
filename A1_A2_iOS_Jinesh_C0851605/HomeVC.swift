//
//  HomeVC.swift
//  A1_A2_iOS_Jinesh_C0851605
//
//  Created by Jinesh Patel on 24/05/22.
//

import UIKit
import MapKit
import CoreLocation

class HomeVC: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var arrCity : [MKMapItem] = []
                                    	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.mapView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        print("longpressed")
        let alert = UIAlertController(title: "Lab Test 1-2", message: "Add city?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchCityVC") as! SearchCityVC
            searchVC.mapView = self.mapView
            searchVC.delegate = self
            self.navigationController?.pushViewController(searchVC, animated: true)
          }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          
          }))

        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func barBtnAddTap(_ sender: Any) {
        
        
        
        
    }
    
}
extension HomeVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
            self.mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
//            var coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            mapView.addAnnotation(annotation)
            
        }
    }
}

extension HomeVC : SearchCityResult {
    
    func searchedCity(item: MKMapItem) {
        arrCity.append(item)
        
        var annotations = [MKAnnotation]()
        
        for i in 0..<arrCity.count {
            let annotation = MKPointAnnotation()
            if i == 0 {
                annotation.title = "A"
            } else if i == 1 {
                annotation.title = "B"
            } else if i == 2 {
                annotation.title = "C"
            } else {
                annotation.title = ""
            }
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: arrCity[i].placemark.coordinate.latitude, longitude: arrCity[i].placemark.coordinate.longitude)
            annotations.append(annotation)

        }
       
        
        mapView.addAnnotations(annotations)
        
        mapView.fitAll(in: annotations, andShow: true)
//        if let lastAnnotation = annotations.last {
//            let region = MKCoordinateRegion(center: lastAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
//            mapView.setRegion(region, animated: true)
//        }
    }
    
    
}
extension MKMapView {

    /// When we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect       = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect            = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }

    /// We call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect:MKMapRect  = MKMapRect.null
    
        for annotation in annotations {
            let aPoint          = MKMapPoint(annotation.coordinate)
            let rect            = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
        
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }

}
