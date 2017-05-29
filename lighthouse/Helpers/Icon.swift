//
//  Icon.swift
//  lighthouse
//
//  Created by Martin on 5/29/17.
//  Copyright © 2017 builtby. All rights reserved.
//

import Foundation
import UIKit

enum WeatherIcon {
  case ClearDay
  case ClearNight
  case Rain
  case Snow
  case Cloudy
  case CloudyNight
  case CloudySun
  case Storm
  
  func image() -> UIImage {
    switch self {
    case .ClearDay:
      return #imageLiteral(resourceName: "Sunny")
    case .ClearNight:
      return #imageLiteral(resourceName: "Clear night")
    case .Rain:
      return #imageLiteral(resourceName: "Rain")
    case .Snow:
      return #imageLiteral(resourceName: "Snow")
    case .Cloudy:
      return #imageLiteral(resourceName: "Cloudy")
    case .CloudySun:
      return #imageLiteral(resourceName: "Cloud + Sun")
    case .CloudyNight:
      return #imageLiteral(resourceName: "Cloudy night")
    case .Storm:
      return #imageLiteral(resourceName: "Storm")
    }
  }
}

extension String {
  func weatherIcon() -> UIImage {
    switch self {
    case "clear-day":
      return WeatherIcon.ClearDay.image()
    case "clear-night":
      return WeatherIcon.ClearNight.image()
    case "rain":
      return WeatherIcon.Rain.image()
    case "snow":
      return WeatherIcon.Snow.image()
    case "cloudy":
      return WeatherIcon.Cloudy.image()
    case "partly-cloudy-day":
      return WeatherIcon.CloudySun.image()
    case "partly-cloudy-night":
      return WeatherIcon.CloudyNight.image()
    default:
      return WeatherIcon.ClearDay.image()
    }
  }
}

//sleet, wind, fog
