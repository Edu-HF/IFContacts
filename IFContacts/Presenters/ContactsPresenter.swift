//
//  ContactsPresenter.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 24/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import ViewAnimator

class ContactsPresenter: NSObject {

    fileprivate var dataManager: DataManagerProtocol!
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    var mainContactsData: [Contact] = []
    var mainContactSelected: Contact!
    var mainVCIn: MainBaseViewController!
    var mainFilterContactsData: [Contact] = []
    var mainContactTitlesIndex: [String] = []
    var mainContactDic = [String : [Contact]]()
    var mainFilterHeaderTitle: [String] = ["Resultados por Nombre"]
    
    required init(mainViewIn: MainBaseViewController) {
        super.init()
        dataManager = DataManager(presenterIn: self)
        mainVCIn = mainViewIn
    }
    
    func getContactsList() {
        dataManager.getContactsList()
    }
    
    func getContactDetail(contactIDIn: Int) {
        dataManager.getContactDetail(contactIDIn: contactIDIn)
    }
    
    func setContactList(mainContactsDataIn: [Contact]) {
        
        mainContactsData = mainContactsDataIn
        mainContactTitlesIndex = []
        mainContactDic = [String : [Contact]]()
        for tempContact in mainContactsData {
            let cKey = String(tempContact.contactFName.prefix(1))
            if var contactV = mainContactDic[cKey] {
                contactV.append(tempContact)
                mainContactDic[cKey] = contactV
            }else{
                mainContactDic[cKey] = [tempContact]
            }
        }
        
        mainContactTitlesIndex = [String](mainContactDic.keys)
        mainContactTitlesIndex = mainContactTitlesIndex.sorted(by: { $0 < $1 })
        
        mainVCIn.refreshUI()
    }
    
    func setContactDetail(contactDetailIn: Contact) {
        mainContactSelected = contactDetailIn
        mainVCIn.refreshUI()
    }
    
    func filterContactsForSB(searchTextIn: String, scopeIn: String = "All") {
        
        mainFilterContactsData = mainContactsData.filter({( contact : Contact) -> Bool in
            return contact.contactFName.lowercased().contains(searchTextIn.lowercased())
        })
        
        mainVCIn.refreshUI()
    }
    
    func showError(msgIn: Any) {
        mainVCIn.removeLoading()
        mainVCIn.buildMSGAlert(titleIn: "Conection Error", msgIn: msgIn, buttonsIn: [["Title" : "Aceptar", "Action" : ""]])
    }
}
