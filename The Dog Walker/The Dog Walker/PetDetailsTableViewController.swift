//
//  PetDetailsTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class PetDetailsTableViewController: UITableViewController {

    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    //MARK: -- outlets
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var vaccineLabel: UILabel!
    @IBOutlet weak var medLabel: UILabel!
    @IBOutlet weak var specialInsLabel: UILabel!
    @IBOutlet weak var vetNameLabel: UILabel!
    @IBOutlet weak var vetPhoneLabel: UILabel!
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get ref to pets
        ref = Database.database().reference().child("pets").child(userID!)
        
        //set observor to get pet key
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            //loop thru snapshot to retrieve keys
            for keys in((snapshot.value as! NSDictionary).allKeys){
                //dev
                print(keys)
                //set key
                let key = keys
                
                //set observer w/ key to retrieve pet info
                self.ref.child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    //get snapcalue as dictionary
                let value = snapshot.value as? NSDictionary
                    
                    //set values
                    let petName = value?.value(forKey: "petName")
                    let bday = value?.value(forKey: "birthday")
                    let breed = value?.value(forKey: "breed")
                    let vaccine = value?.value(forKey: "vaccines")
                    let meds = value?.value(forKey: "meds")
                    let speicalIns = value?.value(forKey: "specialIns")
                    let vetName = value?.value(forKey: "vetName")
                    let vetPhone = value?.value(forKey: "vetPhone")
                    
                    //dev
                    print(petName!)
                    
                    //populate labels with passed values
                    self.petNameLabel.text = petName as? String
                    self.dateLabel.text = bday as? String
                    self.breedLabel.text = breed as? String
                    self.vaccineLabel.text = vaccine as? String
                    self.medLabel.text = meds as? String
                    self.specialInsLabel.text = speicalIns as? String
                    self.vetNameLabel.text = vetName as? String
                    self.vetPhoneLabel.text = vetPhone as? String
                    
                })
            }
            
        })
        
    }
    
    //MARK: -- actions
    @IBAction func addPet(_ sender: UIButton) {
        
        FieldValidation.textFieldAlert("Add Pet", message: "Add Pet will be in future release", presenter: self)
        
    }

   

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
