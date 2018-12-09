//
//  DataManager.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 29/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import Gloss

protocol InteractorOutputProtocol {
    func onFailure(_ failure: AnyObject)
    func onError(_ error: AnyObject)
}

enum APIResource: String {
    
    case mainURL            = "https://private-d0cc1-iguanafixtest.apiary-mock.com"
    case getContacts        = "/contacts"
    case getContactDetail   = "/contacts/"
}

class DataManager: NSObject, DataManagerProtocol, InteractorOutputProtocol {
    
    fileprivate var clientAPI: APIClient
    var mainPresenter: NSObject?
    
    required init(presenterIn: NSObject) {
        mainPresenter = presenterIn
        clientAPI = APIClient(serverURL: APIResource.mainURL.rawValue)
    }
    
    func getContactsList() {
        
        let handler = ResponseHandler(onSuccess: { info in
            
            if let mainCPresenter = self.mainPresenter as? ContactsPresenter {
                if let cJSONArray = info as? NSArray {
                    var mainContactsData: [Contact] = []
                    for contac in cJSONArray {
                        let contactJson = contac as! JSON
                        let tempContact = Contact(json: contactJson)
                        if tempContact != nil {
                            let phonesA: NSArray? = contactJson["phones"] as? NSArray
                            if phonesA != nil {
                                for phoneJson in phonesA! {
                                    if let tempPhone = ContactPhones(json: phoneJson as! JSON) {
                                        tempContact?.contactPhones.append(tempPhone)
                                    }
                                }
                            }
                            mainContactsData.append(tempContact!)
                        }
                    }
                    mainCPresenter.setContactList(mainContactsDataIn: mainContactsData)
                }
            }
            
        }, output: self)
        
        clientAPI.requestGET(url: APIResource.getContacts.rawValue, params: [:], qParams: nil, headers: [:], handler: handler)
    }
    
    func getContactDetail(contactIDIn: Int) {
        
        let urlWithID = APIResource.getContactDetail.rawValue + String(contactIDIn)
        
        let handler = ResponseHandler(onSuccess: { info in
            
            if let mainCPresenter = self.mainPresenter as? ContactsPresenter {
                if let cJSONArray = info as? NSArray {
                    for contac in cJSONArray {
                        if let tempJsonR = contac as? [String : Any] {
                            if let tempContactDic =  self.parseStringToDic(jsonStringIn: tempJsonR["Response"] as! String) {
                                let contactJson = tempContactDic as JSON
                                let tempContact = Contact(json: contactJson)
                                if tempContact != nil {
                                    let phonesA: NSArray? = contactJson["phones"] as? NSArray
                                    if phonesA != nil {
                                        for phoneJson in phonesA! {
                                            if let tempPhone = ContactPhones(json: phoneJson as! JSON) {
                                                tempContact?.contactPhones.append(tempPhone)
                                            }
                                        }
                                    }
                                    let addressA: NSArray? = contactJson["addresses"] as? NSArray
                                    if addressA != nil {
                                        for addressO in addressA! {
                                            let addressJSON = addressO as! JSON
                                            if let tempAddress: String = addressJSON["home"] as? String {
                                                tempContact?.contactAddress = tempAddress
                                            }
                                        }
                                    }
                                    
                                    mainCPresenter.setContactDetail(contactDetailIn: tempContact!)
                                }
                            }
                        }
                    }
                }
            }
            
        }, output: self)
        
        clientAPI.requestGET(url: urlWithID, params: [:], qParams: nil, headers: [:], handler: handler)
    }
    
    func parseStringToDic(jsonStringIn: String) -> [String:AnyObject]? {
        if let data = jsonStringIn.data(using: .utf8) {
            do {
                return (try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject])!
            } catch let error as NSError {
                print(error)
            }
        }
        
        return nil
    }
    
    //MARK: InteractorOutputProtocol Methods
    func onFailure(_ failure: AnyObject){
        print("ERROR API: ", failure)
        if let mainCPresenter = self.mainPresenter as? ContactsPresenter {
            mainCPresenter.showError(msgIn: failure)
        }
    }
    
    func onError(_ error: AnyObject){
        if let mainCPresenter = self.mainPresenter as? ContactsPresenter {
            mainCPresenter.showError(msgIn: error)
        }
    }
}
