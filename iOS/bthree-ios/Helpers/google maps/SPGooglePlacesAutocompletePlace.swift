//
//  SPGooglePlacesAutocompletePlace.swift
//  AutoCompleteGoogle
//

import Foundation


class SPGooglePlacesAutocompletePlace {
    
    var name = ""
    var reference = ""
    var identifier = ""
    var placeId = ""
    
    
    init(){}
    
    class func placeFromDictionary(_ placeDictionary: Dictionary<String, AnyObject>) -> (SPGooglePlacesAutocompletePlace)
    {
        let place = SPGooglePlacesAutocompletePlace()
        
         if let name = placeDictionary["description"] as AnyObject? as? String {
            place.name=name
            if let reference = placeDictionary["reference"] as AnyObject? as? String {
                place.reference = reference
                if let identifier = placeDictionary["id"] as AnyObject? as? String {
                    place.identifier = identifier
                    if let placeId = placeDictionary["place_id"] as AnyObject? as? String {
                        place.placeId = placeId
                    }
                }
            }
        }
        return place
    }
}
