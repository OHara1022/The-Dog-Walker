//
//  ScheduleData.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/17/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation

class ScheduleData{
    
    var date: String
    var time: String
    var duration: String
    var petName: String
    var instructions: String
    var meds: String
    var scheduleKey: String?
    var price: String?
    var paidFlag: Bool?
    
    init(date: String, time: String, duration: String, petName: String, instructions: String, meds: String) {
        
        self.date = date
        self.time = time
        self.duration = duration
        self.petName = petName
        self.instructions = instructions
        self.meds = meds
    }
    
    
}
