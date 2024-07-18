/**
 * Copyright (C) 2024 Bellande Application UI UX Research Innovation Center, Ronaldson Bellande
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 **/

import Foundation

public class bellande_gpu_usage_api {
    private let baseURL: String
    private let session: URLSession
    
    public init(baseURL: String) {
        self.baseURL = baseURL
        self.session = URLSession.shared
    }
    
    public func performRequest(url: String, body: RequestBody, apiKey: String, completion: @escaping (Result<BellandeResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL + url) else {
            completion(.failure(NSError(domain: "BellandeGPUUsage", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Bellande-Framework-Access-Key")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "BellandeGPUUsage", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let bellandeResponse = try JSONDecoder().decode(BellandeResponse.self, from: data)
                completion(.success(bellandeResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func getBellandeResponse(url: String, body: RequestBody, apiKey: String, completion: @escaping (Result<BellandeResponse, Error>) -> Void) {
        performRequest(url: url, body: body, apiKey: apiKey, completion: completion)
    }
    
    public func sendBellandeResponse(url: String, body: RequestBody, apiKey: String, completion: @escaping (Result<BellandeResponse, Error>) -> Void) {
        performRequest(url: url, body: body, apiKey: apiKey, completion: completion)
    }
}

public struct RequestBody: Codable {
    let input: String
    let connectivityPasscode: String
}

public struct BellandeResponse: Codable {
    let gpuUsage: String?
    let status: String?
}
