//
//  WalkerEditScheduleViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class WalkerEditScheduleViewController: UIViewController {
    
    //MARK: --stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var editSelectedSchedule: ScheduleModel!
    var scheduleKey: String?
    
    //MARK: --outlets
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editTimeTF: UITextField!
    @IBOutlet weak var editDurationTF: UITextField!
    @IBOutlet weak var editPriceTF: UITextField!
    @IBOutlet weak var editPetNameTF: UITextField!
    @IBOutlet weak var editSpecialInsTF: UITextField!
    
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: --actions
    @IBAction func saveChangesBTN(_ sender: Any) {
        //dev
        print("save edit")
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelEditBTN(_ sender: Any) {
        //dev
        print("cancel edit")
        dismiss(animated: true, completion: nil)

    }





}
