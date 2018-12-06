//
//  ContactProfileInfoTableViewCell.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 1/12/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit

class ContactProfileInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cInfoIcon: UIImageView!
    @IBOutlet weak var cInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        cInfoIcon.image = nil
        cInfoLabel.text = ""
    }

    func setupCell(valueIn: String, identifierIn: String) {
        
        switch identifierIn {
        case "cellAddress":
            cInfoIcon.image = #imageLiteral(resourceName: "address_IM")
            cInfoLabel.text = valueIn
        case "Cellphone":
            cInfoIcon.image = #imageLiteral(resourceName: "mobilePhone_IM")
            cInfoLabel.text = valueIn
        case "Office":
            cInfoIcon.image = #imageLiteral(resourceName: "officePhone_IM")
            cInfoLabel.text = valueIn
        case "Home":
            cInfoIcon.image = #imageLiteral(resourceName: "homePhone_IM")
            cInfoLabel.text = valueIn
        default:
            break
        }
    }

}
