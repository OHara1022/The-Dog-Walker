//
//  ScheduleModel.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/25/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class ScheduleModel: NSObject {
    
    //stored properties
    var date: String?
    var time: String?
    var duration: String?
    var petName: String?
    var specialIns: String?
    var meds: String?
    var scheduleKey: String?
    var clientAddress: String?
    var clientName: String?
    var clientPhone: String?
    var uid: String?
    var companyCode: String?
    var paidFlag: Bool?
    var checkIn: Bool?
    var checkOut: Bool?
    var notes: String?
    var petImageUrl: String?
    var vetName: String?
    var vetPhone: String?
    var emergencyContact: String?
    var emergencyPhone: String?
    var price: String?
    var breed: String?
    
    //init dictionary obj reference to firebase DB
    init(dictionary: [String: AnyObject]){
        
        self.date = dictionary["date"] as? String
        self.time = dictionary["time"] as? String
        self.duration = dictionary["duration"] as? String
        self.petName = dictionary["petName"] as? String
        self.specialIns = dictionary["specialIns"] as? String
        self.meds = dictionary["meds"] as? String
        self.scheduleKey = dictionary["scheduleKey"] as? String
        self.clientName = dictionary["clientName"] as? String
        self.clientAddress = dictionary["clientAddress"] as? String
        self.clientPhone = dictionary["clientPhone"] as? String
        self.uid = dictionary["uid"] as? String
        self.paidFlag = dictionary["paidFlag"] as? Bool
        self.companyCode = dictionary["companyCode"] as? String
        self.checkIn = dictionary["checkIn"] as? Bool
        self.checkOut = dictionary["checkOut"] as? Bool
        self.notes = dictionary["notes"] as? String
        self.petImageUrl = dictionary["petImage"] as? String
        self.vetName = dictionary["vetName"] as? String
        self.vetPhone = dictionary["vetPhone"] as? String
        self.emergencyContact = dictionary["emergencyContact"] as? String
        self.emergencyPhone = dictionary["emergencyPhone"] as? String
        self.price = dictionary["price"] as? String
        self.breed = dictionary["breed"] as? String
        
    }
    
    
}
