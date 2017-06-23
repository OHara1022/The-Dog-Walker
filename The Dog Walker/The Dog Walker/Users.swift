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
    var address: AddressInfo
    var companyCode: String
//    var role: String? //store if walker or owner is selected
    var profileImage: String?
    var roleID: String?//extra incase need another relation for walker & client 
    var password: String? //never store password in Firebase (for test purposes)
    
    
    init(firstName: String, lastName: String, email: String, address: AddressInfo, phoneNumber: String, uid: String, companyCode: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.address = address
        self.phoneNumber = phoneNumber
        self.uid = uid
        self.companyCode = companyCode
        
    }
    
}
