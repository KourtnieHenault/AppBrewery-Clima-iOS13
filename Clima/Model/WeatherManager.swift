//
//  test.swift
//  Clima
//
//  Created by Kourtnie Jenkins on 3/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=eb58fc80bc8cc1ebaef040d8bacbf934&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        let url = "\(weatherURL)&q=\(city)"
        performRequest(with: url)
    }
    
    func fetchWeather(city: String, state: String){
        let url = "\(weatherURL)&q=\(city),\(state)"
        performRequest(with: url)
    }
    
    func fetchWeather(latitude: Double, longitude: Double){
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URL Sessino
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
//            let task = session.dataTask(with: url, completionHandler: handleCompletion(data: response: error: ))
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let weatherModel = self.mapWeatherDataToWeatherModel(data: safeData) {
                        self.delegate?.updateWeather(self, weatherModel: weatherModel)
                        print(weatherModel.cityName)
                    }
                }
            }
            
            //4. Start trhe task
            task.resume()   // Called "resume" instead of "start" because when this task is created it begin in a suspended state.
            
        }
        
    }
    
    func mapWeatherDataToWeatherModel(data: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let parsedWeatherData = try decoder.decode(WeatherData.self, from: data)
            
            let id = parsedWeatherData.weather[0].id
            let temperature = parsedWeatherData.main.temp
            let cityName = parsedWeatherData.name
            
            return WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
            
            
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        return nil
    }
    
}


