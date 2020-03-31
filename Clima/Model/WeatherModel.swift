//
//  WeatherModel.swift
//  Clima
//
//  Created by Kourtnie Jenkins on 3/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var conditionName: String {
            
            var weatherConditionIcon: String
            
            switch conditionId {
            case 200...299:
                weatherConditionIcon = "cloud.bolt"
            case 300...399:
                weatherConditionIcon = "cloud.drizzle"
            case 500...599:
                weatherConditionIcon = "cloud.rain"
            case 600...699:
                weatherConditionIcon = "snow"
            case 700...799:
                weatherConditionIcon = "cloud.fog"
            case 800:
                weatherConditionIcon = "sun.max"
            case 801...899:
                weatherConditionIcon = "cloud"
            default:
                weatherConditionIcon = "cloud"
            }
            
            return weatherConditionIcon
        
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
}

    

    
