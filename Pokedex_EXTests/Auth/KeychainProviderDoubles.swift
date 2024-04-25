@testable import Pokedex_EX
import Foundation

class DummyKeychainProvider: Keychain {
    func getItem(account: Pokedex_EX.KeychainAccount, accessGroup: String?) -> String? {
        return nil
    }
    
    func saveItem(account: Pokedex_EX.KeychainAccount, item: String, accessGroup: String?) {}
    
    func deleteItem(account: Pokedex_EX.KeychainAccount, accessGroup: String?) {}
}

class SpyKeychainProvider: Keychain {
    var getItem_argument_account: KeychainAccount? = nil
    func getItem(account: Pokedex_EX.KeychainAccount, accessGroup: String?) -> String? {
        getItem_argument_account = account
        return nil
    }
    
    var saveItem_argument_account: KeychainAccount? = nil
    var saveItem_argument_item: String? = nil
    func saveItem(account: Pokedex_EX.KeychainAccount, item: String, accessGroup: String?) {
        saveItem_argument_account = account
        saveItem_argument_item = item
    }
    
    var deleteItem_argument_account: KeychainAccount? = nil
    func deleteItem(account: Pokedex_EX.KeychainAccount, accessGroup: String?) {
        deleteItem_argument_account = account
    }
}

class StubKeychainProvider: Keychain {
    var getItem_returnValue: String? = nil
    func getItem(account: Pokedex_EX.KeychainAccount, accessGroup: String?) -> String? {
        return getItem_returnValue
    }
    
    func saveItem(account: Pokedex_EX.KeychainAccount, item: String, accessGroup: String?) {
    }
    
    func deleteItem(account: Pokedex_EX.KeychainAccount, accessGroup: String?) {
    }
}
