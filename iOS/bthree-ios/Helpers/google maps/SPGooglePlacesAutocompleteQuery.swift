//
//  SPGooglePlacesAutocompleteQuery.swift
//  AutoCompleteGoogle
//



import Foundation
import CoreLocation
import UIKit

//@objc
//protocol SPGooglePlacesAutocompleteQueryDelegate
//{
//   optional func googlePlaceReload(places:[SPGooglePlacesAutocompletePlace])//check
//   optional func googlePlaceGeocoded(latitude:Double, longitude:Double)
//   optional func googlePlaceReverseGeocode(address: String , country: String ,city: String)
//    optional func googlePlaceReverseGeocode(address: String)
//}

protocol SPGooglePlacesAutocompleteQueryDelegate
{
    func googlePlaceReload(_ places:[SPGooglePlacesAutocompletePlace])//check
    func googlePlaceGeocoded(_ latitude:Double, longitude:Double)
    func googlePlaceReverseGeocode(_ address: String , country: String ,city: String)
    func googlePlaceReverseGeocode(_ address: String)
}

class SPGooglePlacesAutocompleteQuery:NSObject,NSURLConnectionDelegate,CLLocationManagerDelegate {

    var input = ""
    var sensor = false
    var key = ""
    var offset = 0
    var location: CLLocationCoordinate2D?
    var radius = 0.0
    var language = ""
    var data: NSMutableData?
    var referenceToGeocoded = ""
    var connectionAutocomplete = NSURLConnection()
    var connectionGeocoded : NSURLConnection = NSURLConnection()
    var connectionReverseGeocode = NSURLConnection()
    var locationManager = CLLocationManager()
    var delegate: SPGooglePlacesAutocompleteQueryDelegate! = nil

    //save the name of the city from all the address

    var city:String = ""


