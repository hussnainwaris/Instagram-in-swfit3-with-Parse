//
//  UserTableViewController.swift
//  InstaParse
//
//  Created by MacBook Pro on 04/04/2017.
//  Copyright © 2017 apphouse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {

    var currentUsers = [""]
    var userIds = [""]
    var isFollowing = ["" : false]
    @IBAction func logOut(_ sender: Any) {
        
        PFUser.logOut()
        
        PFUser.logOutInBackground { (error) in
            if error != nil{
                print("Logout error")
                print(error.debugDescription)
            }else{
                self.performSegue(withIdentifier: "logOutSegue", sender: self)

            }
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    override func viewDidLoad() {
        super.viewDidLoad()

      
        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, error) in
           
        
            if error != nil{
                print(error.debugDescription)
            }else if let users = objects{
            
                self.currentUsers.removeAll()
                self.isFollowing.removeAll()
                self.userIds.removeAll()

                for object in users{
                
                    if let user = object as? PFUser{
                    
                        if user.objectId != PFUser.current()?.objectId!{
                        
                        let usersArray = user.username!.components(separatedBy: "@")
                        self.currentUsers.append(usersArray[0])
                        self.userIds.append(user.objectId!)
                        
                        let query = PFQuery(className: "Followers")
                        query.whereKey("follower", equalTo: PFUser.current()?.objectId!)
                        query.whereKey("following", equalTo: user.objectId!)
                        
                        query.findObjectsInBackground(block: { (objects, error) in
                            if let object = objects{
                                if object.count > 0 {
                                    self.isFollowing[user.objectId!] = true
                                }else{
                                    self.isFollowing[user.objectId!] = false
                                }
                                
                                if self.isFollowing.count == self.currentUsers.count{
                                
                                    self.tableView.reloadData()

                                }
                            }
                            
                        })
                    }
                        
                }
                    
                }
            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = currentUsers[indexPath.row]
        
        if isFollowing[userIds[indexPath.row]]! {
        
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if isFollowing[userIds[indexPath.row]]!{
        
            isFollowing[userIds[indexPath.row]] = false
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let query = PFQuery(className: "Followers")
            query.whereKey("follower", equalTo: PFUser.current()?.objectId)
            query.whereKey("following", equalTo: userIds[indexPath.row])
            query.findObjectsInBackground(block: { (objects, error) in
                if let objects = objects{
                
                    for object in objects{
                    
                        object.deleteInBackground()
                    }
                }
            })
            
            
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
            isFollowing[userIds[indexPath.row]] = true
            let following = PFObject(className: "Followers")
            following["follower"] = PFUser.current()?.objectId
            following["following"] = userIds[indexPath.row]
    
            following.saveInBackground()
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
