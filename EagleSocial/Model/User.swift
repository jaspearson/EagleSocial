//
//  User.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


//let thisUser = User()

//let thisUser = User(username: (Auth.auth().currentUser?.displayName!)!, userID: (Auth.auth().currentUser?.uid)!)

class User
{
    var userID: String
    var name: String
    var age: String
    var major: String
    var schoolYear: String
    var photo: String
    var profilePic: UIImage

    //let ref = Database.database().reference()
    let storage = Storage.storage()
    let snapshot = DataSnapshot()

    init(username: String, userID: String)
{
    self.userID = userID
    self.name = username
    self.age = ""
    self.major = ""
    self.schoolYear = ""
    self.photo = ""
    self.profilePic = #imageLiteral(resourceName: "profile_icon")
    
    self.updateProfilePic()

}
    


    
/*init(username: String, userAge: String, userMajor: String, userSchoolYear: String, userPhoto: String)
{
    
    let username = username
    let userAge = userAge
    let userMajor = userMajor
    let userSchoolYear = userSchoolYear
    let userPhoto = userPhoto
    
    let name: String
    let uid: String
    
    init(username: String, uid: String) {
        
        let username = username
        
        self.name = username
        self.uid = uid
    }*/
    
    public func getName() -> String {
        return self.name
    }
    
    public func setName(userName: String)
    {
        self.name = userName
    }
    
    public func setProfilePic(image: UIImage) {
        self.profilePic = image
    }
    
    public func setUserAttributes()
    {
        let ref = Database.database().reference().child("Users").child(self.userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.name = value?["name"] as? String ?? ""
            self.age = value?["age"] as! String
            self.major = value?["major"] as! String
            self.schoolYear = value?["school year"] as! String
        }
        )}
    
    public func updateUserAttributes(username: String, userAge: String, userMajor: String, userSchoolYear: String)
    {
        name = username
        age = userAge
        major = userMajor
        schoolYear = userSchoolYear
    }
    
    public func updateProfilePic() {
        let uid : String = (Auth.auth().currentUser?.uid)!
        let storageRef = storage.reference(withPath: "image/\(uid)/userPic.jpg")
        
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
    
    public func hasProfilePic() -> Bool {
        if self.profilePic != profilePic {
            return true
        } else {
            return false
        }
    }
 

    
    static let thisUser : User = {
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("Users").child(userId!)
        var instance : User?
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? ""
            instance = User(username: username, userID: userId!)
        })


//        let instance = User(username: userId!)
//
        return instance!
    }()

}

//changes need to be made to the user struct to store user attributes other than user name. These other attributes are needed to share user info between view controllers. I attempted to make changes, but this caused an error with the user status table view. I reverted the changes so that the team could discuss the best approach.
