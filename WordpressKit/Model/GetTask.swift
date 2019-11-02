//
//  GetTask.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 02/11/2019.
//  Copyright © 2019 Giuseppe Sapienza. All rights reserved.
//

import Foundation

class WordpressGetTask {
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    let id: UUID = UUID()
    var state: URLSessionTask.State { task.state }
    var taskIdentifier: Int { task.taskIdentifier }
    
    fileprivate var data: Data?
    fileprivate var error: Error?
    fileprivate let task: URLSessionDataTask
    fileprivate var handlers: [WordpressHandlerExecutable] = []
    
    fileprivate var originalRequest: URLRequest? {
        task.originalRequest
    }
    
    fileprivate var currentRequest: URLRequest? {
        task.currentRequest
    }

    func resume() {
        task.resume()
    }
    
    func cancel() {
        task.cancel()
    }
    
    func add(handler: WordpressHandlerExecutable) {
        handlers.append(handler)
    }
    
    func received(data: Data) {
        self.data = (self.data == nil) ? data : self.data! + data
    }
    
    func complete(with error: Error?) {
        self.error = error
        handlers.forEach({ $0.execute(data: data, error: error) })
    }

    deinit {
        print("[🔥] WordpressGetTask deinit")
    }
    
}


extension WordpressGetTask: Hashable, Equatable {
    static func == (lhs: WordpressGetTask, rhs: WordpressGetTask) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
