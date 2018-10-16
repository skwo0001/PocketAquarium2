//
//  ImageManager.swift
//  Pocket Aquarium
//
//  Created by Sze Yan Kwok on 14/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class ImageManager {
    static var storageRef = Storage.storage().reference().child("images")
    // static var tanksRef = Database.database().reference().child("tanks")
    
    
    static var imageDownloadURL : String?
    
    static func savePhoto(image : UIImage?, thisTankRef : DatabaseReference){
        guard let thisImage = image else {
            print("image nil")
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else{
            print("userid nil")
            return
        }
        
        var imageData = Data()
        imageData = UIImageJPEGRepresentation(image!, 0.8)!
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        //1. create an unique id
        let imageRef = thisTankRef.child("pictureURL").childByAutoId()
        let fileName = imageRef.key
        
        //2. create a new storage reference
        let newImageStorageRef = self.storageRef.child("\(userID)/\(fileName!)")
        //3. save the image to storage
        newImageStorageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            newImageStorageRef.downloadURL { (url,error) -> () in
                guard let thisURL = url else {
                    return
                        print("url nil")
                }
                self.imageDownloadURL = thisURL.absoluteString
                var imageItem = [
                    "\(fileName)" : imageDownloadURL
                ]
                thisTankRef.child("pictureURL").updateChildValues(imageItem)
                print("save photo successfully")
            }
        }
        self.saveLocalData(fileName: "\(fileName)", imageData: imageData)
    }
    
    static func saveIcon(image : UIImage?, thisTankRef : DatabaseReference){
        guard let thisImage = image else {
            print("image nil")
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else{
            print("userid nil")
            return
        }
        
        var imageData = Data()
        imageData = UIImageJPEGRepresentation(image!, 0.8)!
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        //1. create an unique id
        let imageRef = thisTankRef.child("iconURL").childByAutoId()
        let fileName = imageRef.key
        
        //2. create a new storage reference
        let newImageStorageRef = self.storageRef.child("\(userID)/\(fileName!)")
        //3. save the image to storage
        newImageStorageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            newImageStorageRef.downloadURL { (url,error) -> () in
                guard let thisURL = url else {
                    return
                        print("url nil")
                }
                self.imageDownloadURL = thisURL.absoluteString
                var imageItem = [
                    "\(fileName)" : imageDownloadURL
                ]
                thisTankRef.child("iconURL").updateChildValues(imageItem)
                print("save photo successfully")
            }
        }
        self.saveLocalData(fileName: "\(fileName)", imageData: imageData)
    }
    
    static func retrieveImageData(fileName: String) -> UIImage?{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image:UIImage?
        
        if let pathComponent = url.appendingPathComponent(fileName){
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            let fileData = fileManager.contents(atPath: filePath)
            if fileData != nil {
                image = UIImage(data: fileData!)
            }
        }
        return image
    }
    
    static func localFileExists(fileName : String) -> Bool {
        var localFileExists = false
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName){
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            localFileExists = true
        }
        return localFileExists
    }
    
    static func saveLocalData(fileName:String, imageData  : Data){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        }
    }
    
    //MARK: find ImageStorages
    static func getImageStorage (thisTankRef : DatabaseReference) -> [String]? {
        var imageStorageRefs = [String]()
        thisTankRef.queryOrdered(byChild: "pictureURL").observeSingleEvent(of: .value){ (snapshot) in
            print(snapshot)
            
            let imageFileName = snapshot.value as! String
            imageStorageRefs.append(imageFileName)
            print(imageFileName)
            
            /*
             for child in snapshot.children {
             var imageValueRefs = child as! Dictionary<String,String>
             for (fileName,url) in imageValueRefs {
             let imageStorageRef = fileName
             imageStorageRefs.append(imageStorageRef)
             }
             }*/
        }
        return imageStorageRefs
        print("get image storage reference name success")
    }
    
    //MARK: delete Image Storages
    static func deleteImageStorage(imageStorages : [String]?){
        if imageStorages != nil {
            for imageFileName in imageStorages! {
                print(imageFileName)
                if let userID = Auth.auth().currentUser?.uid {
                    
                    let deleteRef = self.storageRef.child(userID).child(imageFileName)
                    deleteRef.delete(completion: {error in
                        if error != nil{
                            print(error?.localizedDescription)
                        }
                        else{
                            print("delete this image storage successfully")
                        }
                    })
                }
            }
        }
    }
}


