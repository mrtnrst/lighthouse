//
//  Weather.swift
//  lighthouse
//
//  Created by Martin on 5/6/17.
//  Copyright © 2017 builtby. All rights reserved.
//

import Alamofire
import Foundation
import CoreLocation
import UIKit

struct CurrentWeather: ResponseObjectSerializable {
  let temp: Double
  let icon: UIImage
  let dailySummary: String
  
  init?(response: HTTPURLResponse, type: Any) {
    guard let data = type as? [String: AnyObject],
      let currently = data["currently"] as? [String: AnyObject],
      let temperature = currently["temperature"] as? Double,
      let icon = currently["icon"] as? String,
      let hourly = data["minutely"] as? [String: AnyObject],
      let summary = hourly["summary"] as? String
      else { return nil }
    self.temp = temperature
    self.icon = icon.weatherIcon()
    self.dailySummary = summary
  }
}

class Weather: UIViewController, CLLocationManagerDelegate {
  
  let locationManager = CLLocationManager()
  var currentLocation: Location!
  @IBOutlet weak var city: UILabel!
  @IBOutlet weak var temp: UILabel!
  @IBOutlet weak var summary: UILabel!
  @IBOutlet weak var icon: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last!
    currentLocation = Location(lat: "\(location.coordinate.latitude)", long: "\(location.coordinate.longitude)")
    
    let geoLocator = CLGeocoder()
    geoLocator.reverseGeocodeLocation(location) { (placemarks, _) in
      var placemark: CLPlacemark!
      placemark = placemarks?[0]
      
      if let city = placemark.addressDictionary?["City"] as? String {
        self.city.text = city.capitalized
      }
    }
    
    self.currentWeather(completion: { (response) in
      self.locationManager.stopUpdatingLocation()
      guard let response = response.result.value else { return }
      let temp = Int(response.temp)
      let summ = response.dailySummary
      let icon = response.icon
      self.temp.text = "\(temp)"
      self.summary.text = "\(summ)"
      self.icon.image = icon
    })
  }
  
  private func currentWeather(completion: @escaping (DataResponse<CurrentWeather>) -> Void) {
    Alamofire.request(Router.get(parameters: currentLocation, endpoint: .current)).responseObject { (response: DataResponse<CurrentWeather>) in
      completion(response)
    }
  }
}
