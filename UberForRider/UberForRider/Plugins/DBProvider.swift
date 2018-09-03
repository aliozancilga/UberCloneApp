//
//  DBProvider.swift
//  UberForRider
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
    
    var ridersRef : DatabaseReference {
        return dbRef.child(Constants.RIDERS)
    }
    
    // request ref
    
    var requestRef: DatabaseReference {
        return dbRef.child(Constants.UBER_REQUEST)
    }
    //request accept
    var requestAcceptedRef : DatabaseReference {
        return dbRef.child(Constants.UBER_ACCEPTED)
    }
    
    
    // request accepted
 
    func saveUser(withID: String, email: String, password: String){
        let data: Dictionary<String, Any> = [Constants.EMAIL : email,
                                             Constants.PASSWORD: password,
                                            Constants.isRider: false]
        ridersRef.child(withID).child(Constants.DATA).setValue(data)
        
    }
    
}// class End

