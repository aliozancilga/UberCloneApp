//
//  RiderVC.swift
//  UberForRider
//
//  Created by Macbook on 4.02.2018.
//  Copyright © 2018 Ali Ozan. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController{


    @IBOutlet weak var myMap: MKMapView!
    private var locationManager = CLLocationManager()
    private var userLocation = CLLocationCoordinate2D()
    private var driverLocation = CLLocationCoordinate2D()
    
    private var timer = Timer()
    
    private var canCallUber = true
    private var riderCanceledRequest = false
    
    @IBOutlet weak var callUberBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        UberHandler.Instance.observerMessageForRider()
        UberHandler.Instance.delegate = self
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
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude )
            
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            myMap.setRegion(region, animated: true)
         myMap.removeAnnotations(myMap.annotations)
            
            if !canCallUber {
                let driverAnnotation = MKPointAnnotation()
                driverAnnotation.coordinate = driverLocation
                driverAnnotation.title = "Driver Location"
                myMap.addAnnotation(driverAnnotation)
                }
            
            let annotion = MKPointAnnotation();
            annotion.coordinate = userLocation
            annotion.title = "Rider Location"
            myMap.addAnnotation(annotion)
        }
        
    }
    
    @objc func updateRidersLocation(){
        UberHandler.Instance.updateRiderLocation(lat: userLocation.latitude, long: userLocation.longitude)
    }
    
    
    func canCallUber(delegateCalled: Bool) {
        if delegateCalled {
            callUberBtn.setTitle("Cancel Uber", for: UIControlState.normal)
            canCallUber = false
            
        }else{
            callUberBtn.setTitle("Call Uber", for: UIControlState.normal)
            canCallUber = true
        }
        
    }
    
    func updateDriversLocation(lat: Double, long: Double) {
        
        driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
    }
    
    @IBAction func callUber(_ sender: Any) {
        
        if canCallUber {
        UberHandler.Instance.requestUber(latitude: userLocation.latitude , longtitude: userLocation.longitude)
            
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(RiderVC.updateRidersLocation), userInfo: nil, repeats: true)
        }else{
            riderCanceledRequest = true
            //cancel uber
            UberHandler.Instance.cancelUber()
            timer.invalidate()
        }
    }
    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        if !riderCanceledRequest {
            if requestAccepted {
                alertTheUser(title: "Uber Accepted", message: "\(driverName) Accepted your Uber Request")
            }else{
                UberHandler.Instance.cancelUber()
                timer.invalidate()
                alertTheUser(title: "Uber Canceled", message: "\(driverName) Canceled Uber Request")
            }
        }
        riderCanceledRequest = false
    }
    
 
    @IBAction func logout(_ sender: Any) {
        
        if AuthProvider.Instance.logOut() {
            if !canCallUber{
                UberHandler.Instance.cancelUber()
                timer.invalidate()
            }
            dismiss(animated: true, completion: nil)
        }else{
            // problem logout about
            alertTheUser(title: "Could Not logout", message: "please try Again")
        }
 
    }
    private func alertTheUser(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }

}// Class End
