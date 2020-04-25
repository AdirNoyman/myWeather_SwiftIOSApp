//
//  WeatherManager.swift
//  Clima
//
//  Created by אדיר נוימן on 12/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/find?appid=<enter Appid key from openWeather site>"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)&units=metric"
        
        print(urlString)
        
        performRequest(with: urlString)
        
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&units=metric"
        
        performRequest(with: urlString)
        print(urlString)
        
        
        
    }
    
    func performRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                    self.delegate?.didFailWithError(error: error!)
                    
                    return
                }
                
                if let safeData = data {
                    
                    if let weather = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)

                    }
                    
                }
            }
            // 4. Start the task
            task.resume()
        }
        
        
        
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].main.temp
            let name = decodedData.list[0].name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print("The condition name is \(weather.conditionName)")
            print("The Temperture to dispaly is \(weather.tempDisplay)")
            
            print(decodedData.list[0].name)
            print(decodedData.list[0].main.temp)
            print(decodedData.list[0].weather[0].id)
            
            return weather
            
                
            } catch {
            
                delegate?.didFailWithError(error: error)
            return nil
        }
        
       
    }
    

}
