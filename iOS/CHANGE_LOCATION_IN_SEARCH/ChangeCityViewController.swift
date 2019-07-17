//
//  ChangeCityViewController.swift
//  Bthere
//
//  Created by User on 11.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import CoreLocation

//דף שנה מיקום- מתוצאות חיפוש
class ChangeCityViewController: UIViewController,UITextFieldDelegate, SPGooglePlacesAutocompleteQueryDelegate,UIGestureRecognizerDelegate {
    
    var delegate:ReloadResultsDelegate!=nil
    var generic:Generic = Generic()
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var txtSearch: SuggestiveTextField!
    
    @IBOutlet weak var tblSearch: UITableView!
    
    @IBOutlet weak var lblChangeLocation: UILabel!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBAction func btnSearch(_ sender: AnyObject) {
        Global.sharedInstance.dicSearchProviders["nvCity"] = txtSearch.text as AnyObject
        Global.sharedInstance.dicSearchProviders["nvlong"] = nil
        Global.sharedInstance.dicSearchProviders["nvlat"] = nil
        
        if Global.sharedInstance.whichSearchTag == 1
        {
            self.generic.showNativeActivityIndicator(self)
            
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                api.sharedInstance.SearchByKeyWord(Global.sharedInstance.dicSearchProviders,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in        //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                Global.sharedInstance.dicResults = []
                                self.delegate.ReloadResultsDelegate()
                                self.dismiss(animated: false, completion: nil)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                self.delegate.ReloadResultsDelegate()
                                self.dismiss(animated: false, completion: nil)
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
            }
        }
        else if Global.sharedInstance.whichSearchTag == 2
        {
            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                api.sharedInstance.SearchProviders(Global.sharedInstance.dicSearchProviders, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in        //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                Global.sharedInstance.dicResults = []
                                self.delegate.ReloadResultsDelegate()
                                self.dismiss(animated: false, completion: nil)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                self.delegate.ReloadResultsDelegate()
                                self.dismiss(animated: false, completion: nil)
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
            }
        }
    }
    
    let googlePlacesAutocomplete = SPGooglePlacesAutocompleteQuery()
    var listAutocompletePlace:[SPGooglePlacesAutocompletePlace] = []
    var coordinatePackage:CLLocationCoordinate2D!
    var isSearch = false
    var adressResult:[String] = []//מכיל את הכתובות להשלמה
    var searchResults: [String]!
    
    //MARK: initial
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblChangeLocation.text = "CHANGE_LOCATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        txtSearch.placeholder = "CHANGE_LOCATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        googlePlacesAutocomplete.delegate = self
        txtSearch.delegate = self
        self.searchResults = Array()
        tblSearch.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillLayoutSubviews() {
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        let height = bounds.size.height
        self.view.superview!.bounds = CGRect(x:0,y:-40,width:width,height: height)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- tableView
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adressResult.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as!SearchTableViewCell
        
        cell.lblSubject.text = self.adressResult[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAtIndexPath indexPath: IndexPath){
        
        txtSearch.text = (tableView.cellForRow(at: indexPath) as! SearchTableViewCell).lblSubject.text
        
        tableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView!, heightForRowAtIndexPath indexPath: IndexPath!) -> CGFloat {
        if self.adressResult.count > 4
        {
            return tableView.frame.size.height / CGFloat(self.adressResult.count)
        }
        return 55
    }
    
    
    //MARK: - textField
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField ==  txtSearch
        {
            Global.sharedInstance.isAddressCity = true
            googlePlacesAutocomplete.input = textField.text! + string
            googlePlacesAutocomplete.fetchPlaces()
        }
        return true
    }
    
    //-MARK: SPGooglePlacesAutocompleteQueryDelegate
    
    
    func googlePlaceReload(_ listPlaces:[SPGooglePlacesAutocompletePlace])
    {
        if isSearch{
            googlePlacesAutocomplete.googleGeocoded(referenceToGeocoded:listPlaces[0].reference)
            isSearch = false
        }
        else{
            var placesName:[String] = []
            var placesId:[String] = []
            
            for place in listPlaces{
                placesName += [place.name]
                placesId += [place.placeId]
            }
            
            //st
            
            adressResult = placesName
            
            listAutocompletePlace=listPlaces
            
            tblSearch.isHidden = false
            tblSearch.reloadData()
            
            //                txtSearch.setSuggestions(placesName)
            //                txtSearch.setSuggestionsPlacesId(placesId)
            //                txtSearch.matchStrings(txtSearch.text)
            //                txtSearch.showSuggestionTableView()
            
        }
    }
    
    func googlePlaceGeocoded(_ latitude:Double, longitude:Double)
    {
        
        txtSearch.text = ""
    }
    
    func googlePlaceReverseGeocode(_ address: String) {
        
        txtSearch.text = address
        
        
    }
    
    func googlePlaceReverseGeocode(_ address: String , country: String ,city: String)
    {
        
    }
    
    @objc func dismissKeyBoard()
    {
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: tblSearch)) {
            
            return false
        }
        return true
    }
    
    
}
