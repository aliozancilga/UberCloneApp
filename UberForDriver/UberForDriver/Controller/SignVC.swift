//
//  SignVC.swift
//  UberForDriver
//
//  Created by Macbook on 3.02.2018.
//  Copyright © 2018 Ali Ozan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignVC: UIViewController {
private var DriverSeque = "DriverSegue"
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

     }

    @IBAction func logIn(_ sender: Any) {
        
 
        if EmailTextField.text! != "" && PasswordTextField.text! != "" {
            
            AuthProvider.Instance.login(withEmail: EmailTextField.text!, withPassword: PasswordTextField.text!, loginHandler: { (message) in
                if  message != nil {
                    self.alertTheUser(title: "Problem with Authentication", message: message!);
                }else{
                    UberHandler.Instance.driver = self.EmailTextField.text!

                    
                   // self.PasswordTextField.text = ""
                // self.EmailTextField.text = ""
                    UberHandler.Instance.driver = self.EmailTextField.text!
                    print("Driver name : \(UberHandler.Instance.driver)")
                    
                    self.performSegue(withIdentifier: self.DriverSeque, sender: nil)
                }
            })
            
        }else{
             alertTheUser(title: "Email and Password Are Requeired", message: "Please Enter Email in textfields")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
           if EmailTextField.text! != "" && PasswordTextField.text! != "" {
        
            AuthProvider.Instance.signUp(withEmail: EmailTextField.text!, withPassword: PasswordTextField.text!, loginHandler: { (message) in
                if  message != nil {
                    self.alertTheUser(title: "Problem with Creating A new User", message: message!)
                    
                    
                }else{
                    UberHandler.Instance.driver = self.EmailTextField.text!
                    print("Driver name : \(UberHandler.Instance.driver)")

                    //EmailTextField.text = ""
                    //PasswordTextField.text = ""
                    
                    self.performSegue(withIdentifier: self.DriverSeque, sender: nil)
                }
            })
        
           }else{
            
                alertTheUser(title: "Email and Password Are Requeired", message: "Please Enter Email in textfields")
        }
    }
    
    private func alertTheUser(title: String, message: String){
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    
    }
    
    
    
}
