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

public class bellande_battery_usage_activity {
    private let batteryUsageService: bellande_battery_usage_service
    private let connectivityPasscode: String
    
    public init() {
        guard let config = Self.loadConfigFromFile() else {
            fatalError("Failed to load configuration")
        }
        
        guard let apiUrl = config["url"] as? String,
              let endpointPaths = config["endpoint_path"] as? [String: String],
              let inputEndpoint = endpointPaths["input_data"],
              let outputEndpoint = endpointPaths["output_data"],
              let apiAccessKey = config["Bellande_Framework_Access_Key"] as? String,
              let connectivityPasscode = config["connectivity_passcode"] as? String else {
            fatalError("Invalid configuration format")
        }
        
        self.connectivityPasscode = connectivityPasscode
        
        let batteryUsageAPI = bellande_battery_usage_api(baseURL: apiUrl)
        self.batteryUsageService = bellande_battery_usage_service(
            apiURL: apiUrl,
            inputEndpoint: inputEndpoint,
            outputEndpoint: outputEndpoint,
            apiAccessKey: apiAccessKey,
            batteryUsageAPI: batteryUsageAPI
        )
    }
    
    private static func loadConfigFromFile() -> [String: Any]? {
        guard let url = Bundle.module.url(forResource: "config/configs", withExtension: "json") else {
            print("Could not find config/configs.json")
            return nil
        }
    
        do {
            let data = try Data(contentsOf: url)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("Error loading config: \(error)")
            return nil
        }
    }
}
