//
//  ContactProfileTableViewCell.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 1/12/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit

class ContactProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cProfileImage: UIImageView!
    @IBOutlet weak var cFullNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        cProfileImage.image = UIImage(named: String().randomNotIma())
        cFullNameLabel.text = ""
    }
    
    func setupCell(contactIn: Contact) {
        
        cProfileImage.downloadImageFrom(urlIn: contactIn.contactPhoto, contentMode: .scaleToFill)
        cFullNameLabel.text = contactIn.contactFName + " " + contactIn.contactLName
    }

}
