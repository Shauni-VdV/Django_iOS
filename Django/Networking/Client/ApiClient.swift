//
//  ApiClient.swift
//  Django
//
//  Created by Shauni Van de Velde on 27/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//
// Reusable Request method references:
// SOURCE: https://stackoverflow.com/questions/52591866/whats-the-correct-usage-of-urlsession-create-new-one-or-reuse-same-one

import Foundation
import Alamofire
import SwiftyJSON

class ApiClient {
    static let apiKey = "1db8f6ebe89295a86017d0bfe634af7b"
    
    enum Endpoints {
        static let baseUrl = "https://api.themoviedb.org/3"
        // De TMDB API gebruikt query parameters ipv headers om de API Key mee te geven
        static let apiKeyParam = "?api_key=\(ApiClient.apiKey)"
        
        case getPopular
        case getLatest
        case search(String)
        case login
        case getRequestToken
        case postSessionId
        
        
        var endpointString: String {
            
            switch self {
            case .getPopular: return Endpoints.baseUrl + "/movie/popular" + Endpoints.apiKeyParam
            case .getLatest: return Endpoints.baseUrl + "/movie/latest" + Endpoints.apiKeyParam
            case .search(let query): return Endpoints.baseUrl + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            case .login: return Endpoints.baseUrl + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .getRequestToken: return Endpoints.baseUrl + "/authentication/token/new" + Endpoints.apiKeyParam
            case .postSessionId: return Endpoints.baseUrl + "/authentication/session/new" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL{
            return URL(string: endpointString)!
        }
    }
    
    // Functie voor een GET request, zodat dit niet voor elke call herhaald moet worden
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
                    let errorResponse = try decoder.decode(TMDbResponse.self, from: data) as Error
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
    
    // Functie voor een POST request, zodat dit niet voor elke call herhaald moet worden
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
                    let errorResponse = try decoder.decode(TMDbResponse.self, from: data) as Error
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
    
    
    // GET: Populaire films
    class func getPopular(completion: @escaping([Movie], Error?) -> Void) {
        print("Entering getPopular in ApiClient")
        getRequestTask(url: Endpoints.getPopular.url,responseType: MovieListResponse.self){response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // GET: Meest recente films
    class func getLatest(completion: @escaping([Movie], Error?) -> Void) {

        getRequestTask(url: Endpoints.getLatest.url,responseType: MovieListResponse.self){response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // Search
    class func search(query: String, completion: @escaping([Movie], Error?) -> Void ) -> URLSessionDataTask{
        print("Entering search in ApiClient")
        let task = getRequestTask(url: Endpoints.search(query).url, responseType: MovieListResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
        return task
    }
    
    
    // MARK: -Authenticatie
    struct LoginRequest: Codable {
        
        let username: String
        let password: String
        let requestToken: String
        
        enum CodingKeys: String, CodingKey {
            case username
            case password
            case requestToken = "request_token"
        }
    }
    
    static var requestToken = ""
    static var sessionId = ""

    
    // Ingewikkelde manier van inloggen, zie : https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id
    // GET: RequestToken
    // MARK: -STAP 1 VAN AUTHENTICATIE
    class func getRequestToken(completion: @escaping(Bool, Error?) -> Void) {
        getRequestTask(url: Endpoints.getRequestToken.url, responseType: TokenResponse.self) { response, error in
            if let response = response {
                requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    // POST: Login
    // MARK: - STAP 2 VAN AUTHENTICATIE
       class func login(username: String, password: String, completion: @escaping(Bool, Error?) -> Void){
           let requestBody = LoginRequest(username: username, password: password, requestToken: requestToken)
           postRequestTask(url: Endpoints.login.url, responseType: TokenResponse.self, body: requestBody) { response, error in
               if let response = response {
                   requestToken = response.requestToken
                   completion(true, nil)
               } else {
                   completion(false, error)
               }
           }
       }
    
    //MARK: -STAP 3 VAN AUTHENTICATIE
    struct PostSession: Codable {
        
        let requestToken: String
        
        enum CodingKeys: String, CodingKey {
            case requestToken = "request_token"
        }
        
    }
    
    // POST: SessionId
    class func postSessionId(completion: @escaping(Bool, Error?) -> Void) {
        let requestBody = PostSession(requestToken : requestToken)
        postRequestTask(url: Endpoints.postSessionId.url, responseType: SessionResponse.self, body: requestBody) { response, error in
            if let response = response {
                sessionId = response.sessionId
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
   
    
}

