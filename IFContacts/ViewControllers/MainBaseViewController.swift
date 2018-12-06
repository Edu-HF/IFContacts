//
//  MainBaseViewController.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 29/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit

class MainBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor().buildHexColor(hexIn: "#3C3B49")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.refreshUI()
        })
    }
    
    func refreshUI(){}

    func buildMSGAlert(titleIn: Any, msgIn: Any, buttonsIn: [[String : String]]?) {
        
        let eAlert: UIAlertController = UIAlertController.init(title: titleIn as? String, message: msgIn as? String, preferredStyle: .alert)
        
        if buttonsIn != nil {
            for buttonAct in buttonsIn! {
                let tempActButton: UIAlertAction = UIAlertAction.init(title: buttonAct["Title"], style: .default, handler: { _ in
                    eAlert.dismiss(animated: true, completion: nil)
                    let actionIn = buttonAct["Action"]
                    if actionIn != "" {
                        self.perform(Selector((actionIn!)))
                    }
                })
                eAlert.addAction(tempActButton)
            }
        }
        
        self.present(eAlert, animated: true, completion: nil)
    }
    
    func canMakePhoneCall(phoneNumIn: String) {
        
        let phoneNum = phoneNumIn.replacingOccurrences(of: " ", with: "")
        guard let phoneURL = URL(string: "telprompt://" + phoneNum) else {
            
            self.buildMSGAlert(titleIn: "Call not available", msgIn: "Can not make calls at this time. Please try later", buttonsIn: [["Title" : "Aceptar", "Action" : ""]])
            return
        }
        
        if UIApplication.shared.canOpenURL(phoneURL) && phoneURL.absoluteString != "telprompt://" {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }else{
            self.buildMSGAlert(titleIn: "Call not available", msgIn: "Can not make calls at this time. Please try later", buttonsIn: [["Title" : "Aceptar", "Action" : ""]])
        }
    }
}
