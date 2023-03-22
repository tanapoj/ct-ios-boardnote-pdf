//
//  CTCache.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 26/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Cache
import Kingfisher

public enum CacheExpiry: TimeInterval { // second
    case never  = 0
    case minute = 60        // 1 minute
    case hour   = 3600      // 1 hour
    case day    = 86400     // 1 day
    case week   = 604800    // 7 day
    case month  = 2592000   // 30 day
    case year   = 31536000  // 365 day
}

open class Cache {
    private static let directoryPath = "Preferences"
    private static let name = "\(Application.bundleName).cache"
    private static let memoryConfig = MemoryConfig(expiry: .never, countLimit: 50, totalCostLimit: 0)
    private static var storage: Storage<Data>?
    private static var version: String = "0.0"
    public static var getName: String {
        get {
            return "\(name).\(version)"
        }
    }
    
    // MARK: - Handler
    public typealias onMapping = (_ json: [String:Any]) -> Any?
    public typealias onSuccess = (_ result: Any?) -> Void
    public typealias onCompletion = () -> Void
    
    // MARK: - configure
    public static func configure(version ver: String = "0.0") {
        version = ver
        let diskConfig = DiskConfig(
            name: "\(name).\(version)",
            expiry: .never,
            maxSize: 0,
            directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(directoryPath),
            protectionType: .complete
        )
        do {
            storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
        } catch {
            CLog("error: \(error)")
        }
    }
    private static func expiryDuration(_ expiry: TimeInterval) -> Expiry {
        var result: Expiry = .never
        if expiry > 0 {
            result = Expiry.date(Date().addingTimeInterval(expiry))
        }
        return result
    }
    
    // MARK: - JSONObject
    public static func save(key: String, object: Any, expiry: TimeInterval = 0, onSuccess: onSuccess? = nil, onCompletion: onCompletion? = nil) {
        if let object = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) {
            var msg = ":Save Data:"
            guard let storage = self.storage else {
                CLog("\(msg) storage is NULL")
                if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
                return
            }
            let expiryDuration = self.expiryDuration(expiry)
            storage.async.setObject(object, forKey: key, expiry: expiryDuration, completion: { (result) in
                var source: Bool = false
                switch result {
                case .value:
                    source = true
                    msg = "\(msg)\nKey: \(key)\nExpiry: \(expiryDuration)"
                case .error(let error):
                    msg = "\(msg)\nError: \(error)"
                }
                CLog(msg)
                if let onSuccess = onSuccess, source == true {
                    DispatchQueue.main.async {
                        onSuccess(source)
                    }                    
                }
                if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
            })
        }
        else {
            CLog(":Save Data: jsonObject is NULL")
            if let onCompletion = onCompletion { onCompletion() }
        }
    }
    public static func fetch(key: String, onMapping: onMapping?, onSuccess: onSuccess? = nil, onCompletion: onCompletion? = nil) {
        var msg = ":Fetch Data: \(key)"
        guard let storage = self.storage else {
            CLog("\(msg) storage is NULL")
            if let onSuccess = onSuccess { DispatchQueue.main.async(execute: { onSuccess(nil) }) }
            if let onCompletion = onCompletion { onCompletion() }
            return
        }
        storage.async.object(forKey: key) { (result) in
            var data: Data?
            switch result {
            case .value(let value):
                data = value
                msg = "\(msg)\nKey: \(key)"
            case .error(let error):
                msg = "\(msg)\nError: \(error)"
            }
            CLog(msg)
            var object: Any?
            if let data = data {
                let obj = try? JSONSerialization.jsonObject(with: data, options: [])
                if let onMapping = onMapping {
                    if let obj = obj as? [String:Any] {
                        object = onMapping(obj)
                    }
                }
                else {
                    object = obj
                }
            }
            if let onSuccess = onSuccess { DispatchQueue.main.async(execute: { onSuccess(object) }) }
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
        }
    }
    
    
    // MARK: - Clear
    public static func removeKey(_ key: String, onCompletion: onCompletion? = nil) {
        var msg = ":Remove Key:"
        guard let storage = self.storage else {
            CLog("\(msg) storage is NULL")
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
            return
        }
        storage.async.removeObject(forKey: key) { (result) in
            switch result {
                case .value(let value): msg = "\(msg)\nKey: \(key)\nResult: \(value)"
                case .error(let error): msg = "\(msg)\nError: \(error)"
            }
            CLog(msg)
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
        }
    }
    public static func clearExpiredData(onCompletion: onCompletion? = nil) {
        var msg = ":Clear Expired Data:"
        guard let storage = self.storage else {
            CLog("\(msg) storage is NULL")
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
            return
        }
        // Clear expired objects
        storage.async.removeExpiredObjects { (result) in
            switch result {
                case .value(let value): msg = "\(msg)\nResult: \(value)"
                case .error(let error): msg = "\(msg)\nError: \(error)"
            }
            CLog(msg)
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
        }
    }
    public static func clearAllData(onCompletion: onCompletion? = nil) {
        var msg = ":Clear All Data:"
        guard let storage = self.storage else {
            CLog("\(msg) storage is NULL")
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
            return
        }
        storage.async.removeAll { (result) in
            switch result {
                case .value(let value): msg = "\(msg)\nResult: \(value)"
                case .error(let error): msg = "\(msg)\nError: \(error)"
            }
            CLog(msg)
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
        }
    }

    public static func backgroundClearExpiredImage() {
        CLog(":Background Clear Expired Image:")
        ImageCache.default.backgroundCleanExpiredDiskCache()
    }
    public static func clearExpiredImage(onCompletion: onCompletion? = nil) {
        var msg = ":Clear Expired Image:"
        ImageCache.default.cleanExpiredDiskCache(completion: {
            msg = "\(msg)\nResult: completion"
            CLog(msg)
            if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
        })
    }
    public static func clearAllImage(onCompletion: onCompletion? = nil) {
        var msg = ":Clear All Image:"
        ImageCache.default.clearMemoryCache()
        ImageCache.default.cleanExpiredDiskCache(completion: {
            ImageCache.default.clearDiskCache(completion: {
                msg = "\(msg)\nResult: completion"
                CLog(msg)
                if let onCompletion = onCompletion { DispatchQueue.main.async(execute: onCompletion) }
            })
        })
    }
}
