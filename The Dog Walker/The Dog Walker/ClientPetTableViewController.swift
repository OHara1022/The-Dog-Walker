//
//  ClientPetTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class ClientPetTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var petDetails: PetModel!
    
    //MARK: -- outles
    @IBOutlet weak var clientPetImg: UIImageView!
    @IBOutlet weak var petNameLBL: UILabel!
    @IBOutlet weak var bdayLBL: UILabel!
    @IBOutlet weak var breedLBL: UILabel!
    @IBOutlet weak var vaccineLBL: UILabel!
    @IBOutlet weak var medsLBL: UILabel!
    @IBOutlet weak var specialInsLBL: UILabel!
    @IBOutlet weak var vetNameLBL: UILabel!
    @IBOutlet weak var vetPhoneLBL: UILabel!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
