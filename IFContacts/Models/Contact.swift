//
//  Contact.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 24/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import Gloss

class Contact: NSObject, Glossy {
    
    var contactID: String
    var contactFName: String
    var contactLName: String
    var contactBDate: String
    var contactInDate: String
    var contactPhoto: String
    var contactThumb: String
    var contactPhones: [ContactPhones]
    var contactAddress: String
    var contactIsSelected: Bool
    
    required init?(json: JSON) {
        
        guard let contactID: String = "user_id" <~~ json else { return nil }
        
        self.contactID = contactID
        self.contactFName = "first_name" <~~ json ?? ""
        self.contactLName = "last_name" <~~ json ?? ""
        self.contactBDate = "birth_date" <~~ json ?? ""
        self.contactInDate = "created_at" <~~ json ?? ""
        self.contactPhoto = "photo" <~~ json ?? ""
        self.contactThumb = "thumb" <~~ json ?? ""
        self.contactPhones = []
        self.contactAddress = ""
        self.contactIsSelected = false
        
    }
    
    func toJSON() -> JSON? {
        return nil
    }
}
