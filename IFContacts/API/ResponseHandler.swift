//
//  ResponseHandler.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 29/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit

class ResponseHandler {

    let onSuccess: (AnyObject) -> Void
    let onFailure: (AnyObject) -> Void
    let onError: (AnyObject) -> Void
    
    init(onSuccess: @escaping (AnyObject) -> Void,
         onFailure: @escaping (AnyObject) -> Void,
         onError: @escaping (AnyObject) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.onError = onError
    }
    
    convenience init(onSuccess: @escaping (AnyObject) -> Void,
                     output: InteractorOutputProtocol) {
        self.init(onSuccess: onSuccess,
                  onFailure: { status in output.onFailure(status) },
                  onError: { error in output.onError(error) })
    }
}
