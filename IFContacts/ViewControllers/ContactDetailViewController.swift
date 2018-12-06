//
//  ContactDetailViewController.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 1/12/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit

class ContactDetailViewController: MainBaseViewController {
    
    @IBOutlet weak var mainProfileTV: UITableView!
    
    var contactID: Int!
    var mainContactsPresenter: ContactsPresenter!
    var cellIdentifierOptions: [String] = []
    var cellValuesOptions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Contact Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupUI() {
        
        mainProfileTV.register(UINib(nibName: "ContactProfileCell", bundle: nil), forCellReuseIdentifier: "cellProfile")
        mainProfileTV.register(UINib(nibName: "ContactProfileInfoCell", bundle: nil), forCellReuseIdentifier: "cellProfileInfo")
        mainProfileTV.separatorStyle = .none
        
        showLoading()
        mainContactsPresenter = ContactsPresenter(mainViewIn: self)
        mainContactsPresenter.getContactDetail(contactIDIn: contactID)
    }
    
    override func refreshUI() {
        removeLoading()
        
        cellIdentifierOptions.append("cellProfile")
        cellValuesOptions.append(mainContactsPresenter.mainContactSelected.contactFName + " " + mainContactsPresenter.mainContactSelected.contactLName)
        
        if mainContactsPresenter.mainContactSelected.contactAddress != "" {
            cellIdentifierOptions.append("cellAddress")
            cellValuesOptions.append(mainContactsPresenter.mainContactSelected.contactAddress)
        }
        
        for contactPhone in mainContactsPresenter.mainContactSelected.contactPhones {
            cellIdentifierOptions.append(contactPhone.contactPhoneType)
            cellValuesOptions.append(contactPhone.contactPhoneNumber)
        }
        
        mainProfileTV.reloadData()
    }
}

extension ContactDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifierOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cellIdentifierOptions[indexPath.row] {
        case "cellProfile":
            return 335
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellIdentifierOptions[indexPath.row] {
        case "cellProfile":
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "cellProfile") as! ContactProfileTableViewCell
            profileCell.setupCell(contactIn: mainContactsPresenter.mainContactSelected)
            profileCell.selectionStyle = .none
            return profileCell
            
        default:
            let profileInfoCell = tableView.dequeueReusableCell(withIdentifier: "cellProfileInfo") as! ContactProfileInfoTableViewCell
            profileInfoCell.setupCell(valueIn: cellValuesOptions[indexPath.row], identifierIn: cellIdentifierOptions[indexPath.row])
            profileInfoCell.selectionStyle = .none
            return profileInfoCell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch cellIdentifierOptions[indexPath.row] {
        case "cellProfile":
            return false
        default:
            if self.cellValuesOptions[indexPath.row] == "Not Register" {
                return false
            }else{
                return true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        switch cellIdentifierOptions[indexPath.row] {
        case "cellAddress":
            let seeMapAct = UITableViewRowAction(style: .normal, title: "See in Map", handler: { action, index in
                self.buildMSGAlert(titleIn: "SOON", msgIn: ";)", buttonsIn: [["Title" : "Aceptar", "Action" : ""]])
            })
            
            seeMapAct.backgroundColor = UIColor().buildHexColor(hexIn: "#C06C84")
            return [seeMapAct]
        default:
            let makeCallAct = UITableViewRowAction(style: .normal, title: "Call", handler: { action, index in
                self.canMakePhoneCall(phoneNumIn: self.cellValuesOptions[index.row])
            })
            
            makeCallAct.backgroundColor = UIColor().buildHexColor(hexIn: "#FECEAB")
            return [makeCallAct]
        }
    }
}
