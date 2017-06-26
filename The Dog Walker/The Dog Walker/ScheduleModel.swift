//
//  ScheduleModel.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/25/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class ScheduleModel: NSObject {

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
    
//    var price: String?
    var paidFlag: Bool?
    
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
        
    }
    
    
}
