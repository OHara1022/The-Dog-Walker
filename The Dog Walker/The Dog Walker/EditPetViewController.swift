//
//  EditPetViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class EditPetViewController: UIViewController {
    
    
    @IBAction func savePetChanges(_ sender: Any) {
        
        //dev
        print("save pet changes")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPetEdit(_ sender: Any) {
        //dev
        print("canceil pet changes")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func changeImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: title, message: "OPEN CAMERA", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    
}
