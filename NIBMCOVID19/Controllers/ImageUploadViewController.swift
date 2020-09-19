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
        
        ImageView.roundImageView()
    }
    
    //Get user data
    
    private var userDetails: UserDetails? {
        didSet {
            updFirstName.text = userDetails?.firstName
            updLastName.text = userDetails?.lastName
            updIndexNo.text = userDetails?.indexNo
            

            
            if let profileImgUrl = userDetails?.imageUrl {
                if let url = URL(string:profileImgUrl){
                    downloadImage(from: url)
                }
            }
        }
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.ImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
            
            self.storage.child(uid).child("file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                
                
                if let urlString : String = url.absoluteString{
                    print("Image URL: \(urlString)")
                    self.downloadImage(from: URL(string:urlString)!)
                    UserDefaults.standard.set(urlString, forKey: "url")
                    
                    Service.shared.updateUserProfileImage(urlString)
                }
            })
        })
    }
    
    
    @IBAction func userDetailsHandler(_ sender: Any) {
            
        guard let fname = updFirstName.text else {return}
        guard let lname = updLastName.text else {return}
        guard let index = updIndexNo.text else {return}
        
        let values = [
        "firstName":fname,
        "lastName":lname,
        "indexNo":index
        ] as [String : Any]
        
        Service.shared.updateUserDetails(values)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
