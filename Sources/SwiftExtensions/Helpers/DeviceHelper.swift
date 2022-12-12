//
//  File.swift
//
//
//  Created by Jo on 2022/11/1.
//

#if os(macOS) && canImport(Foundation)

import Foundation

public class DeviceInfo {
    private struct Entry {
        var value: String?
    }
    
    public enum ValueKey: String {
        case platformUUID
        case serialNumber
        case systemVersion
        
        fileprivate var value: String {
            switch self {
            case .platformUUID: return kIOPlatformUUIDKey
            case .serialNumber: return kIOPlatformSerialNumberKey
            case .systemVersion: return "systemVersion"
            }
        }
    }
    
    private static var shared = DeviceInfo()
    private init() { }
    
    private var entriesCache: [String: Entry] = [:]
    
    public static func get(_ key: ValueKey) -> String? {
        if let entry = shared.entriesCache[key.value] {
            return entry.value
        }
        
        func cacheReturn(_ val: String?) -> String? {
            shared.entriesCache[key.value] = Entry(value: val)
            return val
        }
        
        if key == .systemVersion {
            return cacheReturn(shared.getSystemVersion())
        }
        
        return cacheReturn(shared.iovalue(for: key.value))
    }
}

private extension DeviceInfo {
    func getSystemVersion() -> String {
        let systemInfo = ProcessInfo().operatingSystemVersion
        let sysVer = "\(systemInfo.majorVersion).\(systemInfo.minorVersion)"
        if systemInfo.patchVersion == 0 {
            return sysVer
        }
        
        return "\(sysVer).\(systemInfo.patchVersion)"
    }
    
    func iovalue(for key: String) -> String? {
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        let ioproperty = IORegistryEntryCreateCFProperty(platformExpert, key as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        return ioproperty?.takeUnretainedValue() as? String
    }
}

#endif
