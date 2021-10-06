//
//  ViewController.swift
//  MyWeather
//
//  Created by Nuraly Amanayev on 10/1/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet var table: UITableView!
    
    
    var models = [listModel]()


    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)

        
        table.delegate = self
        table.dataSource = self
        
        
                
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

            
//            print(result.list[0].main.celsius)
            let entries = result.list
            self.models.append(contentsOf: entries)

//            print(getDayForDate(self.models[0].date))
            
            // update user interface
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader(locationLabel1: result.city.name)
            }
        
        }).resume()

//        print("\(longitude) | \(latitude)")
    }

    // Table
    
    func createTableHeader(locationLabel1: String) -> UIView{
        let headerView = UIView(frame: CGRect(x: 10, y: 10, width: view.frame.size.width, height: view.frame.size.height/11))
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height))
        headerView.addSubview(locationLabel)
        locationLabel.textAlignment = .center
        locationLabel.text = locationLabel1
        return headerView
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
        cell.configure(with: models[indexPath.row])

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

 
    }
 

}



struct weatherResponse: Codable {
    var cod: String
    var message: Float
    var cnt: Float
    var list: [listModel]
    var city: listCity
    
}

struct listModel: Codable {
    var dt: TimeInterval
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
    var main: mainModel
    var weather: [weatherModel]
    var wind: windModel
    var visibility: Int?
    var pop: Float?
    var dt_txt: String
}

struct mainModel: Codable {
    var temp: Float
    var celsius: Int {
        return Int(round(temp - 273.15))
    }
    var pressure: Float
    var humidity: Int
    var temp_kf: Float

}

struct weatherModel: Codable {
    var main: String
    var description: String
    var icon: String
    
}

struct windModel: Codable {
    
    let speed: Float
    let deg: Float?
    
    enum Direction: String {
        case north = "N"
        case northEast = "NE"
        case east = "E"
        case southEast = "SE"
        case south = "S"
        case southWest = "SW"
        case west = "W"
        case northWest = "NW"
        
        init(deg: Float) {
            if deg < 23 || deg > 337 {
                self = .north
            } else if deg < 68 {
                self = .northEast
            } else if deg < 113 {
                self = .east
            } else if deg < 158 {
                self = .southEast
            } else if deg < 203 {
                self = .south
            } else if deg < 248 {
                self = .southWest
            } else if deg < 293 {
                self = .west
            } else {
                self = .northWest
            }
        }
    }
    
    var direction: String? {
        guard let deg = deg else { return nil }
        return Direction(deg: deg).rawValue
    }
    
}

struct listCity:Codable {
    var name:String
    var country:String

}

