//
//  HttpConnection.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 29/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class HttpConnection: NSObject, HttpConnectionProtocol {
    
    var serverTrustPolicy: ServerTrustPolicy!
    var serverTrustPolicies: [String : AnyObject]!
    var afManager: SessionManager!
    
    func get(url: String,
             params: [String: AnyObject],
             headers: [String: String],
             onSuccess: @escaping (AnyObject) -> Void,
             onFailure: @escaping (AnyObject) -> Void) {
        request(url: url, method: .get, params: params, headers:headers, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func post(url: String,
              params: [String: AnyObject],
              headers: [String: String],
              onSuccess: @escaping (AnyObject) -> Void,
              onFailure: @escaping (AnyObject) -> Void) {
        request(url: url, method: .post, params: params, headers:headers, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func put(url: String,
             params: [String: AnyObject],
             headers: [String: String],
             onSuccess: @escaping (AnyObject) -> Void,
             onFailure: @escaping (AnyObject) -> Void) {
        request(url: url, method: .put, params: params, headers:headers, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func delete(url: String,
                params: [String: AnyObject],
                headers: [String: String],
                onSuccess: @escaping (AnyObject) -> Void,
                onFailure: @escaping (AnyObject) -> Void) {
        request(url: url, method: .delete, params: params, headers:headers, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func request(url: String,
                 method: HTTPMethod,
                 params: [String: AnyObject],
                 headers: [String: String],
                 onSuccess: @escaping (AnyObject) -> Void,
                 onFailure: @escaping (AnyObject) -> Void) {
        
        Alamofire.request(url, method: method, parameters: params, headers: headers)
            .validate()
            .responseJSON { response in
                debugPrint(response.request!)
                debugPrint(response.result)
                
                switch response.result {
                case .success(let data):
                    onSuccess(data as AnyObject)
                case .failure(let error):
                    onFailure(error as AnyObject)
                }
        }
    }

}
