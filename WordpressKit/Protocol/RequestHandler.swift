//
//  RequestHandler.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 28/10/2019.
//  Copyright © 2019 Giuseppe Sapienza. All rights reserved.
//

import Foundation

protocol WordpressRequestHandler {
    associatedtype T
    var operation: (T) -> () { get set }
}

protocol WordpressRequestHandlerExecutable {
    func execute(data: Data?, error: Error?)
}
