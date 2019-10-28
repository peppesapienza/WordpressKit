//
//  WordpressSessionManager.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 15/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let sessionDidComplete = Notification.Name(rawValue: "sessionDidComplete")
}


class WordpressSessionManager: NSObject, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    init(request: WordpressGetRequest) {
        self.request = request
        super.init()
    }
    
    fileprivate var request: WordpressGetRequest?
    fileprivate var receivedData: Data?
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard receivedData != nil else {
            receivedData = data
            return
        }

        receivedData?.append(data)
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        defer {
            request = nil
            session.invalidateAndCancel()
        }
        
        guard error == nil else {
            NotificationCenter.default.post(name: .sessionDidComplete, object: self, userInfo: [
                "error" : error!
            ])
            return
        }
        
        guard let data = self.receivedData else {
            NotificationCenter.default.post(name: .sessionDidComplete, object: self, userInfo: [
                "error" : WordpressResponseError.sessionDataIsNil
            ])
            return
        }
        
        NotificationCenter.default.post(name: .sessionDidComplete, object: self, userInfo: [
            "data" : data
        ])
        
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
