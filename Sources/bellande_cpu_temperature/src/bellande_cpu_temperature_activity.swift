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

public class bellande_cpu_temperature_activity {
    private let cpuTemperatureService: bellande_cpu_temperature_service
    private let connectivityPasscode: String
    
    public init(configURL: URL) {
        let config = Self.loadConfigFromFile(configURL)
        let apiUrl = config["url"] as! String
        let endpointPaths = config["endpoint_path"] as! [String: String]
        let inputEndpoint = endpointPaths["input_data"]!
        let outputEndpoint = endpointPaths["output_data"]!
        let apiAccessKey = config["Bellande_Framework_Access_Key"] as! String
        self.connectivityPasscode = config["connectivity_passcode"] as! String
        
        let cpuTemperatureAPI = bellande_cpu_temperature_api(baseURL: apiUrl)
        self.cpuTemperatureService = bellande_cpu_temperature_service(
            apiURL: apiUrl,
            inputEndpoint: inputEndpoint,
            outputEndpoint: outputEndpoint,
            apiAccessKey: apiAccessKey,
            cpuTemperatureAPI: cpuTemperatureAPI
        )
    }
    
    private static func loadConfigFromFile(_ url: URL) -> [String: Any] {
        do {
            let data = try Data(contentsOf: url)
            return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        } catch {
            fatalError("bellande_cpu_temperature_activity: Error reading config file: \(error.localizedDescription)")
        }
    }
}
