protocol TokenManageable: KeychainService {
    func accessToken() throws -> String?
    func saveAccessToken(_ token: String) throws
}

extension TokenManageable {
    func accessToken() throws -> String? {
        return try keychainItem(for: KeychainKey.accessToken)
    }
    
    func saveAccessToken(_ token: String) throws {
        try setKeychainItem(token, for: KeychainKey.accessToken)
    }
}
