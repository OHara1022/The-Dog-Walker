//
//  ClientDetailsViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class ClientDetailsViewController: UIViewController {
    
    //enum for tab index
    enum SegmentTabIndex: Int {
        case clientIndex = 0
        case petIndex = 1
    }

    //MARK: -- stored properties
    var currentViewController: UIViewController?
    
    //reference to client detailsVC - instantiant clientDetails VC
    lazy var clientVC: UIViewController? = {
        
        //init clientVC - instantiant clientDetails VC
        let clientVC = self.storyboard?.instantiateViewController(withIdentifier: "clientDetails")
        //return vc
        return clientVC
    }()
    
    //reference to pet detailsVC - instantiant petDetails VC
    lazy var petVC: UIViewController? = {
        
        //init petVC - instantiant petDetails VC
        let petVC = self.storyboard?.instantiateViewController(withIdentifier: "petDetails")
        //return vc
        return petVC
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set inital index for segment control
        segmentedControl.selectedSegmentIndex = SegmentTabIndex.clientIndex.rawValue
        //display tab 1
        displayCurrentView(SegmentTabIndex.clientIndex.rawValue)
        
    }
    
    //MARK: -- actions
    @IBAction func switchProfile(_ sender: UISegmentedControl) {
        
        //remove current vc from view on selection change
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        //display selected tab
        displayCurrentView(sender.selectedSegmentIndex)
        
    }
    
    //display current tab
    func displayCurrentView(_ tabIndex: Int){
        
        //optional bind selectedVC
        if let selectedVC = selectedIndex(tabIndex){
            
            //add selected vc as child
            self.addChildViewController(selectedVC)
            //move selected to parent vc
            selectedVC.didMove(toParentViewController: self)
            //add selected as subview of container view
            self.containerView.addSubview(selectedVC.view)
            //add selected to current vc
            self.currentViewController = selectedVC
        }
        
    }
    
    //get selected index
    func selectedIndex(_ index: Int) -> UIViewController?{
        
        //VC to hold selected vc
        var selectedVC: UIViewController?
        
        //switch index
        switch index {
        //client index
        case SegmentTabIndex.clientIndex.rawValue:
            //set client vc to selected
            selectedVC = clientVC
            
        //pet index
        case SegmentTabIndex.petIndex.rawValue:
            //set pet vc to selected
            selectedVC = petVC
            
        default:
            break
        }
        
        return selectedVC
    }
    
}
