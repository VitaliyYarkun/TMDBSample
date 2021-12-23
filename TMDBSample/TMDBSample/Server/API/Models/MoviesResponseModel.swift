struct MoviesResponseModel: ModelResponsable {
    enum CodingKeys: String, CodingKey {
        case moviesList = "results"
    }
    
    // MARK: Decodable
    
    init(from decoder: Decoder) throws {
        let _ = try decoder.container(keyedBy: CodingKeys.self).decodeIfPresent([Movie].self, forKey: .moviesList)
    }
}
