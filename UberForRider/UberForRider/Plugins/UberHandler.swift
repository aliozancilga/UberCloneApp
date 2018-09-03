//
//  UberHandler.swift
//  UberForRider
//
//  Created by Macbook on 4.02.2018.
//  Copyright © 2018 Ali Ozan. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController:class {
    func canCallUber(delegateCalled: Bool)
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String)
    func updateDriversLocation(lat:Double,long: Double)
 
}

class UberHandler {
    
    private static let _instance = UberHandler()
    
    weak var delegate: UberController?
    
    var rider = ""
    var driver = ""
    var rider_id = ""
    
    static var Instance: UberHandler{
        return _instance
    }
    
    func observerMessageForRider(){
        // Rider Requested uber
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider {
                        self.rider_id = snapshot.key
                        self.delegate?.canCallUber(delegateCalled: true)
                        
                    }
                }
            }
        }
        // rider canceled uber
        DBProvider.Instance.requestRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider {
                        self.rider_id = snapshot.key
                        self.delegate?.canCallUber(delegateCalled: false)
                        
                    }
                }
            }
        }
     
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if self.driver == "" {
                        self.driver = name
                        self.delegate?.driverAcceptedRequest(requestAccepted: true, driverName: self.driver)
                    }
                }
            }
        }
        
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        self.delegate?.driverAcceptedRequest(requestAccepted: false, driverName: self.driver)
                    }
                }
            }
        }
        
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childChanged) { (snapshot : DataSnapshot) in
            if let data = snapshot.value as? NSDictionary{
                if let  name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        if let lat = data[Constants.LATITUDE] as? Double {
                            if let long = data[Constants.LONGITUDE] as? Double {
                                print("lat : \(lat) long: \(long)")
                                self.delegate?.updateDriversLocation(lat: lat, long: long)
                                
                            }
                        }
                    }
                    
                    
                }
            }
        }
        
        
    }
    
    
    func requestUber(latitude: Double, longtitude: Double){
        let data: Dictionary<String,Any> = [Constants.NAME:rider, Constants.LATITUDE: latitude, Constants.LONGITUDE: longtitude]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
    }
    
    func cancelUber(){
        DBProvider.Instance.requestRef.child(rider_id).removeValue()
    }
    
    func updateRiderLocation(lat:Double,long:Double){
        DBProvider.Instance.requestRef.child(rider_id).updateChildValues([Constants.LATITUDE: lat,Constants.LONGITUDE:long])
    }
    
}
