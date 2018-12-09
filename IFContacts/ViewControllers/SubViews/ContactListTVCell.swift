//
//  ContactListTVCell.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 8/12/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit

class ContactListTVCell: UITableViewCell {
    
    @IBOutlet weak var cImage: UIImageView!
    @IBOutlet weak var cCallButton: UIButton!
    @IBOutlet weak var cProfileButton: UIButton!
    @IBOutlet weak var cNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        cImage.image = UIImage(named: String().randomNotIma())
        cNameLabel.text = ""
    }
    
    func setupCell(contactIn: Contact, indexIn: IndexPath) {
        
        cCallButton.tag = indexIn.row
        cProfileButton.tag = indexIn.row
        
        cImage.downloadImageFrom(urlIn: contactIn.contactThumb, contentMode: .scaleToFill)
        cNameLabel.text = contactIn.contactFName
    }
}
