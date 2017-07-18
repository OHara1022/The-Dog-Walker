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

class OwnerScheudleDetailsTableViewController: UITableViewController{
    
    //MARK: --stored properties
    let supportedPayments = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let applePayMerchantID = "merchant.com.ohara.walks"
    var selectedSchedule: ScheduleModel!
    var ref: DatabaseReference!
    var petRef: DatabaseReference!
    var price: NSDecimalNumber!
    
    //MARK: -- outlets
    @IBOutlet weak var petImage: UIImageView!
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
        ref = Database.database().reference().child(schedules).child(userID!).child(selectedSchedule.scheduleKey!)
        petRef = Database.database().reference().child(pets).child(userID!)
    }
    
    //MARK: --viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        petRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //populate petModel w/ dictionary
                let pet = PetModel(dictionary: dictionary)
                
                if let petImgURL = pet.petImage{
                    //dev
                    print(petImgURL)
                    //set image to imageView
                    self.petImage.loadImageUsingCache(petImgURL)
                }
                
            }
        }, withCancel: nil)
        
        //observe schedule values
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot values
                let schedule = ScheduleModel(dictionary: dictionary)
                
                //                print(schedule.date!)
                
                //set label w/ passed values
                self.deatilsPetNameLBL.text = schedule.petName
                self.detailsDateLBL.text = schedule.date
                self.detailsTimeLBL.text = schedule.time
                self.durationLBL.text = schedule.duration
                self.specialInsLBL.text = schedule.specialIns
                self.medsLBL.text = schedule.meds
                self.priceLBL.text = "$" + schedule.price!
                self.price = NSDecimalNumber(string: schedule.price!)
                
                if self.specialInsLBL.text == ""{
                    self.specialInsLBL.text = "None"
                }
                
                if self.selectedSchedule.checkOut == false{
                    self.applePayBTN.isHidden = true
                }
            }
            
        }, withCancel: nil)
    }
    
    //MARK: --navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //check identifier
        if segue.identifier == "edit"{
            
            //get destination of segue
            let editDetails = segue.destination as! OwnerEditScheduleViewController
            
            //send key to edit
            editDetails.scheduleKey = selectedSchedule.scheduleKey
       
        }
    }
    
    //MARK: --actions
    @IBAction func updateView(segue: UIStoryboardSegue){
        
        //observe schedule values
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot values
                let schedule = ScheduleModel(dictionary: dictionary)
                
                //                print(schedule.date!)
                
                //set label w/ snapshot values
                self.deatilsPetNameLBL.text = schedule.petName
                self.detailsDateLBL.text = schedule.date
                self.detailsTimeLBL.text = schedule.time
                self.durationLBL.text = schedule.duration
                self.specialInsLBL.text = schedule.specialIns
                self.medsLBL.text = schedule.meds
                self.priceLBL.text = "$" + schedule.price!
                
                if self.specialInsLBL.text == ""{
                    self.specialInsLBL.text = "None"
                }
            }
            
        }, withCancel: nil)
    }
    
    
    //MARK: -- actions
    @IBAction func payBTN(_ sender: UIButton) {
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPayments){
            
            let request = PKPaymentRequest()
            
            request.merchantIdentifier = applePayMerchantID
            request.supportedNetworks = supportedPayments
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Walker", amount: price) ,PKPaymentSummaryItem(label: "Walker", amount: price)]
            
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
        
        //update paid flag to true
        ref.updateChildValues(["paidFlag": true])
        
    }
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        //dimiss vc if canceled or transation complete
        controller.dismiss(animated: true, completion: nil)
        
        //return to details vc
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
