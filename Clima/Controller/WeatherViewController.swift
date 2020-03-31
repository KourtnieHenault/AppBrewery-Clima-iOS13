//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }
    
    
    @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let city = searchTextField.text ?? ""
        weatherManager.fetchWeather(city: city)
        searchTextField.endEditing(true)
        
    }
    
    // Delegate - Triggered when user clicks 'Return' button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "")
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // Delegate - Triggered when .endEditing(true) has fired
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func updateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel) {
        
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            self.temperatureLabel.text = weatherModel.temperatureString
            self.cityLabel.text = weatherModel.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

