//
//  AuthProvider.swift
//  UberForDriver
//
//  Created by Macbook on 3.02.2018.
//  Copyright © 2018 Ali Ozan. All rights reserved.
//

import UIKit
import FirebaseAuth
typealias LoginHandler = (_ msg: String?) ->Void;

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Adress"
    static let WRONG_PASSWORD = "Wrong Password"
    static let PROBLEM_CONNECTING = "problem Connecting to Database"
    static let USER_NOT_FOUND = "User Not Found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Already using"
    static let WEAK_PASSWORD = "Weak Password"
}

class AuthProvider {
    
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider{
        return _instance
    }
    
    
    func  login(withEmail: String, withPassword: String, loginHandler: LoginHandler?){
        Auth.auth().signIn(withEmail: withEmail, password: withPassword, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            }else{
                loginHandler?(nil)
            }
            
          })
        
        }
    
    func signUp(withEmail: String, withPassword: String, loginHandler: LoginHandler?){
        Auth.auth().createUser(withEmail: withEmail, password: withPassword) { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
                
            }else{
                
                if user?.uid != nil {
                    // store the user Database
                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: withPassword)
                    
                    //sign in the user
                    self.login(withEmail: withEmail, withPassword: withPassword, loginHandler: loginHandler)
                }
                
            }
        }
    }
    func logOut() -> Bool {
       
        if Auth.auth().currentUser != nil {
            
             do{
                try Auth.auth().signOut()
                return true
            }
            catch {
                return false
            }
            
        }
        
        return true
        
        
  
    }
    
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?){
        if let errCode = AuthErrorCode(rawValue: err.code) {
            switch errCode {
            case .invalidEmail:
                    loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break;
            case .wrongPassword:
                loginHandler!(LoginErrorCode.WRONG_PASSWORD)
                break;
            case .emailAlreadyInUse:
                    loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break;
            case .tooManyRequests:
                print("many Request")
                break;
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break;
             case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break;
            default:
                loginHandler!(LoginErrorCode.PROBLEM_CONNECTING)
                break;
            
        }
     }
    }
    
}// Class


