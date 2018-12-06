//
//  ContactPhones.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 5/12/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import Gloss

class ContactPhones: NSObject, Glossy {
    
    var contactPhoneType: String
    var contactPhoneNumber: String
    
    required init?(json: JSON) {
        
        guard let phoneType: String = "type" <~~ json else { return nil }
        
        self.contactPhoneType = phoneType
        self.contactPhoneNumber = "number" <~~ json ?? "Not Register"
    }
    
    func toJSON() -> JSON? {
        return nil
    }

}
