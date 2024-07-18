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

public class bellande_gpu_temperature_service {
    private let gpuTemperatureAPI: bellande_gpu_temperature_api
    private let apiAccessKey: String
    private let inputEndpoint: String
    private let outputEndpoint: String
    
    public init(apiURL: String, inputEndpoint: String, outputEndpoint: String, apiAccessKey: String, gpuTemperatureAPI: bellande_gpu_temperature_api) {
        self.gpuTemperatureAPI = gpuTemperatureAPI
        self.apiAccessKey = apiAccessKey
        self.inputEndpoint = inputEndpoint
        self.outputEndpoint = outputEndpoint
    }
    
    public func getGpuTemperature(connectivityPasscode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody = RequestBody(input: "get_gpu_temperature", connectivityPasscode: connectivityPasscode)
        gpuTemperatureAPI.getBellandeResponse(url: inputEndpoint, body: requestBody, apiKey: apiAccessKey) { result in
            switch result {
            case .success(let response):
                if let gpuTemperature = response.gpuTemperature {
                    completion(.success(gpuTemperature))
                } else {
                    completion(.failure(NSError(domain: "error sending GPU TEMPERATURE:", code: 0, userInfo: [NSLocalizedDescriptionKey: "GPU temperature not found in response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func sendGpuTemperature(gpuTemperature: String, connectivityPasscode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody = RequestBody(input: gpuTemperature, connectivityPasscode: connectivityPasscode)
        gpuTemperatureAPI.sendBellandeResponse(url: outputEndpoint, body: requestBody, apiKey: apiAccessKey) { result in
            switch result {
            case .success(let response):
                if let status = response.status {
                    completion(.success(status))
                } else {
                    completion(.failure(NSError(domain: "error sending GPU TEMPERATURE:", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status not found in response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
