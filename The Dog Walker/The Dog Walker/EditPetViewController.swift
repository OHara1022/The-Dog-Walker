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
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}