import CoreData

@objc(MoviePoster)
class MoviePoster: NSManagedObject {

}

extension MoviePoster {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MoviePoster> {
        return NSFetchRequest<MoviePoster>(entityName: "MoviePoster")
    }

    @NSManaged var poster: Data?
    @NSManaged var movie: Movie?
}

// MARK: - Identifiable

extension MoviePoster: Identifiable {}
