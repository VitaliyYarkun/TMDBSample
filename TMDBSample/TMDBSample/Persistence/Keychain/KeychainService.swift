import Foundation

// MARK: - Keys

enum KeychainKey {
    static let accessToken = "AccessToken"
}

// MARK: - Protocol

protocol KeychainService {
    func keychainItem<T>(for key: String) throws -> T?
    func setKeychainItem<T>(_ item: T?, for key: String, authenticated: Bool) throws
}

// MARK: - Internal

extension KeychainService {
    func keychainItem<T>(for key: String) throws -> T? {
        let query = [kSecClass as String: kSecClassGenericPassword as String,
                     kSecAttrService as String: walletSecAttrService,
                     kSecAttrAccount as String: key,
                     kSecReturnData as String: true as Any]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == noErr || status == errSecItemNotFound else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
        guard let data = result as? Data else { return nil }

        switch T.self {
        case is Data.Type:
            return data as? T
        case is String.Type:
            return CFStringCreateFromExternalRepresentation(secureAllocator, data as CFData,
                                                            CFStringBuiltInEncodings.UTF8.rawValue) as? T
        case is Int64.Type:
            guard data.count == MemoryLayout<T>.stride else { return nil }
            return data.withUnsafeBytes({ $0.load(as: T.self) })
        case is Dictionary<AnyHashable, Any>.Type:
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
        default:
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errSecParam))
        }
    }
    
    func setKeychainItem<T>(_ item: T?, for key: String, authenticated: Bool = false) throws {
        let accessible = (authenticated) ? kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
                                         : kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String
        let query = [kSecClass as String: kSecClassGenericPassword as String,
                     kSecAttrService as String: walletSecAttrService,
                     kSecAttrAccount as String: key]
        var status = noErr
        var data: Data?
        if let item = item {
            switch item {
            case let item as Data:
                data = item
            case let item as String:
                data = CFStringCreateExternalRepresentation(secureAllocator, item as CFString,
                                                            CFStringBuiltInEncodings.UTF8.rawValue, 0) as Data
            case let item as Int64:
                data = CFDataCreateMutable(secureAllocator, MemoryLayout<T>.stride) as Data
                [item].withUnsafeBufferPointer { data?.append($0) }
            case let item as [AnyHashable: Any]:
                data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
            default:
                throw NSError(domain: NSOSStatusErrorDomain, code: Int(errSecParam))
            }
        }

        if data == nil { // delete item
            if SecItemCopyMatching(query as CFDictionary, nil) != errSecItemNotFound {
                status = SecItemDelete(query as CFDictionary)
            }
        } else if SecItemCopyMatching(query as CFDictionary, nil) != errSecItemNotFound { // update existing item
            let update = [kSecAttrAccessible as String: accessible,
                          kSecValueData as String: data as Any]
            status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        } else { // add new item
            let item = [kSecClass as String: kSecClassGenericPassword as String,
                        kSecAttrService as String: walletSecAttrService,
                        kSecAttrAccount as String: key,
                        kSecAttrAccessible as String: accessible,
                        kSecValueData as String: data as Any]
            status = SecItemAdd(item as CFDictionary, nil)
        }

        guard status == noErr else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
    }
}

// MARK: - Private

private extension KeychainService {
    var walletSecAttrService: String {
        return "com.sample.TMDBSample"
    }
}
