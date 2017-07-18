//
//  PetData.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/17/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation


class PetData{
    
    //stored properties
    var petName: String
    var birthday: String
    var breed: String
    var meds: String
    var vaccine: String
    var specialInstructions: String
    var emergencyContact: String?
    var emergencyPhone: String?
    var vetName: String
    var vetPhone: String
    var petImage: String?
    var uid: String?
    var petKey: String?
    
    //init properties 
    init(petName: String, birthday: String, breed: String, meds: String, vaccine: String, specialInstructions: String, vetName: String, vetPhone: String) {
        
        self.petName = petName
        self.birthday = birthday
        self.breed = breed
        self.meds = meds
        self.vaccine = vaccine
        self.specialInstructions = specialInstructions
        self.vetName = vetName
        self.vetPhone = vetPhone
    }
    
    
}
