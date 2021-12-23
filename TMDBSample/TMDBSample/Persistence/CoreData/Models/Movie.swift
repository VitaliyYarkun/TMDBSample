import CoreData

@objc(Movie)
class Movie: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case movieId = "id"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard
            let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedObjectContext)
        else { throw CoreDataError.contextDecode(reason: "Failed to decode Movie") }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        do { self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) } catch DecodingError.typeMismatch { self.backdropPath = nil }
        movieId = try container.decodeIfPresent(Int32.self, forKey: .movieId) ?? 0
        do { self.mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType) } catch DecodingError.typeMismatch { self.mediaType = nil }
        do { self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) } catch DecodingError.typeMismatch { self.originalLanguage = nil }
        do { self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) } catch DecodingError.typeMismatch { self.originalTitle = nil }
        do { self.overview = try container.decodeIfPresent(String.self, forKey: .overview) } catch DecodingError.typeMismatch { self.overview = nil }
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0
        do { self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) } catch DecodingError.typeMismatch { self.posterPath = nil }
        do { self.releaseDate = DateFormatter.releaseDate.date(from: try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? "") } catch DecodingError.typeMismatch { self.releaseDate = nil }
        do { self.title = try container.decodeIfPresent(String.self, forKey: .title) } catch DecodingError.typeMismatch { self.title = nil }
        video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        voteCount = try container.decodeIfPresent(Int32.self, forKey: .voteCount) ?? 0
    }
}

extension Movie {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged var adult: Bool
    @NSManaged var backdropPath: String?
    @NSManaged var movieId: Int32
    @NSManaged var mediaType: String?
    @NSManaged var originalLanguage: String?
    @NSManaged var originalTitle: String?
    @NSManaged var overview: String?
    @NSManaged var popularity: Double
    @NSManaged var posterPath: String?
    @NSManaged var releaseDate: Date?
    @NSManaged var title: String?
    @NSManaged var video: Bool
    @NSManaged var voteAverage: Double
    @NSManaged var voteCount: Int32
    @NSManaged var posterThumbnail: Data?
    @NSManaged var poster: MoviePoster?
}

// MARK: - Identifiable

extension Movie: Identifiable {}
