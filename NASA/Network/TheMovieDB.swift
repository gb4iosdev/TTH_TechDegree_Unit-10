//
//  TheMovieDB.swift
//  MovieNight
//
//  Created by Gavin Butler on 13-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

//Sign in Info:
//

import Foundation

enum TheMovieDB {
    case discover(genres: String?, certifications: String?, actors: String?)
    case genreList
    case certificationList
    case actorList
    case image(imageId: String)                    //the part returned from poster_path on the movie
}

//conforms to the Endpoint protocol to assist with URL creation.
extension TheMovieDB: Endpoint {
    var path: String {
        switch self {
        case .discover: return "/3/discover/movie"
        case .genreList: return "/3/genre/movie/list"
        case .certificationList: return "/3/certification/movie/list"
        case .actorList: return "/3/person/popular"
        case .image: return "/t/p/w92"
        }
    }
    
    var queryParameters: [URLQueryItem] {
        
        var result = [URLQueryItem]()
        let apiKey = "77bed8fca392b4795936215c684e2e95"
        
        switch self {
        //Main Discover query for movie fetches.
        case .discover(let genres, let certifications, let actors):
            //Add the query items if present
            if let genres = genres {
                let genreQueryItem = URLQueryItem(name: ParameterKey.genres.rawValue, value: genres)
                result.append(genreQueryItem)
            }
            if let certifications = certifications {
                let certificationQueryItem = URLQueryItem(name: ParameterKey.certifications.rawValue, value: certifications)
                result.append(certificationQueryItem)
            }
            if let actors = actors {
                let actorsQueryItem = URLQueryItem(name: ParameterKey.actors.rawValue, value: actors)
                result.append(actorsQueryItem)
            }
            result.append(URLQueryItem(name: ParameterKey.api_key.rawValue, value: apiKey))
            result.append(URLQueryItem(name: ParameterKey.sortBy.rawValue, value: "popularity.desc"))
        //List query parameters for each data type.
        case .genreList:
            result.append(URLQueryItem(name: ParameterKey.language.rawValue, value: "en-US"))
            result.append(URLQueryItem(name: ParameterKey.api_key.rawValue, value: apiKey))
        case .certificationList:
            result.append(URLQueryItem(name: ParameterKey.certificationCountry.rawValue, value: "CA"))
            result.append(URLQueryItem(name: ParameterKey.api_key.rawValue, value: apiKey))
        case .actorList:
            result.append(URLQueryItem(name: ParameterKey.api_key.rawValue, value: apiKey))
        //Image query handled separately.
        case .image:
            break
        }
        
        return result
    }
    
    var base: String {
        switch self {
        case .image:        return "https://image.tmdb.org"
        default:            return "https://api.themoviedb.org"
        }
    }
    
    //Image request handled separately to bypass QueryParameters creation.  No parameters required for this endpoint.
    func requestForImage() -> URLRequest? {
        switch self {
        case .image(let imageId):
            var components = URLComponents(string: base)!
            components.path = path + imageId
            return URLRequest(url: components.url!)
        default:    return nil
        }
    }
}
