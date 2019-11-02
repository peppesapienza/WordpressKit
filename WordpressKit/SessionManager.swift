//
//  WordpressSessionManager.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 15/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

class WordpressSessionManager: NSObject, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    init(delegate: WordpressSessionDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    fileprivate var delegate: WordpressSessionDelegate?
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        delegate?.wordpressTask(task: dataTask, didReceive: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        delegate?.wordpressTask(task: task, didCompleteWith: error)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        guard
            let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode),
            let mimeType = response.mimeType,
            mimeType == "application/json"
        else {
            completionHandler(.cancel)
            return
        }
        
        completionHandler(.allow)
    }
    
    deinit {
        print("[🔥] WordpressSessionManager deinit")
    }
}
