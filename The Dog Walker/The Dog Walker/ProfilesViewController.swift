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
        
        self.add(viewController: viewController)
        
        return viewController
        
    }()
    
    lazy var petProfileVC: ClientPetTableViewController = {
        
        let storyboard = UIStoryboard(name: "WalkerHome", bundle: .main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "petDetails") as! ClientPetTableViewController
        
        self.add(viewController: viewController)
        
        return viewController
        
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //method to show proper VC on value change
        segmentedController.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        //updateView
        updateView()
        
        //set labels text w/ proper client data
        clientProfileVC.clientNameLBL.text = currentClient.firstName! + " " + currentClient.lastName!
        clientProfileVC.clientEmaillLBL.text = currentClient.email!
        clientProfileVC.clientPhoneLBL.text = currentClient.phoneNumber!
        
        //if apt number add to address label
        if currentClient.aptNumber == ""{
            //dev
            print("APT HIT")
            //address w/ apt number
            self.clientProfileVC.clientAddressLBL.text = currentClient.address! + ". " + currentClient.city! + ", " + currentClient.state! + " " + currentClient.zipCode!
        }else{
            self.clientProfileVC.clientAddressLBL.text = currentClient.address! + ". Apt. " + currentClient.aptNumber! + " " + currentClient.city! + ", " + currentClient.state! + " " + currentClient.zipCode!
        }
        
        if let profileImgURL = currentClient.profileImage{
            
            print(profileImgURL)
            
            self.clientProfileVC.clientProfileImg.loadImageUsingCache(profileImgURL)
        }
        

        //get ref to pets in DB
        petRef = Database.database().reference().child("pets")
        
        //observer for pet info
        petRef.child(currentClient.uid!).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //populate petModel w/ dictionary data
                let pet = PetModel(dictionary: dictionary)
                
                if let petImgURL = pet.petImage{
                    //dev
                    print(petImgURL)
                    //set image to imageView
                    self.petProfileVC.clientPetImg.loadImageUsingCache(petImgURL)
                }
                
                
                //populate label w/ data from FB
                self.clientProfileVC.clientEmergencyContantLBL.text = pet.emergencyContact!
                self.clientProfileVC.emergencyPhoneLBL.text = pet.emergencyPhone!
                
                self.petProfileVC.petNameLBL.text = pet.petName!
                self.petProfileVC.bdayLBL.text = pet.birthday!
                self.petProfileVC.breedLBL.text = pet.breed!
                self.petProfileVC.vaccineLBL.text = pet.vaccines!
                self.petProfileVC.medsLBL.text = pet.meds
                self.petProfileVC.specialInsLBL.text = pet.specialIns!
                self.petProfileVC.vetNameLBL.text = pet.vetName!
                self.petProfileVC.vetPhoneLBL.text = pet.vetPhone!
  
            }
            
        }, withCancel: nil)
    }
    
}

//MARK: -- extension for funtionality
extension ProfilesViewController{
    
    //check segment change
    func selectionDidChange(_ sender: UISegmentedControl){
        //update to current VC
        updateView()
    }
    
    //add VC as subView to mainVC
    func add(viewController: UIViewController){
        
        //add childVC
        addChildViewController(viewController)
        
        //add subview will VC view
        view.addSubview(viewController.view)
        
        //check is VC didMove
        viewController.didMove(toParentViewController: self)
        
    }
    
    //remove VC remove VC from parent on change
    func remove(viewController: UIViewController) {
        //notify childVC
        viewController.willMove(toParentViewController: nil)
        
        //remove childV from superV
        viewController.view.removeFromSuperview()
        
        //notify childV
        viewController.removeFromParentViewController()
    }
    
    //update view on segment index
    func updateView() {
        
        //check index
        if segmentedController.selectedSegmentIndex == 0 {
            //remove VC
            remove(viewController: petProfileVC)
            //add VC
            add(viewController: clientProfileVC)
        } else {
            //removeVC
            remove(viewController: clientProfileVC)
            //add VC
            add(viewController: petProfileVC)
        }
    }

    
}
