//
//  ViewController.swift
//  InstaParse
//
//  Created by MacBook Pro on 20/10/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var signUpMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    func createAlert(title:String,message:String){
    
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func signupLogin(_ sender: Any) {
        

        if emailTextField.text == "" || passwordTextField.text == "" {
        createAlert(title: "error in form", message: "Please enter an email and password")
            
        }else{
        
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            activityIndicator.center = self.view.center
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode{
            
                //sign up
                
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()

                    if error != nil{
                        var displayMessage = "Please try again later"
                        if let errorMessage = (error?.localizedDescription){
                            displayMessage = errorMessage
                        }
                    self.createAlert(title: "Signup error", message: displayMessage)
                    }else{
                    
                        self.performSegue(withIdentifier: "goToUserTable", sender: self)
                        print("user signed")
                    }
                })
                
            }else{
            
                //log in
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil{
                    
                        var displayMessage = "Please try again later"
                        if let errorMessage = error?.localizedDescription{
                            displayMessage = errorMessage
                        }
                        self.createAlert(title: "Signup error", message: displayMessage)
                        
                    }else{
                    
                        self.performSegue(withIdentifier: "goToUserTable", sender: self)
                        print("logged in")
                    }
                })
                
            }
            
        }
    }
    
    @IBOutlet var messageText: UILabel!
    @IBOutlet var signupOrLogin: UIButton!
    
    @IBOutlet var changeSignupLoginButton: UIButton!
    
    @IBAction func changeSignupOrLogin(_ sender: Any) {
        
        if signUpMode{
        
            messageText.text = "Dont have an account"
            signupOrLogin.setTitle("Log In", for: [])
            changeSignupLoginButton.setTitle("Sign up", for: [])
            signUpMode = false
        }else{
        
            signupOrLogin.setTitle("Sign up", for: [])
            changeSignupLoginButton.setTitle("Log In", for: [])
            messageText.text = "Already have an account"
            signUpMode = true
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      
        if PFUser.current() != nil{
            //performSegue(withIdentifier: "goToUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

 
