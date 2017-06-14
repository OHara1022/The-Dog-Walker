//
//  PetProfileViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/14/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class PetProfileViewController: UIViewController {
    
    //MARK: -- 0utlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var profileView: UIView!
    
    //enum for tab index
    enum SegmentIndex: Int {
        case petIndex = 0
        case ownerIndex = 1
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
    
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedController.selectedSegmentIndex = SegmentIndex.petIndex.rawValue
        displayCurrentTab(SegmentIndex.petIndex.rawValue)
    }
  
    
    
    func displayCurrentTab(_ tabIndex: Int){
        
        //optional bind
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
    
    
    func selectedIndex(_ index: Int) -> UIViewController? {
        
        var selectedVC: UIViewController?
        
        switch index {
            
        case SegmentIndex.petIndex.rawValue:
            selectedVC = petVC
            
        default:
            break
        }
        return selectedVC
    }
    

}

/*
 Reference: Abdurrahan, A. How to Switch View Contollers using Segmented Control - Swift 3.0, retrieved from https://ahmedabdurrahman.com/2015/08/31/how-to-switch-view-controllers-using-segmented-control-swift/
 */
