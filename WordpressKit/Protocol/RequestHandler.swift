//
//  RequestHandler.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 28/10/2019.
//  Copyright © 2019 Giuseppe Sapienza. All rights reserved.
//

import Foundation

protocol WordpressHandler: Equatable {
    associatedtype T
    var id: UUID { get }
    var operation: (T) -> () { get set }
}

protocol WordpressHandlerExecutable {
    func execute(data: Data?, error: Error?)
}

extension WordpressHandler {
    var id: UUID {
        UUID()
    }
}

extension WordpressHandler {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
