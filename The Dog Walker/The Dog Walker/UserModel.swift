//
//  UserModel.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/25/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    //stored properties
    var firstName: String?
    var lastName: String?
    var email: String?
    var uid: String?
    var phoneNumber: String?
    var companyCode: String?
    var roleID: String?
    var address: String?
    var aptNumber: String?
    var city: String?
    var state: String?
    var zipCode: String?
    var companyName: String?
    var profileImage: String?
    
    
    //init dictionary obj reference to firebase DB
    init(dictionary: [String: AnyObject]){
        
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.email = dictionary["email"] as? String
        self.uid = dictionary["uid"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.companyCode = dictionary["companyCode"] as? String
        self.roleID = dictionary["roleID"] as? String
        self.address = dictionary["address"] as? String
        self.city = dictionary["city"] as? String
        self.state = dictionary["state"] as? String
        self.zipCode = dictionary["zipCode"] as? String
        self.aptNumber = dictionary["aptNumber"] as? String
        self.companyName = dictionary["companyName"] as? String
        self.profileImage = dictionary["profileImage"] as? String
    }
    
}
