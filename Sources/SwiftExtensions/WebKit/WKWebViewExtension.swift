//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

#if canImport(WebKit)

import WebKit

public extension WKWebView {
    
    @discardableResult
    func loadURL(_ url: URL, timeoutInterval: TimeInterval? = nil) -> WKNavigation? {
        var request = URLRequest(url: url)
        if let timeoutInterval = timeoutInterval {
            request.timeoutInterval = timeoutInterval
        }
        
        return load(request)
    }
    
    @discardableResult
    func loadURLString(_ urlString: String, timeoutInterval: TimeInterval? = nil) -> WKNavigation? {
        guard let url = URL(string: urlString) else { return nil }
        return loadURL(url, timeoutInterval: timeoutInterval)
    }
}

#endif
