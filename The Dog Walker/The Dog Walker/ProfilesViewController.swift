//
//  ProfilesViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/27/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class ProfilesViewController: UIViewController {
    
    //MARK: -- stored properties
    var currentClient: UserModel!
    var petRef: DatabaseReference!
    
    lazy var clientProfileVC: ClientProfileTableViewController = {
        
        let storyboard = UIStoryboard(name: "WalkerHome", bundle: .main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "clientDetails") as! ClientProfileTableViewController
        
        self.add(asChildViewController: viewController)
        
        return viewController
        
    }()
    
    lazy var petProfileVC: ClientPetTableViewController = {
        
        let storyboard = UIStoryboard(name: "WalkerHome", bundle: .main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "petDetails") as! ClientPetTableViewController
        
        self.add(asChildViewController: viewController)
        
        return viewController
        
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedController.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        updateView()
        
        clientProfileVC.clientNameLBL.text = currentClient.firstName! + " " + currentClient.lastName!
        clientProfileVC.clientEmaillLBL.text = currentClient.email!
        
        //if apt number add to address label
        if currentClient.aptNumber == ""{
            //dev
            print("APT HIT")
            //address w/ apt number
            self.clientProfileVC.clientAddressLBL.text = currentClient.address! + ". " + currentClient.city! + ", " + currentClient.state! + " " + currentClient.zipCode!
        }else{
            self.clientProfileVC.clientAddressLBL.text = currentClient.address! + ".  Apt. " + currentClient.aptNumber! + " " + currentClient.city! + ", " + currentClient.state! + " " + currentClient.zipCode!
        }

        
        petRef = Database.database().reference().child("pets")
        
        //observer for pet info
        petRef.child(currentClient.uid!).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //populate petModel w/ dictionary data
                let pet = PetModel(dictionary: dictionary)
                
                //populate label w/ data from FB
                self.clientProfileVC.clientEmergencyContantLBL.text = pet.emergencyContact!
                self.clientProfileVC.emergencyPhoneLBL.text = pet.emergencyPhone!
                
                self.petProfileVC.petNameLBL.text = pet.petName!
            }
            
        }, withCancel: nil)
        
        
    }
    
    
    func selectionDidChange(_ sender: UISegmentedControl){
        updateView()
    }
    
    
    func add(asChildViewController viewController: UIViewController){
        
        //add childVC
        addChildViewController(viewController)
        
        //add subview will VC view
        view.addSubview(viewController.view)
        
        //check is VC didMove
        viewController.didMove(toParentViewController: self)
        
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        //notify childVC
        viewController.willMove(toParentViewController: nil)
        
        //remove childV from superV
        viewController.view.removeFromSuperview()
        
        //notify childV
        viewController.removeFromParentViewController()
    }
    
    
    func updateView() {
        
        if segmentedController.selectedSegmentIndex == 0 {
            remove(asChildViewController: petProfileVC)
            add(asChildViewController: clientProfileVC)
        } else {
            remove(asChildViewController: clientProfileVC)
            add(asChildViewController: petProfileVC)
        }
    }
    
    
    
}
