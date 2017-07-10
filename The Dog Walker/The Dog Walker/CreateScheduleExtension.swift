//
//  CreateScheduleExtension.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/4/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit


extension CreateScheduleViewController{
    
    //MARK: --Date picker funtionality
    func timePickerValueChanged(sender:UIDatePicker) {
        
        //init timeFormatter
        let timeFormatter = DateFormatter()
        
        //set time to none
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        //set textField to time picker selection
        timeTF.text = timeFormatter.string(from: sender.date)
        
    }
    
    //MARK: --Date picker funtionality
    func datePickerValueChanged(sender:UIDatePicker) {
        
        //init dateFormatter
        let dateFormatter = DateFormatter()
        
        //set time to none
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        //set date format
        dateFormatter.dateFormat = "MM/dd/YYYY"
        
        //set textField to date picker selection
        dateTF.text = dateFormatter.string(from: sender.date)
    }
    
    func pickerItem(title: String, textField: UITextField, selector: Selector){
        
        //done button for date picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: selector)
        let pickerInfo = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        
        
        doneButton.tintColor = UIColor(red:0.00, green:0.60, blue:0.80, alpha:1.0)
        pickerInfo.tintColor = UIColor.black
        
        // if you remove the space element, the "done" button will be left aligned
        toolBar.setItems([pickerInfo, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
    }
    
    //stop editing on date picker
    func donePickerPressed(){
        self.view.endEditing(true)
    }
}

extension CreateScheduleViewController: UIPickerViewDataSource{
    
    //set components to return 1 section, each pickerView only has one section
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //set number of rows in component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //switch pickerView tag
        switch pickerView.tag {
            
        case 0:
            //set count of roles array
            return durations.count
            
        default:
            break
        }
        //else return 0
        return 0
    }
    
}

extension CreateScheduleViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag  {
            
        case 0:
            
            switch durations[row] {
                
            case "15 Minutes":
                
                priceLbl.text = "10"
                
            case "30 Minutes":
                
                priceLbl.text = "20"
                
            case "60 Minutes":
                priceLbl.text = "30"
                
            default:
                break
            }
            
            return durations[row]
            
        default:
            break
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //set endEditing to true, to dismiss pickerView
        //        self.view.endEditing(true)
        
        switch pickerView.tag {
            
        case 0:
            
            durationTF.text = durations[row]
            
        default:
            break
        }
    }
}
