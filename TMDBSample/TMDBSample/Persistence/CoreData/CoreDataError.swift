/**
 General type for handling CoreData errors
 */
enum CoreDataError: Error {
    
    /// Used when failed to decode NSManagedObjectContext from Decoder using CodingUserInfoKey
    case contextDecode(reason: String)
    
    /// Used when there is missing data in local DB
    case missingData(reason: String)
}
