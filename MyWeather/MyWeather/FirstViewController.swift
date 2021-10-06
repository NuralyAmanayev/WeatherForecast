//
//  FirstViewController.swift
//  MyWeather
//
//  Created by Nuraly Amanayev on 10/4/21.
//

import Foundation
import CoreLocation
import UIKit


class FirstViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var models = [listModel]()

    @IBAction func sharePressed(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["\(models[0].dt_txt), \(String(models[0].main.celsius))°С, \(String(models[0].weather[0].description))"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet var labelTemp: UILabel!
    @IBOutlet var labelLocation: UILabel!
    @IBOutlet var labelHumidity: UILabel!
    @IBOutlet var labelTempKf: UILabel!
    @IBOutlet var labelPressure: UILabel!
    @IBOutlet var labelSpeed: UILabel!
    @IBOutlet var labelWind: UILabel!
    
    @IBOutlet var imageTemp: UIImageView!
    @IBOutlet var windSpeed: UIImageView!
    @IBOutlet var wind: UIImageView!
    @IBOutlet var pressure: UIImageView!
    @IBOutlet var humidity: UIImageView!
    @IBOutlet var drop: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    // Location
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let longitude = currentLocation.coordinate.longitude
        let latitude = currentLocation.coordinate.latitude
        let apiKey = "5308895e59599bce50322cbfd1f66036"
        
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        print(url)
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            // validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            // convert data to models/some object
            
            var json: weatherResponse?
            do{
                json = try JSONDecoder().decode(weatherResponse.self, from: data)
            }
            catch{
                print("error: \(error)")
            }
            
            guard let result = json else{
                return
            }

            
            print(result.list[0].main.celsius)
            let entries = result.list
            self.models.append(contentsOf: entries)
            /////////////////////

            
            
            
            
            
            DispatchQueue.main.async {
//                self.table.reloadData()
                
                self.labelTemp.text = "\(String(self.models[0].main.celsius))°С | \(self.models[0].weather[0].main)"
                self.labelLocation.text = "\(String(result.city.name)), \(result.city.country)"
                self.labelHumidity.text = "\(String(self.models[0].main.humidity))%"
                self.labelTempKf.text = "\(String(self.models[0].main.temp_kf)) mm"
                self.labelPressure.text = "\(String(self.models[0].main.pressure)) hPa"
                self.labelSpeed.text = "\(String(self.models[0].wind.speed))"
                self .labelWind.text = "\(self.models[0].wind.direction!)"
                self.drop.image = UIImage(named: "drop")
                self.humidity.image = UIImage(named: "humidity")
                self.pressure.image = UIImage(named: "pressure")
                self.wind.image = UIImage(named: "wind")
                self.windSpeed.image = UIImage(named: "windSpeed")


                self.imageTemp.contentMode = .scaleAspectFit

                let icon = self.models[0].weather[0].main.lowercased()
                if icon.contains("clear"){
                    self.imageTemp.image = UIImage(named: "clear")
                }
                else if icon.contains("clouds"){
                    self.imageTemp.image = UIImage(named: "cloud")
                }
                else if icon.contains("rain"){
                    self.imageTemp.image = UIImage(named: "rain")
                }
                else if icon.contains("snow"){
                    self.imageTemp.image = UIImage(named: "snow")
                }
                else {
                    self.imageTemp.image = UIImage(named: "sunny")
                }
                
            }
        
        }).resume()

    }
    
    
}


