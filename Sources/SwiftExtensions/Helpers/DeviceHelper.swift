//
//  File.swift
//
//
//  Created by Jo on 2022/11/1.
//

#if os(macOS) && canImport(Foundation)

import Foundation

///
///
///  用户设备相关的信息获取与缓存类
///
///
public class DeviceInfo {
    private struct Entry {
        var value: String?
    }
    
    /// 支持获取的设备信息
    public enum ValueKey: String {
        /// 设备的uuid
        case platformUUID
        /// 串号
        case serialNumber
        /// 系统版本
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
    
    /// 获取设备的指定类型信息
    /// - Parameter key: 获取信息的key
    /// - Returns: 查找到的结果
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
