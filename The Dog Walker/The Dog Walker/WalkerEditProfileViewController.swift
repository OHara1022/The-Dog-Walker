//
//  WalkerEditProfileViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class WalkerEditProfileViewController: UIViewController {
    
    @IBAction func saveProfileChanges(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelEdit(_ sender: Any) {
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

        // Do any additional setup after loading the view.
    }



}
