//
//  NetworkManager.swift
//  Pods
//
//  Created by Yriy Malyts on 05.06.2025.
//

final class NetworkHandler {
    
    static func fetchAzureToken(completion: @escaping (Result<String, Error>) -> Void) {
        guard let userData = UserDefaults.standard.loadUserData() else {
            completion(.failure(NSError(domain: "NoUserDataError", code: -1)))
            return
        }
        
        guard let url = URL(string: userData.baseUrl) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let query = """
        query GetUserProfile {
          getUserProfile {
            azure_acs_token
          }
        }
        """
        
        let body: [String: Any] = [
            "query": query,
            "variables": [:],
            "operationName": "GetUserProfile"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "SerializationError", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(userData.appToken)", forHTTPHeaderField: "Authorization")
        request.setValue("ef6ce2e0-0b9e-4039-b4fc-6c34356d11dc", forHTTPHeaderField: "x-api-key")
        request.setValue("\(userData.languageCode)", forHTTPHeaderField: "hasura-lng")
        request.setValue("\(userData.languageCode)", forHTTPHeaderField: "Accept-Language")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if
                    let data = json?["data"] as? [String: Any],
                    let getUserProfile = data["getUserProfile"] as? [String: Any],
                    let token = getUserProfile["azure_acs_token"] as? String
                {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "ParsingError", code: -1)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
