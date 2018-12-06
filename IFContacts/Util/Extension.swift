//
//  Extension.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 25/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func keyboardHideWhenTapped() {
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func showLoading() -> Void {
        
        self.view.isUserInteractionEnabled = false
        
        let tempX = self.view.frame.size.width / 2.0
        let tempY = self.view.frame.size.height / 2.0
        let mainFrame = CGRect(x:tempX - 40, y:tempY - 40, width:100, height:100)
        
        let loadingView:UIView = UIView.init(frame: mainFrame)
        
        let mainAI = NVActivityIndicatorView(frame: CGRect(x:tempX - 40, y:tempY - 60, width:80, height:80), type: .ballClipRotatePulse, color: UIColor().buildHexColor(hexIn: "#FFFFF"), padding: 0)
        mainAI.tag = 201
        mainAI.startAnimating()
        
        self.view.addSubview(loadingView)
        self.view.addSubview(mainAI)
    }
    
    func removeLoading(){
        
        self.view.isUserInteractionEnabled = true
        let removeView: UIView? = (self.view.viewWithTag(200))
        let removeAIView: UIView? = (self.view.viewWithTag(201))
        removeAIView?.removeFromSuperview()
        removeView?.removeFromSuperview()
    }
}

extension UITextField {
    
    func loadDoneButton() {
        
        let doneToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolBar.barStyle = UIBarStyle.default
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(UITextField.doneButtonAct))
        
        var doneItems: [UIBarButtonItem] = []
        doneItems.append(doneButton)
        
        doneToolBar.items = doneItems
        doneToolBar.sizeToFit()
        
        self.inputAccessoryView = doneToolBar
    }
    
    @objc func doneButtonAct() {
        self.resignFirstResponder()
    }
}

extension Int {
    
    func randomNumber(range: ClosedRange<Int> = 1...6) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
}

extension Int {
    
    func numberForColums() -> Int {
        
        switch UIDevice.current.orientation {
        case .portrait:
            return 2
        case .landscapeLeft, .landscapeRight:
            return 4
        default:
            return 2
        }
    }
}

extension UIColor {
    
    func buildHexColor(hexIn: String) -> UIColor {
        
        var hString: String = hexIn.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hString.hasPrefix("#")) {
            hString.remove(at: hString.startIndex)
        }
        
        if ((hString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: hString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIDevice {
    
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    enum ScreenType: String {
        case iPhone4_4s = "iPhone4"
        case iPhone5 = "iPhone5"
        case iPhone6_8 = "iPhone6-8"
        case iPhone6_8Plus = "iPhone6-8+"
        case iPhoneX = "iPhoneX"
        case iPad = "iPad"
        case unknown
    }
    
    var iPhoneModel: ScreenType {
        
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4s
        case 1136:
            return .iPhone5
        case 1134:
            return .iPhone6_8
        case 1920, 2208:
            return .iPhone6_8Plus
        case 2436:
            return .iPhoneX
        case 2048:
            return .iPad
        default:
            return .unknown
        }
    }
}

extension String {
    
    func randomNotIma() -> String {
        if Int().randomNumber(range: 1...2) == 2 {
            return "notPicProfile2_IM"
        }else{
            return "notPicProfile1_IM"
        }
    }
}

