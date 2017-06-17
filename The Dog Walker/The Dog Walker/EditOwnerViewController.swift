//
//  EditOwnerViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class EditOwnerViewController: UIViewController {
    
    @IBAction func saveOwnerChanges(_ sender: Any) {
        
        //dev
        print("save owner changes")
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cancelEditOwner(_ sender: Any) {
        
        //dev
        print("cancel owner changes")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: title, message: "OPEN CAMERA", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



}
