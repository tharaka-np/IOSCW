//
//  ImageUploadViewController.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/18/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class ImageUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var updFirstName: UITextField!
    @IBOutlet weak var updLastName: UITextField!
    @IBOutlet weak var updIndexNo: UITextField!
    
    private let storage = Storage.storage().reference()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getUserData()
        
        btnUpdate.layer.cornerRadius = 10
        btnUpdate.clipsToBounds = true
        ImageView.contentMode = .scaleAspectFit
        
//        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
//              let url = URL(string: urlString) else{
//            return
//        }
        
//        label.text = urlString
        
//        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            DispatchQueue.main.sync {
//                let image = UIImage(data: data)
//                self.ImageView.image = image
//            }
//        })
//
//        task.resume()
    }
    
    //Get user data
    
    private var userDetails: UserDetails? {
        didSet {
            updFirstName.text = userDetails?.firstName
            updLastName.text = userDetails?.lastName
            updIndexNo.text = userDetails?.indexNo
            ImageView.kf.setImage(with: URL("https://picsum.photos/200"))
        }
    }
    
    func getUserData() {
        Service.shared.getUserById { (userDetails) in
            print(userDetails);
            self.userDetails = userDetails
        }
    }
    
    @IBAction func didTapButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        
        guard let imageData = image.pngData() else{
            return
        }
        
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        
        storage.child(uid).child("file.png").putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            
            self.storage.child("images/file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                
                let urlString = url.absoluteString
                print("Image URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
