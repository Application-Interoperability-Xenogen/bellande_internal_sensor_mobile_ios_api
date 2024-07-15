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

public class bellande_network_usage_service {
    private let networkUsageAPI: bellande_network_usage_api
    private let apiAccessKey: String
    private let inputEndpoint: String
    private let outputEndpoint: String
    
    public init(apiURL: String, inputEndpoint: String, outputEndpoint: String, apiAccessKey: String, networkUsageAPI: bellande_network_usage_api) {
        self.networkUsageAPI = networkUsageAPI
        self.apiAccessKey = apiAccessKey
        self.inputEndpoint = inputEndpoint
        self.outputEndpoint = outputEndpoint
    }
    
    public func getNetworkUsage(connectivityPasscode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody = RequestBody(input: "get_network_usage", connectivityPasscode: connectivityPasscode)
        networkUsageAPI.getBellandeResponse(url: inputEndpoint, body: requestBody, apiKey: apiAccessKey) { result in
            switch result {
            case .success(let response):
                if let networkUsage = response.networkUsage {
                    completion(.success(networkUsage))
                } else {
                    completion(.failure(NSError(domain: "error sending NETWORK USAGE:", code: 0, userInfo: [NSLocalizedDescriptionKey: "NETWORK usage not found in response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func sendNetworkUsage(networkUsage: String, connectivityPasscode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody = RequestBody(input: networkUsage, connectivityPasscode: connectivityPasscode)
        networkUsageAPI.sendBellandeResponse(url: outputEndpoint, body: requestBody, apiKey: apiAccessKey) { result in
            switch result {
            case .success(let response):
                if let status = response.status {
                    completion(.success(status))
                } else {
                    completion(.failure(NSError(domain: "error sending NETWORK USAGE:", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status not found in response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
