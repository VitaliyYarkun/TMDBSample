import Foundation

class BaseService: CoreDataManageable {
    let mainQueue: DispatchQueue = DispatchQueue.main
    let userInitiatedBackgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    let defaultBackgroundQueue: DispatchQueue = DispatchQueue.global(qos: .default)
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = coreDataStack.mainContext
        return decoder
    }()
}
