//
//  EditOwnerViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class EditOwnerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var companyCode: String?
    
    //MARK: --outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var editLastName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editAddress: UITextField!
    @IBOutlet weak var editAptNum: UITextField!
    @IBOutlet weak var editCity: UITextField!
    @IBOutlet weak var editState: UITextField!
    @IBOutlet weak var editZipCode: UITextField!
    @IBOutlet weak var editPhoneNum: UITextField!
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set DB reference
        ref = Database.database().reference().child("users").child(userID!)
        
        //set observer for users
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //set snaopshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)
                
                //dev
                print(user.firstName!)
                
                if let profileImgURL = user.profileImage{
                    
                    print(profileImgURL)
                    
                    self.profileImage.loadImageUsingCache(profileImgURL)
                }
                
                //populate label w/ data from FB
                self.editFirstName.text = user.firstName!
                self.editLastName.text = user.lastName!
                self.editEmail.text = user.email!
                self.editAddress.text = user.address!
                self.editAptNum.text = user.aptNumber!
                self.editCity.text = user.city!
                self.editState.text = user.state!
                self.editZipCode.text = user.zipCode!
                self.editPhoneNum.text = user.phoneNumber!
                
                self.companyCode = user.companyCode!
                
            }
            
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
     
    }
    
    
    //MARK: --actions
    @IBAction func saveOwnerChanges(_ sender: Any) {
        
        //dev
        print("save owner changes")
        
        //get TF text
        let firstName = editFirstName.text
        let lastName = editLastName.text
        let email = editEmail.text
        let address = editAddress.text
        let aptNum = editAptNum.text
        let city = editCity.text
        let state = editState.text
        let zipCode = editZipCode.text
        let phoneNum = editPhoneNum.text
        
        //populate user class w/ new values
        let updateProfile = Users(firstName: firstName!, lastName: lastName!, email: email!, address: address!, city: city!, state: state!, zipCode: zipCode!, phoneNumber: phoneNum!, uid: userID!, companyCode: companyCode!)
        
        //check if apt has value
        if editAptNum.text != nil{
            //set apt # text
            updateProfile.aptNumber = aptNum!
        }
        
        //update database w/ new values
        ref.updateChildValues(["firstName": updateProfile.firstName, "lastName": updateProfile.lastName, "email": updateProfile.email, "phoneNumber": updateProfile.phoneNumber, "uid": updateProfile.uid, "companyCode": updateProfile.companyCode, "address": updateProfile.address, "city": updateProfile.city, "state": updateProfile.state, "zipCode": updateProfile.zipCode, "aptNumber": updateProfile.aptNumber!])
        
        //segue to details, update view w/ new values
        self.performSegue(withIdentifier: "updateProfile", sender: self)
    }

    @IBAction func cancelEditOwner(_ sender: Any) {
        
        //dev
        print("cancel owner changes")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        
        //present camera options
        presentImgOptions()
    }

}

extension EditOwnerViewController{
    
    //MARK: -- image functionality
    func presentImgOptions(){
        
        //create action sheet
        let photoActionSheet = UIAlertController(title: "Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        //add actions
        photoActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //present action sheet
        present(photoActionSheet, animated: true, completion: nil)
    }
    
    
    //MARK -- imagePickerDelegate / navigationDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //get image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            //set image
            profileImage.image = image
            
            //get ref to store images
            let storageRef = Storage.storage().reference().child("profileImages").child("\(userID!).jpeg")
            
            //compress image
            if let uploadImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.6){
                
                //store data
                storageRef.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
                    //check if create user failed
                    if let error = error{
                        //present alert failed
                        FieldValidation.textFieldAlert("Image Storage Error", message: error.localizedDescription, presenter: self)
                        //dev
                        print(error.localizedDescription)
                        return
                    }
                    
                    //check string from image url
                    if let profileImgURL = metadata?.downloadURL()?.absoluteString{
                        //dev
                        print(profileImgURL)
                        //set ref to image url
                        self.ref.updateChildValues(["profileImage": profileImgURL])
                        
                    }
                })
            }
            
        }
        
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
        
    }
    
    //dismiss image picker if canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
    }

    
    
    
    
}
