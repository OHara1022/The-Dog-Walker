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
    var petNameHolder: String?
    var dateHolder: String?
    var timeHolder: String?
    var durationHolder: String?
    var priceHolder: String?  = "" //use on later release
    var specialInsHolder: String?
    var medHolder: String?
    var scheduleKeyHolder: String?
    var paidFlag: Bool?
    
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
        
        //dev
        print(petNameHolder!)
        print(paidFlag!)
        
        //set label w/ passed values
        deatilsPetNameLBL.text = petNameHolder
        detailsDateLBL.text = dateHolder
        detailsTimeLBL.text = timeHolder
        durationLBL.text = durationHolder
        specialInsLBL.text = specialInsHolder
        medsLBL.text = medHolder
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
        
        
        FieldValidation.textFieldAlert("PAID", message: "Paid Successful", presenter: self)
    }
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        //dimiss vc if canceled or transation complete
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
// MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
