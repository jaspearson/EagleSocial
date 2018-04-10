//
//  Person.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/27/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Person{
    let name : String
    let age : String
    let schoolYear : String
    let email : String
    let userId : String
    var photo : UIImage
    
    init(name : String, userId : String, age : String, major: String, schoolYear: String, email : String) {
        self.name = name
        self.age = age
        self.schoolYear = schoolYear
        self.email = email
        self.userId = userId
        self.photo = #imageLiteral(resourceName: "profile_icon")
        updateProfilePic()
    }
    
    public func updateProfilePic() {
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "image/\(self.userId)/userPic.jpg")
        
        var image : UIImage?
        storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error getting image from storage, \(error)")
            } else {
                // Data for "images/island.jpg" is returned
                print("image retreived successfully")
                image = UIImage(data: data!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
            if image != nil {
                self.setProfilePic(image: image!)
            }
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
    
    public func setProfilePic(image: UIImage) {
        self.photo = image
    }
}
