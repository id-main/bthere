//
//  GooglePlace.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class GooglePlace {
  
  let name: String
  let address: String
  let coordinate: CLLocationCoordinate2D
  let placeType: String
  var photoReference: String?
  var photo: UIImage?
  
  init(dictionary:NSDictionary, acceptedTypes: [String])
  {
    var lat:CLLocationDegrees = CLLocationDegrees()
    var lng:CLLocationDegrees = CLLocationDegrees()
    name = dictionary["name"] as! String
    address = dictionary["vicinity"] as! String
    if let  _ = dictionary["geometry"] as? NSDictionary {
        let onedic = dictionary["geometry"] as! NSDictionary
        if let _ = onedic["location"] as? NSDictionary {
            let possiblelocation = onedic[""] as! NSDictionary
             lat = possiblelocation["lat"] as! CLLocationDegrees
             lng = possiblelocation["lng"] as! CLLocationDegrees
            
        }
    }
    coordinate = CLLocationCoordinate2DMake(lat, lng)
    if let photos = dictionary["photos"] as? NSArray {
        let photo = photos.firstObject as! NSDictionary
        photoReference = photo["photo_reference"] as? String
    }
    
    var foundType = "restaurant"
    let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    for type in dictionary["types"] as! [String] {
        if possibleTypes.contains(type) {
            foundType = type
            break
        }
    }
    placeType = foundType
    }
}
