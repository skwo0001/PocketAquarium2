//
//  AddFish2ViewController.swift
//  Pocket Aquarium
//
//  Created by Sze Yan Kwok on 12/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class AddFish2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var minpHSlider: UISlider!
    @IBOutlet weak var minpHLabel: UILabel!
    @IBOutlet weak var maxpHSlider: UISlider!
    @IBOutlet weak var maxpHLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var fishImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var currentFish: Fish?
    
    let fishes = ["Clownfish","Crab","Flounder","Flying Fish","Gnathanodon","Goldfish","Hermit Crab","Jellyfish","Lobster","Octopus","Paracanthurus","Puffer Fish","Seahorse","Seasnake","Seaweed","Shell","Shrimp","Siganus Vulpinus","Starfish","Swordfish","Turtle","Urchin","Yellow Tang"]
    
    //create array to store image
    var imageArray:  [UIImage] = {
        var manyImages = [UIImage]()
        return manyImages
    }()
    
    //add photos for fish
    @IBAction func importImage(_ sender: Any) {
        if (imageArray.count < 4){
            let alert = UIAlertController(title: "Upload Fish's Photo", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Import a Photo", style: .default, handler: {(importPhoto) in
                let controller = UIImagePickerController()
                controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                controller.allowsEditing = false
                controller.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                
                self.present(controller, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: {(takePhoto) in
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
        } else {
            displayErrorMessage(message: "You only can upload at most 4 pictures", title: "Error")
        }
    }
    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let pickedImage = info [UIImagePickerControllerOriginalImage] as? UIImage {
                imageArray.append(pickedImage)
                collectionView.reloadData()
            }
            dismiss(animated: true, completion: nil)
    }

    //fishRef
    private var fishRef = Database.database().reference().child("fishes")
    private var storageRef = Storage.storage().reference()
    
    //create new fish
    var newFish : Fish?
    
    //Observe the value changes of the min. pH value
    @IBAction func minpHValueChanged(_ sender: UISlider) {
        let currentValue = Double(sender.value)
        let roundedValue = String(format:"%.1f", currentValue)
        minpHLabel.text = "\(roundedValue)"
    }
    
    //Observe the value changes of the max. pH value
    @IBAction func maxpHValueChanged(_ sender: UISlider) {
        let currentValue = Double(sender.value)
        let roundedValue = String(format:"%.1f", currentValue)
        maxpHLabel.text = "\(roundedValue)"
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if isValidInput(){
            let name = currentFish!.fishName
            let icon = currentFish!.fishIcon.image
            let type = currentFish!.fishType
            let iconName = currentFish!.fishIconName
            let minTemp = currentFish!.fishMinTemp
            let maxTemp = currentFish!.fishMaxTemp
            let minpH = Double(minpHLabel.text!)
            let maxpH = Double(maxpHLabel.text!)
            let number = Int(numberTextField.text!)
            //get the rating value of the rating star
            let rating = Int(ratingStar.rating)
            let newFishRef = self.fishRef.childByAutoId()
            
            let fishItem = [
                "fishId" : newFishRef.key!,
                "fishIconName" : iconName,
                "fishName" : name,
                "fishType" : type,
                "fishMinTemp" : minTemp,
                "fishMaxTemp" : maxTemp,
                "fishMinpH" : minpH!,
                "fishMaxpH" : maxpH!,
                "fishRating" : rating,
            "fishNumber" : number] as [String : Any]
        
            for image in imageArray{
                ImageManager.savePhoto(image: image, thisTankRef: newFishRef)
                //print(image)
                print("Save photo successfully")
            }
            if (iconName == "fish"){
                ImageManager.saveIcon(image: icon, thisTankRef: newFishRef)
            }
            
            newFishRef.setValue(fishItem)
            
            displayFinishMessage(message: "Fish created!", title: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func displayFinishMessage(message:String,title:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidInput() -> Bool{
        var errorMessage : String = "Not all fields were filled out!"
        
        if let fishNumber = self.numberTextField.text?.trimmingCharacters( in: .whitespaces){
            if fishNumber.isEmpty == true {
                displayErrorMessage(message: errorMessage, title: "Error")
                return false
            }
            if Int(fishNumber)! >= 20 {
                errorMessage = "Fish Number should be less than 20"
                displayErrorMessage(message: errorMessage, title: "Number error")
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
    
    // MARK: - Collection View Data source and delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionCell", for: indexPath) as! AddFishImageCollectionViewCell
        cell.imageView.image = imageArray[indexPath.row]
        
        return cell
    }

    // tab the image then show up action sheet to allow user to delete the photo
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = imageArray[indexPath.row]
        let alert = UIAlertController(title: "Edit Photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete the Photo", style: .default, handler: {(importPhoto) in
            if let index = self.imageArray.index(of: selected){
                self.imageArray.remove(at: index)
                collectionView.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
