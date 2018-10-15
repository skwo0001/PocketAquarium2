//
//  AddFishViewController.swift
//  Pocket Aquarium
//
//  Created by Sze Yan Kwok on 11/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class AddFishViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var iconImageField: UIImageView!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    @IBOutlet weak var maxTempSlider: UISlider!
    @IBOutlet weak var minTempSlider: UISlider!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Add tap gesture in the icon image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFishViewController.imageTapped))
        iconImageField.addGestureRecognizer(tapGestureRecognizer)
        iconImageField.isUserInteractionEnabled = true
        
    }
    
    //After user tap the icon the action sheet will be shown
    @objc func imageTapped() {
        let alert = UIAlertController(title: "Upload Fish's Icon", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Import a Photo", style: .default, handler: {(importPhoto) in
            let controller = UIImagePickerController()
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            controller.allowsEditing = true
            controller.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            
            self.present(controller, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: {(takePhoto) in
            let controller = UIImagePickerController()
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                controller.sourceType = UIImagePickerControllerSourceType.camera
                controller.allowsEditing = true
                controller.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(controller, animated: true, completion: nil)
            }
            else {
                print("camera not available")
            }
        }))
        alert.addAction(UIAlertAction(title: "Choose Icon", style: .default, handler: {(chooseIcon) in
            let controller = UIImagePickerController()
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                controller.sourceType = UIImagePickerControllerSourceType.camera
                controller.allowsEditing = false
                controller.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(controller, animated: true, completion: nil)
            }
            else {
                print("camera not available")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showChooseIcon(){
        
    }
    //show the image in the image view
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info [UIImagePickerControllerOriginalImage] as? UIImage {
            iconImageField.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Observe the value changes of the min. temp. value
    @IBAction func minTempValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        minTempLabel.text = "\(currentValue)"
    }
    
    //Observe the value changes of the max. temp. value
    @IBAction func maxTempValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        maxTempLabel.text = "\(currentValue)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isValidInput(){
            if(segue.identifier == "addFishContinue") {
                let name = nameTextField.text
                let minTemp = Int(minTempLabel.text!)
                let maxTemp = Int(maxTempLabel.text!)
                let icon = iconImageField
                //default min pH
                let minpH = 6.0
                //default max pH
                let maxpH = 9.0
                //default fish id
                let id = "fish"
                //default fish photo
                let photo = ["0000"]
                //default rating value
                let rating = 3
                //default number of fish
                let number = 0
                var type: String?

                switch (typeSegment.selectedSegmentIndex){
                case 0:
                    type = "Saltwater"
                    break
                case 1:
                    type = "Freshwater"
                    break
                case 2:
                    type = "Plants"
                    break
                default:
                    type = "Normal"
                    break
                }
                let fish = Fish(id: id,icon:icon!,name: name!,type: type!,minTemp: minTemp!,maxTemp: maxTemp!,minpH: minpH,maxpH: maxpH,photo: photo,rating: rating,number: number)
                if let destinationVC = segue.destination as? AddFish2ViewController{
                    destinationVC.currentFish = fish
                }
            }
        }
    }
    
    func isValidInput() -> Bool{
        var errorMessage : String = "Not all fields were filled out!"
        
        if let fishName = self.nameTextField.text?.trimmingCharacters(in: .whitespaces){
            if fishName.isEmpty == true {
                displayErrorMessage(message: errorMessage, title: "Error")
                return false
            }
            if fishName.count >= 20 {
                errorMessage = "Fish Name should be less than 20"
                displayErrorMessage(message: errorMessage, title: "Name error")
                return false
            }
        }
        if let fishIcon = self.iconImageField{
            if fishIcon.image == UIImage(named: "addPhoto"){
            displayErrorMessage(message: "Please import or choose the icon of fish", title: "Icon Omitted")
            return false
            }
        }
        return true
    }
    
    //MARK: - error handler
    func displayErrorMessage(message:String,title:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
