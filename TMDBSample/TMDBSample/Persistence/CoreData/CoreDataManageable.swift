import UIKit
import CoreData

protocol CoreDataManageable {
    var coreDataStack: CoreDataStack { get }
    
    func saveCoreDataContext()
}

extension CoreDataManageable {
    var coreDataStack: CoreDataStack {
        return (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    }
    
    func saveCoreDataContext() {
        coreDataStack.saveContext()
    }
}
