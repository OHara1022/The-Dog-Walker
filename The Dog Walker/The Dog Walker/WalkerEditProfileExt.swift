//
//  WalkerEditProfileExt.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/20/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension WalkerEditProfileViewController{
    
    
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
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //present action sheet
        present(photoActionSheet, animated: true, completion: nil)
    }
    
    
    //MARK -- imagePickerDelegate / navigationDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        var selectedImage: UIImage?
        
        if let editableImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            selectedImage = editableImage
            
        }else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //set image
            selectedImage = image
            
        }
        
        if let selected = selectedImage{
            
            profileImage.image = selected
            
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
