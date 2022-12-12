//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Int) async throws {
        let duration = UInt64(seconds * Int(1e9))
        try await sleep(nanoseconds: duration)
    }
}
