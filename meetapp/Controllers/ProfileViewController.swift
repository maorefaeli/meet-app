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
    var groupsController: GroupsTableViewController? = nil
    var imagePicker: UIImagePickerController?
    var storageRef = Storage.storage().reference(forURL: "gs://meetapp-f23d1.appspot.com")
    var imageURL: String = ""
    var name: String = ""
    
    func getDefaultImage() -> UIImage? {
        return UIImage(named: "Logo")
    }
    
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
                        self.spinner.stopAnimating()
                        self.userImage.image = image
                    }
                } else {
                    self.spinner.stopAnimating()
                    self.userImage.image = self.getDefaultImage()
                }
            },
            onError: { (error:Error) in
                self.spinner.stopAnimating()
                print(error.localizedDescription)
            }
        )
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
        self.userImage.image = self.getDefaultImage()
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        let user: User = User(uid: Auth.auth().currentUser!.uid, name: tbName.text!, imageURL: self.imageURL)
        spinner.startAnimating()
        DB.shared.users.update(user, onComplete: { (error:Error?) in
            self.spinner.stopAnimating()
            if error == nil {
                self.performSegue(withIdentifier: "profileToHome", sender: Any?.self)
            } else {
                Helper.showToast(controller: self, message: "Error updating user details", seconds: 3)
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? GroupsTableViewController {
            let uid = Configuration.getUserId()!
            DB.shared.groups.observeAll(onSuccess: { (groups:[Group]) in
                destinationVC.groups = groups.filter{ $0.members.contains(uid) }
                destinationVC.isMyGroups = true
            })
        }
    }

    @IBAction func showMyGroups(_ sender: Any) {
        self.performSegue(withIdentifier: "profileToMyGroups", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        getUserProfile(uid: Auth.auth().currentUser!.uid)
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
