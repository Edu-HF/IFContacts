//
//  HttpConnectionProtocol.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 29/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

protocol HttpConnectionProtocol {
    
    func get(url: String,
             params: [String: AnyObject],
             headers: [String: String],
             onSuccess: @escaping (AnyObject) -> Void,
             onFailure: @escaping (AnyObject) -> Void)
    func post(url: String,
              params: [String: AnyObject],
              headers: [String: String],
              onSuccess: @escaping (AnyObject) -> Void,
              onFailure: @escaping (AnyObject) -> Void)
    func put(url: String,
             params: [String: AnyObject],
             headers: [String: String],
             onSuccess: @escaping (AnyObject) -> Void,
             onFailure: @escaping (AnyObject) -> Void)
    func delete(url: String,
                params: [String: AnyObject],
                headers: [String: String],
                onSuccess: @escaping (AnyObject) -> Void,
                onFailure: @escaping (AnyObject) -> Void)
}
