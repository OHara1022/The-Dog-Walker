//
//  OwnerEditScheduleViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class OwnerEditScheduleViewController: UIViewController {
    
    
    //MARK: --stored properties
    var editSelectedSchedule: ScheduleModel!

    var dateHolder: String?

    //MARK: --outlets
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editTimeTF: UITextField!
    @IBOutlet weak var editDurationTF: UITextField!
    @IBOutlet weak var editPriceLBL: UILabel!
    @IBOutlet weak var editPetNameTF: UITextField!
    @IBOutlet weak var editSpecialInsTF: UITextField!
    @IBOutlet weak var editMedsTF: UITextField!

    //MARK: --viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //dev
        print(editSelectedSchedule.date!)
         print(editSelectedSchedule.scheduleKey!)
        
        editDateTF.text = editSelectedSchedule.date!
        editTimeTF.text = editSelectedSchedule.time!
        editDurationTF.text = editSelectedSchedule.duration!
        editPriceLBL.text = "$" + editSelectedSchedule.price!
        editPetNameTF.text = editSelectedSchedule.petName!
        editSpecialInsTF.text = editSelectedSchedule.specialIns!
        editMedsTF.text = editSelectedSchedule.meds!
        
        
       
    }

    
    //MARK: --actions
    @IBAction func saveEditChanges(_ sender: Any) {
   
        //return to details vc
        _ = navigationController?.popViewController(animated: true)
    }
    

}
