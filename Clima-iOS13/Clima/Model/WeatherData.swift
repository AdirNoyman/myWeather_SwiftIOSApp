//
//  weatherData.swift
//  Clima
//
//  Created by אדיר נוימן on 13/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {

    struct Fields: Codable {

        let name: String
        let main: Main
        let weather: [Weather]
        
    }

    let list: [Fields]

}

struct Main: Codable {



        let temp: Double


}

struct Weather: Codable {



        let id: Int


}

