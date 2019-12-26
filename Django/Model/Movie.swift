//
//  Movie.swift
//  Django
//
//  Created by Shauni Van de Velde on 26/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import Foundation

// Struct based on the response from the API
public struct MovieListResponse: Codable{
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Movie]
}

// Movie class that has all attributes a Movie from the API does
public struct Movie: Codable{
    public let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let releaseDate: Date
    public let voteAverage: Double
    public let voteCount: Int
    public let tagline: String?
    public let genres: String?
    public let videos: String?
    public let credits: String?
    public let adult: Bool
    public let runtime: Int?
    public var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
        }
    public var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath ?? "")")!
    }
}
