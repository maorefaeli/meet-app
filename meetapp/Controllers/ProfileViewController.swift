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

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var tbName: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    var imagePicker: UIImagePickerController?
    var storageRef = Storage.storage().reference(forURL: "gs://meetapp-f23d1.appspot.com")
    var imageURL: String = ""
    var name: String = ""
    
    func getUserProfile(uid: String) {
        DB.shared.users.get(
            uid,
            onSuccess: { (user: User) in
                self.name = user.name
                if self.name != "" {
                    self.tbName.text = self.name
                }
                
                self.imageURL = user.imageURL
                if self.imageURL != "" {
                    self.getImage(url: self.imageURL) { (image) in
                        self.userImage.image = image
                    }
                }
            },
            onError: { (error:Error) in
                print(error.localizedDescription)
            }
        )
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
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
        let user: User = User(uid: Auth.auth().currentUser!.uid, name: tbName.text!, imageURL: self.imageURL)
        spinner.startAnimating()
        DB.shared.users.update(user)
        spinner.stopAnimating()
        performSegue(withIdentifier: "profileToHome", sender: Any?.self)
    }
    @IBAction func showMyGroups(_ sender: Any) {
        performSegue(withIdentifier: "profileToMygroups", sender: Any?.self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
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
