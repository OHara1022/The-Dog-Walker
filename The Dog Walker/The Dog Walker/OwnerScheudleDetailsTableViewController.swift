//
//  OwnerScheudleDetailsTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import PassKit
import Firebase

//TODO: get ref to schedules update paidFlag on success of payment, change details label to paid
class OwnerScheudleDetailsTableViewController: UITableViewController{
    
    //MARK: --stored properties
    let supportedPayments = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let applePayMerchantID = "merchant.com.ohara.walks"
    var paidFlag: Bool?
    var selectedSchedule: ScheduleModel!
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    //MARK: -- outlets
    @IBOutlet weak var deatilsPetNameLBL: UILabel!
    @IBOutlet weak var detailsDateLBL: UILabel!
    @IBOutlet weak var detailsTimeLBL: UILabel!
    @IBOutlet weak var durationLBL: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var specialInsLBL: UILabel!
    @IBOutlet weak var medsLBL: UILabel!
    @IBOutlet weak var applePayBTN: UIButton!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide applePay button if user does not have supported device
        applePayBTN.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPayments)
        
        //get ref to database
        ref = Database.database().reference().child("schedules").child(userID!).child(selectedSchedule.scheduleKey!)
        
        //USE THIS METHOD
        //       print(selectedSchedule.paidFlag!)
        
        //set label w/ passed values
        deatilsPetNameLBL.text = selectedSchedule.petName
        detailsDateLBL.text = selectedSchedule.date
        detailsTimeLBL.text = selectedSchedule.time
        durationLBL.text = selectedSchedule.duration
        specialInsLBL.text = selectedSchedule.specialIns
        medsLBL.text = selectedSchedule.meds
    }
    
    //MARK: -- actions
    @IBAction func payBTN(_ sender: UIButton) {
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPayments){
            
            let request = PKPaymentRequest()
            
            request.merchantIdentifier = applePayMerchantID
            request.supportedNetworks = supportedPayments
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Walker", amount: NSDecimalNumber(string: "15")) ,PKPaymentSummaryItem(label: "Walker", amount: NSDecimalNumber(string: "15")) ]
            
            request.countryCode = "US"
            
            request.currencyCode = "USD"
            
            request.requiredBillingAddressFields = PKAddressField.all
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            applePayController.delegate = self
            
            self.present(applePayController, animated: true, completion: nil)
        }
    }
}

//MARK: --extension payment delegate
extension OwnerScheudleDetailsTableViewController: PKPaymentAuthorizationViewControllerDelegate{
    //delegate method to auth payment on completion
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        //complete on sucess of payment
        completion(PKPaymentAuthorizationStatus.success)
        
        //dev
        print("PAID SUCCESSFUL")
        
        ref.updateChildValues(["paidFlag": true])
        
}
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        //dimiss vc if canceled or transation complete
        controller.dismiss(animated: true, completion: nil)
        
        //return to details vc
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
