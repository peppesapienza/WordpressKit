//
//  Result.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 02/11/2019.
//  Copyright © 2019 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public struct WordpressResult<T> {
    public let value: T?
    public let error: Error?
}
