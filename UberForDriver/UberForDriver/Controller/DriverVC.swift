//
//  DriverVC.swift
//  UberForDriver
//
//  Created by Macbook on 4.02.2018.
//  Copyright © 2018 Ali Ozan. All rights reserved.
//

import UIKit
import MapKit

class DriverVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController{
    

    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var acceptUberBtn: UIButton!
    private var locationManager = CLLocationManager()
    private var userLocation = CLLocationCoordinate2D()
    private var riderLocation = CLLocationCoordinate2D()
   
    private var timer = Timer()
    
    
    private var acceptedUber = false;
    private var driverCanceledUber = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UberHandler.Instance.delegate = self
        UberHandler.Instance.observerMessageForDriver()
        initializeLocationManager()
     }

    private func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //if we have the coor from the manager
        if let location = locationManager.location?.coordinate {
                userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            myMap.setRegion(region, animated: true)
            myMap.removeAnnotations(myMap.annotations)
            
            if acceptedUber {
                let riderAnnotion = MKPointAnnotation()
                riderAnnotion.coordinate = riderLocation
                riderAnnotion.title = "Riders Location"
                myMap.addAnnotation(riderAnnotion)
            }
            
            let annotion = MKPointAnnotation();
            annotion.coordinate = userLocation
            annotion.title = "Driver Location"
            myMap.addAnnotation(annotion)
            
        }
    }
    
    func updateRidersLocation(lat:Double, long: Double){
        riderLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    
    
    func acceptUber(lat: Double, long: Double) {
        if !acceptedUber {
            uberRequest(title: "Uber Request", message: "You hava a request for an at this locaction LAT: \(lat), LONG: \(long) ", requestAlive: true)
        }
    }
    
    
    func riderCanceledUber(){
        if !driverCanceledUber {
            UberHandler.Instance.cancelUberForDriver()
            self.acceptedUber = false
            self.acceptUberBtn.isHidden = true
            uberRequest(title: "Uber Canceled", message: "The Rider has Canceled The Uber", requestAlive: false)
        }
    }
    @objc func updateDriversLocation() {
        UberHandler.Instance.updateDriverLocation(lat: userLocation.latitude, long: userLocation.longitude)
        
    }
    
    func uberCanceled() {
        acceptedUber = false;
        acceptUberBtn.isHidden = true
        // time invalidate
        timer.invalidate()
    }

    @IBAction func cancelUber(_ sender: Any) {
        if acceptedUber {
            driverCanceledUber = true
            acceptUberBtn.isHidden = true
            UberHandler.Instance.cancelUberForDriver()
            //invalidate Timer
            timer.invalidate()
        }
    
    }
    
    private func uberRequest(title:String, message:String, requestAlive: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if  requestAlive {
            let accept = UIAlertAction(title: "Accept", style: .default, handler: { (alertAction: UIAlertAction) in
                
                self.acceptedUber = true
                self.acceptUberBtn.isHidden = false
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(DriverVC.updateDriversLocation), userInfo: nil, repeats: true)
                UberHandler.Instance.uberAccepted(lat: Double(self.userLocation.latitude), long: Double(self.userLocation.longitude))
                
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(accept)
            alert.addAction(cancel)
            
        }else{
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            
            if acceptedUber{
                    acceptUberBtn.isHidden = true
                    UberHandler.Instance.cancelUberForDriver()
                    timer.invalidate()
            }
            
            dismiss(animated: true, completion: nil)

        }else{
            uberRequest(title:"Could Not logout", message: "please try Again", requestAlive: false)
            // problem logout about
         }
        
    }

 
    
}
