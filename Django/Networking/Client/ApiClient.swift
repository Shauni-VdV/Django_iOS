//
//  ApiClient.swift
//  Django
//
//  Created by Shauni Van de Velde on 27/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import Foundation

class ApiClient {
    static let apiKey = "1db8f6ebe89295a86017d0bfe634af7b"
    
    enum Endpoints {
        static let baseUrl = "https://api.themoviedb.org/3"
        // De TMDB API gebruikt query parameters ipv headers om de API Key mee te geven
        static let apiKeyParam = "?api_key=\(ApiClient.apiKey)"
        
        case getPopular
        case getLatest
        case search(String)
        
        
        var endpointString: String {
            
            switch self {
            case .getPopular: return Endpoints.baseUrl + "/movie/popular" + Endpoints.apiKeyParam
            case .getLatest: return Endpoints.baseUrl + "/movie/latest" + Endpoints.apiKeyParam
            case .search(let query): return Endpoints.baseUrl + "/movie/search" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            }
        }
        
        var url: URL{
            return URL(string: endpointString)!
        }
    }
    
    class func getRequestTask<ResponseType: Decodable>(
        url: URL, responseType: ResponseType.Type,
        completion: @escaping(ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async{
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func postRequestTask<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getPopular(completion: @escaping([Movie], Error?) -> Void) {
        getRequestTask(url: Endpoints.getPopular.url,responseType: MovieListResponse.self){response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    
    class func getLatest(completion: @escaping([Movie], Error?) -> Void) {
        getRequestTask(url: Endpoints.getLatest.url,responseType: MovieListResponse.self){response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
}

