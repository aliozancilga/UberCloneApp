//
//  DBProvider.swift
//  UberForDriver
//
//  Created by Macbook on 4.02.2018.
//  Copyright © 2018 Ali Ozan. All rights reserved.
//
import Foundation
import FirebaseDatabase


class DBProvider {
    
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider{
        return _instance
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var driversRef : DatabaseReference {
        return dbRef.child(Constants.DRIVERS)
    }
    
    // request ref
    var requestRef: DatabaseReference {
        return dbRef.child(Constants.UBER_REQUEST)
    }
    

    // request accepted
    var requestAcceptedRef : DatabaseReference {
        return dbRef.child(Constants.UBER_ACCEPTED)
    }
    
    
    func saveUser(withID: String, email: String, password: String){
        let data: Dictionary<String, Any> = [Constants.EMAIL : email,Constants.PASSWORD: password,Constants.isRider: true]
        driversRef.child(withID).child(Constants.DATA).setValue(data)
        
    }
    
}// class End

