//
//  ProfileViewController.swift
//  meetapp
//
//  Created by admin on 11/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet var tbName: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    var ref:DatabaseReference?
    var imagePicker: UIImagePickerController?
    var storageRef = Storage.storage().reference(forURL: "gs://meetapp-f23d1.appspot.com")
    var imageURL: String = ""
    var name: String = ""
    
    func getUserProfile(uid: String) {
        //  Setup firebase database
        ref = Database.database().reference()
        ref?.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.imageURL = value?["userPhoto"] as? String ?? ""
            self.name = value?["name"] as? String ?? ""
            if self.name != "" {
                self.tbName.text = self.name
            }
            if self.imageURL != "" {
                self.getImage(url: self.imageURL) { (image) in
                    self.userImage.image = image
                }
            }
        })
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void) {
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    @IBAction func removeProfileImage(_ sender: Any) {
        self.imageURL = ""
        self.userImage.image = nil
    }
    @IBAction func updateProfile(_ sender: Any) {
        var user: User
        user = User.init(uid: Auth.auth().currentUser!.uid, name: tbName.text!)
        ref = Database.database().reference()
        ref?.child("users").child(user.uid).updateChildValues(["name": user.name, "userPhoto": self.imageURL])
        performSegue(withIdentifier: "profileToHome", sender: Any?.self)
    }
    @IBAction func showMyGroups(_ sender: Any) {
        performSegue(withIdentifier: "profileToMygroups", sender: Any?.self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfile(uid: Auth.auth().currentUser!.uid)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = .photoLibrary
        imagePicker?.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePicker!, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.userImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        uploadProfileImage(image: selectedImage!, name: Auth.auth().currentUser!.uid) { (downloadURL) in
            self.imageURL = downloadURL!
        }
    }
    
    func uploadProfileImage(image: UIImage, name:(String), callback:@escaping(String?)->Void) {
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child(name)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) {(metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                callback(downloadURL.absoluteString)
            }
        }
    }
}
