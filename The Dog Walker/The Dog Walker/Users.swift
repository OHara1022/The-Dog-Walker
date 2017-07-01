//
//  Users.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/17/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation

class Users{
    
    //stored properties
    var firstName: String
    var lastName: String
    var email: String
    var uid: String
    var phoneNumber: String
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var companyCode: String
    var aptNumber: String?
    var profileImage: String?
    var roleID: String?
    var paidFlag: Bool?
    
    //for testing purpose remove before release!!!
    var password: String? //never store password in Firebase (for test purposes)
    
    //init stored properties
    init(firstName: String, lastName: String, email: String, address: String, city: String, state: String, zipCode: String,  phoneNumber: String, uid: String, companyCode: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.phoneNumber = phoneNumber
        self.uid = uid
        self.companyCode = companyCode
        
    }
    
}
