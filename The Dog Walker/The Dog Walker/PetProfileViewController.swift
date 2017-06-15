//
//  PetProfileViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/14/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class PetProfileViewController: UIViewController {
    
    //enum for tab index
    enum SegmentIndex: Int {
        case petIndex = 0
        case ownerIndex = 1
    }
    
    //MARK: -- outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var profileView: UIView!

    //MARK: -- actions
    @IBAction func switchProfile(_ sender: UISegmentedControl) {
        //remove current vc from view on selection change
        self.currentVC!.view.removeFromSuperview()
        self.currentVC!.removeFromParentViewController()
        //display selected tab
        displaySelectedTab(sender.selectedSegmentIndex)
    }
    
    //transition to edit screen
    @IBAction func editProfile(_ sender: UIBarButtonItem) {
        //dev
        print("EDIT")
        
        //chekc selected VC
        if (selectedIndex(0) == currentVC){
            
            //present pet profile editVC
            show(editVC!, sender: nil)
            
        }else if selectedIndex(1) == currentVC{
            
              //present owner profile editVC
            present(editVC2!, animated: true, completion: nil)
        }
    }
    
    //MARK: -- stored properties
    var currentVC: UIViewController?
    
    //refenerce to pet profile VC - instantiant petProfilr VC
    lazy var petVC: UIViewController? = {
        //init petVC w/ identifier
        let petVC = self.storyboard?.instantiateViewController(withIdentifier: "petProfile")
        //return vc
        return petVC
    }()
    
    //reference to owner profiles VC - instantiant ownerProfile VC
    lazy var ownerVC: UIViewController? = {
        
        //init profileVC w/ identifier
        let ownerVC = self.storyboard?.instantiateViewController(withIdentifier: "ownerProfile")
        //return vc
        return ownerVC
    }()
    
    lazy var editVC: UIViewController? = {
        
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "editPet")
        return editVC
    }()
    
    lazy var editVC2: UIViewController? = {
        
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "tableTest2")
        return editVC
    }()
    
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set inital index for segmentController
        segmentedController.selectedSegmentIndex = SegmentIndex.petIndex.rawValue
        //display tab 1
        displaySelectedTab(SegmentIndex.petIndex.rawValue)
        
    }
    
    //MARK: --viewWillDisappear
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        if let currentVC = currentVC{
//            currentVC.viewWillDisappear(animated)
//        }
//    }
    
    //func to display current tab
    func displaySelectedTab(_ tabIndex: Int){
        
        //optional bind selectedVC
        if let selectedVC = selectedIndex(tabIndex){
            
            //add selected VC as childVC
            self.addChildViewController(selectedVC)
            //move selectedVC to partentVC
            selectedVC.didMove(toParentViewController: self)
            //add selectedVC as subView of parentVC
            self.profileView.addSubview(selectedVC.view)
            //add selected VC to currentVC
            self.currentVC = selectedVC
        }
    }
    
    //func for selectedIndex
    func selectedIndex(_ index: Int) -> UIViewController? {
        
        var selectedVC: UIViewController?
        
        //switch index
        switch index {
        //pet index
        case SegmentIndex.petIndex.rawValue:
            //set pet vc to selectedVC
            selectedVC = petVC
            
        //owner index
        case SegmentIndex.ownerIndex.rawValue:
            //set owner vc to selectedVC
            selectedVC = ownerVC
            
        default:
            break
        }
        
        //return selectedVC
        return selectedVC
    }
    
    
}

/*
 Reference: Abdurrahan, A. How to Switch View Contollers using Segmented Control - Swift 3.0, retrieved from https://ahmedabdurrahman.com/2015/08/31/how-to-switch-view-controllers-using-segmented-control-swift/
 */
