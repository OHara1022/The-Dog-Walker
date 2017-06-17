//
//  AddressInfo.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/17/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation

class AddressInfo {
    
    var address: String
    var aptNumber: String
    var city: String
    var state: String
    var zipCode: String
    
    init(address: String, aptNumber: String, city: String, state: String, zipCode: String) {
        
        self.address = address
        self.aptNumber = aptNumber
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
    
}
