//
//  PetModel.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/25/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class PetModel: NSObject {
    
    var petName: String?
    var birthday: String?
    var breed: String?
    var meds: String?
    var petKey: String?
    var emergencyContact: String?
    var emergencyPhone: String?
    var specialIns: String?
    var uid: String?
    var vaccines: String?
    var vetName: String?
    var vetPhone: String?
    
    init(dictionary: [String: AnyObject]) {
        
        self.petName = dictionary["petName"] as? String
        self.birthday = dictionary["birthday"] as? String
        self.breed = dictionary["breed"] as? String
        self.meds = dictionary["meds"] as? String
        self.petKey = dictionary["petKey"] as? String
        self.emergencyContact = dictionary["emergencyContact"] as? String
        self.emergencyPhone = dictionary["emergencyPhone"] as? String
        self.specialIns = dictionary["specialIns"] as? String
        self.uid = dictionary["uid"] as? String
        self.vaccines = dictionary["vaccines"] as? String
        self.vetName = dictionary["vetName"] as? String
        self.vetPhone = dictionary["vetPhone"] as? String
        
      }

}
