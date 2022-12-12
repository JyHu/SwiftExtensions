//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension URL {
#if os(macOS)
    func bookmarkData() throws -> Data {
        return try bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
    }
    
    func bookmarkBase64EncodedString() throws -> String? {
        return (try bookmarkData()).base64EncodedString()
    }
    
    static func bookmarkURL(from base64EncodedString: String) throws -> URL? {
        guard let data = Data(base64Encoded: base64EncodedString) else {
            return nil
        }
        
        return try accessedBookmarkURL(from: data)
    }
    
    static func accessedBookmarkURL(from bookmarkData: Data) throws -> URL? {
        var isState = true
        
        let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isState)
        
        guard url.startAccessingSecurityScopedResource(),
              try url.checkResourceIsReachable(),
              try url.checkPromisedItemIsReachable() else {
            return nil
        }
        
        if isState {
            return nil
        }
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        return url
    }
#endif
    
    var queryParams: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        var params: [String: String] = [:]
        
        for queryItem in queryItems {
            params[queryItem.name] = queryItem.value
        }
        
        return params
    }
    
    var fragmentParams: [String: String]? {
        guard let fragment = fragment, !fragment.isEmpty else {
            return nil
        }
        
        let valueParts = fragment.components(separatedBy: "&")
        var params: [String: String] = [:]
        
        for valuePart in valueParts {
            let tmpArr = valuePart.components(separatedBy: "=")
            guard tmpArr.count == 2 else { continue }
            params[tmpArr[0]] = tmpArr[1]
        }
        
        return params
    }
    
    func resetFragment(with params: [String: String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.fragment = params.toURLQueryParams()
        return components?.url ?? self
    }
    
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponent = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponent.queryItems = (urlComponent.queryItems ?? []) + parameters.map { URLQueryItem(name: $0, value: $1)
        }
        
        if let targetURL = urlComponent.url { return targetURL }
        return self
    }
    
    func resetQuery(with params: [String: String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.query = params.toURLQueryParams()
        return components?.url ?? self
    }
}

#endif
