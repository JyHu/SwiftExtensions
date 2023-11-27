//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

#if os(macOS)
public extension URL {
    func bookmarkData(options: URL.BookmarkCreationOptions = .withSecurityScope) throws -> Data {
        return try bookmarkData(options: options, includingResourceValuesForKeys: nil, relativeTo: nil)
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
}
#endif

///
/// 在 macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0 下，
/// 通过带有 percentEncoded 参数的方法获取相关属性会崩溃，目前
/// Foundation框架内暂无修复，只能通过使用老方法来获取
///
public extension URL {
    func getHost(percentEncoded: Bool = true) -> String? {
        return host
    }
    
    func getUser(percentEncoded: Bool = true) -> String? {
        return user
    }
    
    func getPassword(percentEncoded: Bool = true) -> String? {
        return password
    }
    
    func getPath(percentEncoded: Bool = true) -> String {
        return path
    }
    
    func getQuery(percentEncoded: Bool = true) -> String? {
        return query
    }
    
    func getFragment(percentEncoded: Bool = true) -> String? {
        return fragment
    }
    
    func hostAndPath(percentEncoded: Bool = true) -> String {
        let path = getPath(percentEncoded: percentEncoded)
        if let host = getHost(percentEncoded: percentEncoded) {
            return host + "/" + path
        }
        return path
    }
}

public extension URL {
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
        guard let fragment = getFragment(), !fragment.isEmpty else {
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
        components?.fragment = params.toURLQuery()
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
        components?.query = params.toURLQuery()
        return components?.url ?? self
    }
    
    func relativePath(to url: URL) -> String {
        return getPath().relate(to: url.getPath(), relativePath: "~")
    }
}

#endif
