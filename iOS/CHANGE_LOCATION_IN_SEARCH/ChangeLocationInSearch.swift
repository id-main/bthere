//
//  ChangeLocationInSearch.swift
//  Bthere
//
//  Created by Iustin Bthere on 3/22/19.
//  Copyright © 2019 Webit. All rights reserved.
//

import UIKit
class ChangeLocationInSearch: UIViewController,SPGooglePlacesAutocompleteQueryDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var searchTxt: SuggestiveTextField!
    @IBOutlet weak var closeBtn: UIButton!

    let googlePlacesAutocomplete = SPGooglePlacesAutocompleteQuery()
    var listAutocompletePlace:[SPGooglePlacesAutocompletePlace] = []
    @IBOutlet weak var locationsTable: UITableView!
    var locationsArray:Array<String> = Array<String>()
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var popUpView: UIView!
    var locationDelegate:didPickNewLocation!=nil
    var pickedLocationString:String = ""
    var currentLatitude:String = ""
    var currentLongitude:String = ""
    @IBOutlet weak var titleTxt: UILabel!




    override func viewDidLoad() {
        super.viewDidLoad()

        googlePlacesAutocomplete.delegate = self
        locationsTable.register(UINib(nibName: "ChangeLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeLocationCell")
        locationsTable.separatorStyle = .none
        titleTxt.text = "CHANGE_LOCATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        locationsTable.rowHeight = UITableView.automaticDimension
        locationsTable.estimatedRowHeight = 60

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {

        tableView.estimatedRowHeight = 60
        return UITableView.automaticDimension

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.searchTxt.becomeFirstResponder()

    }


    func googlePlaceReload(_ places: [SPGooglePlacesAutocompletePlace])
    {
        googlePlacesAutocomplete.googleGeocoded(referenceToGeocoded:places[0].reference)
        locationsArray = Array<String>()
        for loc:SPGooglePlacesAutocompletePlace in places

        {
            print(loc.placeId)
            print(loc.name)
            locationsArray.append(loc.name)
        }
        print("txtfield count: \(searchTxt.text?.count)")
        locationsTable.reloadData()


        //        if locationsTable.contentSize.height < popUpView.frame.size.height
        //        {
        //            tableHeight.constant = locationsTable.contentSize.height
        //        }
    }

    func googlePlaceGeocoded(_ latitude: Double, longitude: Double)
    {
        currentLatitude = String(latitude)
        currentLongitude = String(longitude)
        print("latitude: \(latitude)")
        print("longitude: \(longitude)")

    }

    func googlePlaceReverseGeocode(_ address: String, country: String, city: String) {

    }

    func googlePlaceReverseGeocode(_ address: String) {


        //            self.searchTxt.text = ""

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return locationsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell: ChangeLocationTableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeLocationCell") else {
                return ChangeLocationTableViewCell(style: .default, reuseIdentifier: "ChangeLocationCell")
            }
            return cell as! ChangeLocationTableViewCell
        }()

        cell.selectionStyle = .none

        cell.locationName.text = locationsArray[indexPath.row]
        return cell


        //        cell.contentView.frame = CGRect(x: 0, y: 0, width: serviceView.frame.width, height: 20)

    }

    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //
    //        return 60
    //    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        pickedLocationString = locationsArray[indexPath.row]
        self.changeLocation()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == searchTxt {
            //            Global.sharedInstance.isAddressCity = true
            googlePlacesAutocomplete.input = textField.text! + string
            //            print("google input city \(googlePlacesAutocomplete.input) ")

            if Reachability.isConnectedToNetwork() == false
            {
                //   Alert.sharedInstance.showAlert(NSLocalizedString("NO_INTERNET", comment: ""), vc: self)
            } else {
                googlePlacesAutocomplete.fetchPlaces()
            }

        }

        //        var startString = ""
        //        if (textField.text != nil)
        //        {
        //            startString += textField.text!
        //        }
        //        startString += string


        return true
    }

    func changeLocation()
    {
        self.dismiss(animated: true, completion:
            {
                //                self.locationDelegate.showNewLocation(newLocation: self.pickedLocationString)
                self.locationDelegate.showNewLocation(newLocation: self.pickedLocationString, lat: self.currentLatitude, long: self.currentLongitude)
        })
    }

    @IBAction func closeAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion:
            {
                //                self.locationDelegate.showNewLocation(newLocation: self.pickedLocationString)
                self.locationDelegate.showNewLocation(newLocation: "", lat: "", long: "")
        })
    }
}
