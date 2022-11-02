//
//  ProfileViewController.swift
//  Sparkdev-Project
//
//  Created by Julian Arias on 10/27/22.
//
import Photos
import PhotosUI
import UIKit

class ProfileViewController: UIViewController, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var Add_Photo: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func Adding(_ sender: UIButton) {
        didTapAdd()
    }
    private func didTapAdd() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = PHPickerFilter.images
        let ViewController = PHPickerViewController(configuration: config)
        ViewController.delegate = self
        present(ViewController, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach {result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                print(image)
            }
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
