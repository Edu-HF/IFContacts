//
//  APIClient.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 29/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import Foundation
import Alamofire

class APIClient: NSObject {

    fileprivate var serverURL: String
    fileprivate var client: HttpConnectionProtocol
    
    init(serverURL: String) {
        self.serverURL = serverURL
        client = HttpConnection()
    }
    
    //REQUEST GET
    func requestGET(url: String, params: [String : AnyObject], qParams: [NSURLQueryItem]?, headers: [String : String], handler: ResponseHandler)  {
        
        let mURL = serverURL + url
        let mainCompURL = NSURLComponents.init(string: mURL)
        if qParams != nil {
            mainCompURL?.queryItems = qParams! as [URLQueryItem]
        }
        let mainURL = mainCompURL?.url
        
        print("Parametros: ", params)
        print("MainURL: ", mainURL ?? "URL Vacia")
        
        Alamofire.request(mainURL!, parameters: params, headers: headers).responseString { response in
            
            switch response.result {
            case .success(let value):
                if let sCode = response.response?.statusCode {
                    switch(sCode){
                    case 200:
                        print("JSON: ", value)
                        let jsonResponse = self.jsonStringToDic(stringIn: value)
                        handler.onSuccess(jsonResponse as AnyObject)
                    case 400, 401:
                        print("JSON: ", value)
                        handler.onFailure("An error occurred while trying to establish the connection to the server. Please try later" as AnyObject)
                    default:
                        print("JSON: ", value)
                        handler.onFailure(NSLocalizedString("E_WS_STANDAR_ERROR", comment: "") as AnyObject)
                    }
                }
            case .failure(let error):
                print("Error: ", error)
                handler.onFailure(NSLocalizedString("E_WS_STANDAR_ERROR", comment: "") as AnyObject)
            }
        }
    }
    
    func jsonStringToDic(stringIn: String) -> [Dictionary<String,Any>] {
        
        let jsonData:Data = stringIn.data(using: .utf8)!
        if let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>] {
            if jsonArray != nil {
                return jsonArray!
            }else{
                return [["Response" : stringIn as AnyObject]]
            }
        }else {
            return [["Response" : stringIn as AnyObject]]
        }
    }
}
