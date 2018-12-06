//
//  ContactListCell.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 25/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import SwiftyAvatar

class ContactListCell: UICollectionViewCell {
    
    @IBOutlet weak var cBGView: UIView!
    @IBOutlet weak var cImage: UIImageView!
    @IBOutlet weak var cCallButton: UIButton!
    @IBOutlet weak var cProfileButton: UIButton!
    @IBOutlet weak var cNameLabel: UILabel!
    
    override func prepareForReuse() {
        cImage.image = UIImage(named: String().randomNotIma())
        cNameLabel.text = ""
    }
    
    func setupCell(contactIn: Contact, indexIn: IndexPath) {
        
        cCallButton.tag = indexIn.row
        cProfileButton.tag = indexIn.row
        cCallButton.isHidden = contactIn.contactIsSelected ? false : true
        cProfileButton.isHidden = contactIn.contactIsSelected ? false : true
        
        cImage.downloadImageFrom(urlIn: contactIn.contactThumb, contentMode: .scaleToFill)
        cNameLabel.text = contactIn.contactFName
    }
}
