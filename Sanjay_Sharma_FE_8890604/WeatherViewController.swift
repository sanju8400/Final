//
//  WeatherViewController.swift
//  Sanjay_Sharma_FE_8890604
//
//  Created by user238626 on 4/13/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController , CLLocationManagerDelegate {
    //Location manager
    let manager = CLLocationManager()
    //plus button
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    //Label for city
    @IBOutlet weak var cityName: UILabel!
    
    // Label for location
    @IBOutlet weak var labelLocation: UILabel!
    
    // Label for weather type
    @IBOutlet weak var labelWeather: UILabel!
    
    // Image for weather icon
    @IBOutlet weak var imageIcon: UIImageView!
    
    // Label for temperature
    @IBOutlet weak var labelTemp: UILabel!
    
    // Label for humidity
    @IBOutlet weak var labelHumidity: UILabel!
    
    // Label for wind speed
    @IBOutlet weak var labelWind: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentLocation = manager.location else {
            print("Error: Unable to retrieve current location.")
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found.")
                return
            }
            
            // Extract city name from placemark
            if let city = placemark.locality {
                print("Current city: \(city)")
                // Call API method with city name
                self.makeAPICalltoGetData(for: city)
            } else {
                print("City name not found.")
            }
        }

    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter City Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first, let cityName = textField.text {
                self?.makeAPICalltoGetData(for: cityName)
            }
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Get JSON data
    func makeAPICalltoGetData(for cityName: String) {
        // Create URL using city name
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCityName)&appid=d3f0956caa7ad29a06e029f9a9cb7c0e") else {
            return
        }
        
        
        // Fetch JSON data from server using URL
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            // If data received from server, proceed
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8) ?? "No data")
                    
                    // Decode data using Weather struct
                    let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                    
                    // Pass weather data to update labels on view thread
                    DispatchQueue.main.async {
                        self.updateLabels(weather: jsonData)
                    }
                } catch {
                    print("Error decoding data.")
                }
            } else {
                print("Error getting data from server.")
            }
        }
        task.resume()
    }
    
    // Get weather icon image
    func getImage(icon: String) {
        // Create URL using icon string
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
        
        // Fetch image from server using URL
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            // If image received from server, proceed
            if let data = data {
                // Set image to received icon on main thread
                DispatchQueue.main.async {
                    self.imageIcon.image = UIImage(data: data)
                }
            } else {
                print("Error getting icon from server.")
            }
        }
        task.resume()
    }
    
    // Update view with weather data
    func updateLabels(weather: Weather) {
        // Get needed variables from decoded data
        let name = weather.name
        let weatherText = weather.weather[0].main
        let icon = weather.weather[0].icon
        let temp = Int(weather.main.temp - 273.15)
        let humidity = weather.main.humidity
        let wind = weather.wind.speed
        
        // Set labels to corresponding variables
        labelLocation.text = name
        labelWeather.text = weatherText
        labelTemp.text = "\(temp)°"
        labelHumidity.text = "Humidity: \(humidity)%"
        labelWind.text = "Wind: \(wind) km/h"
        
        // Get icon image
        getImage(icon: icon)
    }
}