    override init() {
        super.init()
        sensor=true

        //key="AIzaSyBgqeatOXG68SBPQNXzubwe0BDY-1yLXlI"//"AIzaSyAFsaDn7vyI8pS53zBgYRxu0HfRwYqH-9E"// define ???
        key="AIzaSyBGjEDOd6MtNtfTv76CzIp_WyMxzvj_KJg"//"AIzaSyB6Cx_qTAXcpQbxeSP5InlDch2W8Bum2tQ"//You should use the server api key instead of iOS api key
        //        key="AIzaSyDM-qQb04BOnWedEGKGz8Dbv3ZGea54LlI"//bundel webit.travelwayz-ios

        location=CLLocationCoordinate2DMake(-1, -1);
        radius = 50.0
        input = "jer"
        location=CLLocationCoordinate2DMake(31.922866, 35.047609)
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func getAdrressFromCoordinate (_ latitude: Double, longitude: Double){
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    self.displayLocationInfo(pm)
                } else {
                    print("Problem with the date recieved from geocoder")
                }
        })
    }

    func displayLocationInfo(_ placemark: CLPlacemark) {
        //        if placemark != nil {
        var tempString : String = ""
        var country = ""
        var city = ""

        if(placemark.locality != nil){
            tempString = tempString +  placemark.locality! + "\n"
            city = placemark.locality!
        }
        if(placemark.postalCode != nil){
            tempString = tempString +  placemark.postalCode! + "\n"
        }
        if(placemark.administrativeArea != nil){
            tempString = tempString +  placemark.administrativeArea! + "\n"
        }
        if(placemark.country != nil){
            tempString = tempString +  placemark.country! + "\n"
            country = placemark.country!
        }
        print("Adrress = " + tempString)
        delegate.googlePlaceReverseGeocode(tempString, country: country, city: city)
        //        delegate.googlePlaceReverseGeocode!(tempString, country: country, city: city)//check
    }

    func googleURLString() ->String{


        //        error:
        //           "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%D7%9C&sensor=true&key=AIzaSyBGjEDOd6MtNtfTv76CzIp_WyMxzvj_KJg&location=31.922866,35.047609&radius=50.000000"
        //
        //        seccsess:
        //
        //        https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%D7%97&types=geocode&language=en&key=AIzaSyBGjEDOd6MtNtfTv76CzIp_WyMxzvj_KJg
        //

        // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location

        var url:String = ""
        if Global.sharedInstance.isAddressCity == false
        {
            url = NSString(format:"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=en&key=%@", //input.addingPercentEscapes(using: String.Encoding.utf8)!,key) as String
                input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )!, key) as String
        }
        else
        {
            //url for cities names only
            url = NSString(format:"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&language=en&key=%@", //input.addingPercentEscapes(using: String.Encoding.utf8)!,key) as String
                input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )!, key) as String
        }


        // url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=ל&types=geocode&language=en&key=AIzaSyBGjEDOd6MtNtfTv76CzIp_WyMxzvj_KJg"
        //        if offset>0 {
        //            url += NSString(format:"&offset=%u", offset) as String}
        //        if location?.latitude != -1 {
        //            url += NSString(format:"&location=%f,%f", location!.latitude, location!.longitude) as String}
        //        if radius>0 {
        //            url += NSString(format: "&radius=%f", radius) as String}
        //        if !language.isEmpty {
        //            url += NSString(format:"&language=%@", language) as String}
        return url
    }

    func googleGeocoded(referenceToGeocoded reference:String){
        referenceToGeocoded=reference
      //  "https://maps.googleapis.com/maps/api/place/details/json?reference=%@key=%@"
        let urlBasic = NSString(format:"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&key=%@", //referenceToGeocoded.addingPercentEscapes(using: String.Encoding.utf8)!,key) as String
            referenceToGeocoded.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )!, key) as String
        let urlPath: String = urlBasic
        let url: URL = URL(string: urlPath)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("GooglePlaces Error: \(error.localizedDescription)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("GooglePlaces Error: No response from API")
                return
            }

            guard response.statusCode == 200 else {
                print("GooglePlaces Error: Invalid status code \(response.statusCode) from API")
                return
            }

            let object: NSDictionary?
            do {
                object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            } catch {
                object = nil
                print("GooglePlaces Error")
                return
            }

            guard object?["status"] as? String == "OK" else {
                print("GooglePlaces API Error: \(object?["status"] ?? "")")
                return
            }

            guard let json = object else {
                print("GooglePlaces Parse Error")
                return
            }

            // Perform table updates on UI thread
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let result = (json as AnyObject).object(forKey: "result") as? Dictionary<String, AnyObject> {
                    if let geometry = result["geometry"] as? Dictionary<String, AnyObject> {
                        if let location = geometry["location"] as? Dictionary<String, Double> {
                            if let lat = location["lat"]{
                                if let lng = location["lng"]{
                                    self.delegate.googlePlaceGeocoded( lat , longitude: lng)
                                }
                            }
                        }
                    }
                }
            }
        })
        task.resume()
    }

    func fetchPlaces(){
        data = NSMutableData()  // Declare Globally
        let urlPath: String = googleURLString()
        let url: URL = URL(string: urlPath)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("GooglePlaces Error: \(error.localizedDescription)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("GooglePlaces Error: No response from API")
                return
            }

            guard response.statusCode == 200 else {
                print("GooglePlaces Error: Invalid status code \(response.statusCode) from API")
                return
            }

            let object: NSDictionary?
            do {
                object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            } catch {
                object = nil
                print("GooglePlaces Error")
                return
            }

            guard object?["status"] as? String == "OK" else {
                print("GooglePlaces API Error: \(object?["status"] ?? "")")
                return
            }

            guard let json = object else {
                print("GooglePlaces Parse Error")
                return
            }

            // Perform table updates on UI thread
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //  self.locationsArray = Array<String>()
                if let _:NSString = (json as AnyObject).object(forKey: "status") as? NSString {
                    let status = (json as AnyObject).object(forKey: "status") as! NSString
                    if status.isEqual(to: "OK")
                    {
                        if let _ = (json as AnyObject).object(forKey: "predictions") as? [Dictionary<String, AnyObject>] {

                            let myar = (json as AnyObject).object(forKey: "predictions") as! [Dictionary<String, AnyObject>]
                            self.succeedWithPlaces(myar)

                            //                            for a in myar {
                            //                                if let _:Dictionary<String, AnyObject> = a as Dictionary<String, AnyObject>? {
                            //                                    let place = SPGooglePlacesAutocompletePlace()
                            //                                    if let name = a["description"] as AnyObject? as? String {
                            //                                        place.name=name
                            //                                        if let reference = a["reference"] as AnyObject? as? String {
                            //                                            place.reference = reference
                            //                                            if let identifier = a["id"] as AnyObject? as? String {
                            //                                                place.identifier = identifier
                            //                                                if let placeId = a["place_id"] as AnyObject? as? String {
                            //                                                    place.placeId = placeId
                            //                                                }
                            //                                            }
                            //                                        }
                            //                                    }
                            //                                    print(place.placeId)
                            //                                    print(place.name)
                            //                                 //   self.locationsArray.append(place.name)
                            //                                }
                            //                            }
                        }
                    }
                }
                //   print("txtfield count: \(self.searchTxt.text?.count)")
                //   self.locationsTable.reloadData()
                //   print("all results \(json)")
            }
        })
        task.resume()

    }

    func googleReverseGeocode(_ latitude:Double, longitude:Double){
        data = NSMutableData()  // Declare Globally
        let urlPath: String = "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&sensor=true"
        let url: URL = URL(string: urlPath)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("GooglePlaces Error: \(error.localizedDescription)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("GooglePlaces Error: No response from API")
                return
            }

            guard response.statusCode == 200 else {
                print("GooglePlaces Error: Invalid status code \(response.statusCode) from API")
                return
            }

            let object: NSDictionary?
            do {
                object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            } catch {
                object = nil
                print("GooglePlaces Error")
                return
            }

            guard object?["status"] as? String == "OK" else {
                print("GooglePlaces API Error: \(object?["status"] ?? "")")
                return
            }

            guard let json = object else {
                print("GooglePlaces Parse Error")
                return
            }

            // Perform table updates on UI thread
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let status = (json as AnyObject).object(forKey: "status") as! NSString
                if status.isEqual(to: "OK")
                {
                    let listResult =  (json as AnyObject).object(forKey: "results") as! NSArray
                    let address = (listResult[0] as AnyObject).object(forKey: "formatted_address") as! String
                    self.delegate.googlePlaceReverseGeocode(address)

                }
            }

        })
        task.resume()

    }

    func succeedWithPlaces(_ places: [Dictionary<String, AnyObject>]){

        var parsedPlaces:[SPGooglePlacesAutocompletePlace] = Array()

        for place: Dictionary<String, AnyObject> in places {

            let s = SPGooglePlacesAutocompletePlace.placeFromDictionary(place)
            parsedPlaces.append(s)
        }
        for aaaa in parsedPlaces {
            print("what \(aaaa.placeId) id \(aaaa.name)")
        }

        if delegate != nil
        {
            delegate.googlePlaceReload(parsedPlaces)
        }
    }

    //    func locationManager(_ manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    ////        var userLocation:CLLocation = newLocation
    ////        let long = userLocation.coordinate.longitude;
    ////        let lat = userLocation.coordinate.latitude;
    //        if newLocation != oldLocation {
    //            locationManager.stopUpdatingLocation()
    //        }
    //           }

    // MARK:NSURLConnectionDelegate

    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!){
        self.data?.append(data)
    }

    func connectionDidFinishLoading(_ connection: NSURLConnection!){
        //var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)

        do {
            if data?.description != "<>"{


                //remove ! from url and unwrap optional


                //try to deserialize. The return value is of type Any
                guard let jsonResult = try? JSONSerialization.jsonObject(with: data! as Data,options: JSONSerialization.ReadingOptions.mutableContainers) else {
                    Alert.sharedInstance.showAlertDelegate("BAD_NETWORK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return
                }


                // let jsonResult = try NSJSONSerialization.JSONObjectWithData data)
                //  let jsonResult: AnyObject = (try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers))
                //                if jsonResult is NSDictionary {
                //                    var myDict: NSDictionary = jsonResult as! NSDictionary
                //                      print("myDict:\(myDict)")
                //                }
                //                else if jsonResult is NSArray {
                //                    let myArray: NSArray = jsonResult as! NSArray
                //                      print("myArray:\(myArray)")
                //
                //                }

                if connection == connectionAutocomplete{
                    let status = (jsonResult as AnyObject).object(forKey: "status") as! NSString
                    //let json = jsonResult as? Dictionary<String, AnyObject>
                    if status.isEqual(to: "OK")
                    {
                        //var d: AnyObject? = jsonResult.objectForKey("predictions")
                        succeedWithPlaces((jsonResult as AnyObject).object(forKey: "predictions") as! [Dictionary<String, AnyObject>])
                    }
                    if status.isEqual(to: "INVALID_REQUEST")
                    {
                        //                var d: AnyObject? = jsonResult.objectForKey("predictions")
                        //       ®         succeedWithPlaces(jsonResult.objectForKey("predictions") as! [Dictionary<String, AnyObject>])
                    }

                    return
                }
                else if connection == connectionGeocoded{
                    if let result = (jsonResult as AnyObject).object(forKey: "result") as? Dictionary<String, AnyObject> {
                        if let geometry = result["geometry"] as? Dictionary<String, AnyObject> {
                            if let location = geometry["location"] as? Dictionary<String, Double> {
                                if let lat = location["lat"]{
                                    if let lng = location["lng"]{
                                        //                                delegate.googlePlaceGeocoded!( lat , longitude: lng)//check
                                        delegate.googlePlaceGeocoded( lat , longitude: lng)

                                    }
                                }
                            }
                        }
                    }
                    return
                }
                else if connection == connectionReverseGeocode{
                    let status = (jsonResult as AnyObject).object(forKey: "status") as! NSString
                    //let json = jsonResult as? Dictionary<String, AnyObject>
                    if status.isEqual(to: "OK")
                    {
                        let listResult =  (jsonResult as AnyObject).object(forKey: "results") as! NSArray
                        let address = (listResult[0] as AnyObject).object(forKey: "formatted_address") as! String
                        //\\print(address)
                        //                delegate.googlePlaceReverseGeocode!(address)//check
                        delegate.googlePlaceReverseGeocode(address)

                    }
                }
            }
        }
        catch (_) {
            //here you can get access to all of the errors that occurred when trying to serialize
        }
    }


    func connection(_ connection: NSURLConnection, didReceiveResponse response: URLResponse){
        data?.length=0
    }

    func connection(_ connection: NSURLConnection, didFailWithError error: Error){
        data=nil
    }
}
