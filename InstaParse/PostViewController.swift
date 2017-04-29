//
//  PostViewController.swift
//  InstaParse
//
//  Created by MacBook Pro on 07/04/2017.
//  Copyright © 2017 apphouse. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func createAlert(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        
            imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var imageDescription: UITextField!
    
    
    @IBAction func postImage(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Posts")
        
        post["message"] = imageDescription.text
        
        post["userId"] = PFUser.current()?.objectId!
        
        let data = UIImagePNGRepresentation(imageView.image!)
        
        let imageFile = PFFile(name: "image.png", data: data!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackground { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if error != nil{
            
                self.createAlert(title: "Image not saved", message: "Image could not be saved")
                
            }else{
            
                self.createAlert(title: "Image Saved", message: "Image Saved successfully")
                self.imageDescription.text = ""
                self.imageView.image = UIImage(named: "profile-icon-28.png")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
