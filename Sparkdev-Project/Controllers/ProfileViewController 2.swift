//
//  ProfileViewController.swift
//  Sparkdev-Project
//
//  Created by Jason Francis on 11/11/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker:UIImagePickerController!
    
    
    @IBOutlet weak var taptochange: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(imageTap)
            profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
            profileImageView.clipsToBounds = true
            taptochange.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
            
            imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self

        
    }
    
    @objc func openImagePicker(_ sender:Any) {
        //Opens Image Picker
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
   // self.uploadProfileimage(image) { url in
                           // let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            //changeRequest?.photoURL = url



    }



    extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.profileImageView.image = pickedImage
                
                
            }
            
            
            picker.dismiss(animated: true, completion: nil)
        }
    }


    
