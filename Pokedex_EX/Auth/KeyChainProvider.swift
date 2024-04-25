import Foundation

protocol Keychain {
    func getItem(account: KeychainAccount, accessGroup: String?) -> String?
    func saveItem(account: KeychainAccount, item: String, accessGroup: String?)
    func deleteItem(account: KeychainAccount, accessGroup: String?)
}

class KeychainProvider: Keychain {
    let service: String = "test.Pokedex-EX"
    
    func getItem(account: KeychainAccount, accessGroup: String? = nil) -> String? {
        do {
            let currentItem = try readItemHelper(account: account, accessGroup: accessGroup)
            
            return currentItem
        } catch {
            return nil
        }
    }
    
    func saveItem(account: KeychainAccount, item: String, accessGroup: String? = nil) {
        do {
            try saveItemHelper(account: account, accessGroup: accessGroup, item: item)
        } catch {
            print("Unable to save \(account.rawValue) to keychain.")
        }
    }
    
    func deleteItem(account: KeychainAccount, accessGroup: String? = nil) {
        do {
            try deleteItemHelper(account: account, accessGroup: accessGroup)
        } catch {
            print("Unable to delete \(account.rawValue) from keychain.")
        }
    }
    
    private func readItemHelper(account: KeychainAccount, accessGroup: String? = nil) throws -> String {
        var query = keychainQuery(
            account: account,
            accessGroup: accessGroup
        )
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    private func saveItemHelper(account: KeychainAccount, accessGroup: String? = nil, item: String) throws {
        let encodedPassword = item.data(using: String.Encoding.utf8)
        do {
            try _ = readItemHelper(account: account, accessGroup: accessGroup)
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = keychainQuery(
                account: account,
                accessGroup: accessGroup
            )
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            var newItem = keychainQuery(
                account: account,
                accessGroup: accessGroup
            )
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else {
                throw KeychainError.unhandledError
            }
        }
    }
    
    private func deleteItemHelper(account: KeychainAccount, accessGroup: String? = nil) throws {
        let query = keychainQuery(
            account: account,
            accessGroup: accessGroup
        )
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError
        }
    }
    
    private func keychainQuery(
        account: KeychainAccount,
        accessGroup: String? = nil
    ) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        query[kSecAttrAccount as String] = account.rawValue as AnyObject?
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
}

enum KeychainAccount: String {
    case accessToken
}
