//
//  AvatarPic.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 2/12/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit

class AvatarPic: UIImageView {

    required init(frameIn: CGRect, roundess: CGFloat = 2, borderW: CGFloat = 5, borderC: UIColor = UIColor.blue, bgColor: UIColor = UIColor.clear, urlIn: String) {
        
        self.roundness = roundess
        self.borderWidth = borderW
        self.borderColor = borderC
        self.background = bgColor
        
        super.init(frame: frameIn)
        self.downloadImageFrom(urlIn: urlIn)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var roundness: CGFloat = 2 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 5 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var background: UIColor = UIColor.clear {
        didSet{
            setNeedsLayout()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / roundness
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = background.cgColor
        clipsToBounds = true
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: bounds.width / roundness)
        let mask = CAShapeLayer()
        
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIImageView {
    
    func downloadImaFrom(urlIn: URL, contentModeIn: UIViewContentMode) {
        contentMode = contentModeIn
        URLSession.shared.dataTask(with: urlIn) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let iData = data, error == nil,
                let mainImage = UIImage(data: iData)
                else { return }
            DispatchQueue.main.async {
                self.image = mainImage
            }
            }.resume()
    }
    
    func downloadImageFrom(urlIn: String, contentMode mode: UIViewContentMode = .scaleToFill) {
        guard let imaURL: URL = URL(string: urlIn) else { return }
        downloadImaFrom(urlIn: imaURL, contentModeIn: mode)
    }
}
