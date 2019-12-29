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

class ApiClient {
    static let apiKey = "1db8f6ebe89295a86017d0bfe634af7b"
    
    
    struct Account {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
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
        case getFavorites
        case addToFavorites
        
        
        var endpointString: String {
            
            switch self {
            case .getPopular: return Endpoints.baseUrl + "/movie/popular" + Endpoints.apiKeyParam
                
            case .getLatest: return Endpoints.baseUrl + "/movie/latest" + Endpoints.apiKeyParam
                
            case .search(let query): return Endpoints.baseUrl + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
                
            case .login: return Endpoints.baseUrl + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
                
            case .getRequestToken: return Endpoints.baseUrl + "/authentication/token/new" + Endpoints.apiKeyParam
                
            case .postSessionId: return Endpoints.baseUrl + "/authentication/session/new" + Endpoints.apiKeyParam
                
            case .getFavorites : return Endpoints.baseUrl + "/account/\(Account.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Account.sessionId)"
                
            case .addToFavorites: return Endpoints.baseUrl + "/account/\(Account.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Account.sessionId)"
                
            }
        }
        
        var url: URL{
            return URL(string: endpointString)!
        }
    }
    
    // GET: Populaire films
    class func getPopular(completion: @escaping([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getPopular.url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    // GET: Meest recente films
    class func getLatest(completion: @escaping([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getLatest.url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
 
    // Voeg toe aan favorieten
    class func addToFavorites(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
        
        let url = Endpoints.addToFavorites.url
             let body : [String: Any] = ["media_type": "movie", "media_id": movieId, "favorite": favorite]
             
             let session = URLSession.shared
             
             var request = URLRequest(url: url)
             request.httpMethod = "POST"
             do {
                 
                 request.httpBody = try JSONSerialization.data(withJSONObject: body)
                 
             } catch let error {
                 
                 print(error.localizedDescription)
                 completion(false, error)
             }
             
             request.addValue("application/json", forHTTPHeaderField: "Content-Type")
             request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request){ data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(TMDbResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
        
        
        
    }
    
    // Favorieten
    class func getFavorites(completion: @escaping([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getFavorites.url) {
            data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    
    // Search
    class func search(query: String, completion: @escaping([Movie], Error?) -> Void ) -> URLSessionDataTask{
        
        let task = URLSession.shared.dataTask(with: Endpoints.search(query).url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
        return task
    }
    
    
    
    // MARK: -Authenticatie
    struct LoginRequest: Codable {
        
        let username: String
        let password: String
        let requestToken: String
        
        func toJSON() -> Dictionary<String, String> {
            return [
                "username": self.username,
                "password": self.password,
                "request_token": self.requestToken
            ]
            
        }
        enum CodingKeys: String, CodingKey {
            case username = "username"
            case password = "password"
            case requestToken = "request_token"
        }
    }
    
    
    // Ingewikkelde manier van inloggen, zie : https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id
    // GET: RequestToken
    // MARK: -STAP 1 VAN AUTHENTICATIE
    class func getRequestToken(completion: @escaping(Bool, Error?) -> Void) {
        print("Entering getRequestToken")
        
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(TokenResponse.self, from: data)
                Account.requestToken = response.requestToken
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    
    
    // POST: Login
    // MARK: - STAP 2 VAN AUTHENTICATIE
    class func login(username: String, password: String, completion: @escaping(Bool, Error?) -> Void){
        print("Entering login")
        let url = Endpoints.login.url
        let body : [String: Any] = ["username": username, "password": password, "request_token": Account.requestToken]
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
        } catch let error {
            
            print(error.localizedDescription)
            completion(false, error)
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request){ data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(TokenResponse.self, from: data)
                Account.requestToken = response.requestToken
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    
    //MARK: -STAP 3 VAN AUTHENTICATIE
    struct PostSession: Codable {
        
        let requestToken: String
        
        func toJSON() -> Dictionary<String, String> {
            return [
                "request_token": self.requestToken,
            ]
            
        }
        
        enum CodingKeys: String, CodingKey {
            case requestToken = "request_token"
        }
        
    }
    
    // POST: SessionId
    class func postSessionId(completion: @escaping(Bool, Error?) -> Void) {
        print("Entering postSessionId")
        
        let url = Endpoints.postSessionId.url
        let body = PostSession(requestToken: Account.requestToken).toJSON()
        print(body)
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(false, error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(SessionResponse.self, from: data)
                Account.sessionId = response.sessionId
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        })
        task.resume()
    }
}



