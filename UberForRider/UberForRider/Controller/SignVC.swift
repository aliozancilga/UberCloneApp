//
//  SignViewController.swift
//  UberForRider
//
//  Created by Macbook on 3.02.2018.
//  Copyright © 2018 Ali Ozan. All rights reserved.
//

import UIKit

class SignVC: UIViewController {
    private let RIDER_SEGUE = "riderSegue"


    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logIn(_ sender: Any) {

     
        
        if EmailTextField.text! != "" && PasswordTextField.text! != "" {

            AuthProvider.Instance.login(withEmail: EmailTextField.text!, withPassword: PasswordTextField.text!, loginHandler: { (message) in
                if  message != nil {
                    self.alertTheUser(title: "Problem with Authentication", message: message!)

                }else{
                    UberHandler.Instance.rider = self.EmailTextField.text!
                    
                    
                    print("Rider name : \(UberHandler.Instance.rider)")

                    //self.EmailTextField.text = ""
                    //self.PasswordTextField.text = ""
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)

                }
            })

        }else{
            alertTheUser(title: "Email and Password Are Requeired", message: "Please Enter Email in textfields")
        }

        
        
    }
  
    @IBAction func signUp(_ sender: Any) {
        if EmailTextField.text! != "" && PasswordTextField.text! != "" {

            AuthProvider.Instance.signUp(withEmail: EmailTextField.text!, withPassword: PasswordTextField.text!, loginHandler: { (message) in
                if message != nil{
                    self.alertTheUser(title: "Problem with Creating A new User", message: message!)
                }else{
                    UberHandler.Instance.rider = self.EmailTextField.text!
                    
                    print("Rider name : \(UberHandler.Instance.rider)")
                    
                    //self.EmailTextField.text = ""
                    //self.PasswordTextField.text = ""
                     self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)

                }

            })

        }else{
            alertTheUser(title: "Email and Password Are Required", message: "Please Enter Email in textfields")

            
        }
        
    
    }
    
    private func alertTheUser(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        
    }

}
