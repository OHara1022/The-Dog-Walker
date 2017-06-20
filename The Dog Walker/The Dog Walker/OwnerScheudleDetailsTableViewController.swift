//
//  OwnerScheudleDetailsTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import PassKit


class OwnerScheudleDetailsTableViewController: UITableViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    @IBOutlet weak var applePayBTN: UIButton!
    
    //MARK: --stored properties
    let supportedPayments = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let applePayMerchantID = "merchant.com.ohara.walks"
    
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
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide applePay button if user does not have supported device
        applePayBTN.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPayments)
        
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
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
        
        print("PAID SUCCESSFUL")
    }

    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
