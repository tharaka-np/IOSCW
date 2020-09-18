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
//    @IBOutlet var label: UILabel!
    
    
    
    private let storage = Storage.storage().reference()

    override func viewDidLoad() {
        
        ImageView.layer.cornerRadius = 20
        
        super.viewDidLoad()
//        label.numberOfLines = 0;
//        label.textAlignment = .center;
        ImageView.contentMode = .scaleAspectFit
        
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else{
            return
        }
        
//        label.text = urlString
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.sync {
                let image = UIImage(data: data)
                self.ImageView.image = image
            }
        })
        
        task.resume()
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
        
        //let ref = storage.child("images/file.png")
//        let user = Auth.auth().currentUser
//        guard let uid = user?.uid else { return }
        
        storage.child("123").child("file.png").putData(imageData, metadata: nil, completion: {_, error in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
