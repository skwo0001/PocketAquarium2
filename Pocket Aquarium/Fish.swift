//
//  Fish.swift
//  Pocket Aquarium
//
//  Created by Sze Yan Kwok on 12/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class Fish: NSObject {
    var fishId : String
    var fishIcon : UIImageView
    var fishIconName : String
    var fishName : String
    var fishType : String
    var fishMinTemp : Int
    var fishMaxTemp : Int
    var fishMinpH : Double
    var fishMaxpH : Double
    var fishPhoto : [String]
    var fishRating : Int
    var fishNumber : Int
    
    init(id:String, icon:UIImageView, iconName: String, name:String, type:String, minTemp:Int, maxTemp:Int, minpH:Double, maxpH:Double, photo:[String], rating: Int, number:Int){
        self.fishId = id
        self.fishIcon = icon
        self.fishIconName = iconName
        self.fishName = name
        self.fishType = type
        self.fishMinTemp = minTemp
        self.fishMaxTemp = maxTemp
        self.fishMinpH = minpH
        self.fishMaxpH = maxpH
        self.fishPhoto = photo
        self.fishRating = rating
        self.fishNumber = number
    }
}
