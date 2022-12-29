//
//  AddPhotoController.swift
//  MyPhotosList
//
//  Created by Halil YAŞ on 29.12.2022.
//

import UIKit
import CoreData

class AddPhotoController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedItem : Entity? = nil
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var gallery: UIButton!
    @IBOutlet weak var save: UIButton!
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonConfigure()
        selecedItemConfig()
    }
    
    //MARK: - Actions
    
    @IBAction func cameraButton(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        self.present(picker, animated: true,completion: nil)
    }
    
    @IBAction func galleryButton(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true,completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        if selectedItem == nil {
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
            let newData = Entity(entity: entityDescription!, insertInto: pc)
            newData.titleText = titleText.text
            newData.descriptionText = descriptionText.text
            newData.image = photoImage.image!.jpegData(compressionQuality: 0.8) as NSData?
        } else {
            
            selectedItem?.titleText = titleText.text
            selectedItem?.descriptionText = descriptionText.text
            selectedItem?.image = photoImage.image?.jpegData(compressionQuality: 0.8) as NSData?
        }

        do {
            
            if pc.hasChanges {
                try pc.save()
            }
            
        } catch {
            print(error)
            return
        }
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    //MARK: - Helpers
    
    func buttonConfigure() {
        camera.layer.cornerRadius = 10
        gallery.layer.cornerRadius = 10
        save.layer.cornerRadius = 10
    }
    
    func selecedItemConfig() {
        if selectedItem == nil {
            
            // yeni item eklenecek
            self.navigationItem.title = "Add a New Photo"
            
        } else {
            
            // var olan item düzenlenecek
            self.navigationItem.title = selectedItem?.titleText
            titleText.text = selectedItem?.titleText
            descriptionText.text = selectedItem?.descriptionText
            photoImage.image = UIImage(data: (selectedItem?.image as! Data))
            save.setTitle("Update", for: .normal)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension AddPhotoController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImage.image = selectedImage
        }
        self.dismiss(animated: true,completion: nil)
    }
}
