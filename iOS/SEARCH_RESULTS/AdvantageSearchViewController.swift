//
//  AdvantageSearchViewController.swift
//  bthree-ios
//
//  Created by User on 22.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import CoreLocation
//דף חיפוש מתקדם
class AdvantageSearchViewController: UIViewController,UITextFieldDelegate,dismissViewControllerDelegate,UIGestureRecognizerDelegate,SPGooglePlacesAutocompleteQueryDelegate,openFromMenuDelegate {
    
    var delegate:dismissViewControllerDelegate!=nil
    var delegateSearch:openSearchResultsDelegate!=nil
    var isSubjectFlag = false
    var filterSubArr:Array<Domain> = []
    var filterAreaArr:Array<String> = []
    //to cut the address and show only city
    var cityArr:Array<String> = []
    var isValidSearch:Bool = false
    
    let googlePlacesAutocomplete = SPGooglePlacesAutocompleteQuery()
    var listAutocompletePlace:[SPGooglePlacesAutocompletePlace] = []
    var coordinatePackage:CLLocationCoordinate2D!
    var isSearch = false
    
    var generic:Generic = Generic()
    var searchResults: [String]!
    //var searchResultController:SearchResultsController!
    var resultsArray = [String]()

    
    var chosenDomain:Int = 0
    var chosenDate:Date?
    var chosenFromHour:String = ""
    var chosenToHour:String = ""
    var chosenCity:String = ""
    var dateToServer = ""
    
    var hhFromHour:Float = 0.0
    var mmFromHour:Float = 0.0
    var hhToHour:Float = 0.0
    var mmToHour:Float = 0.0
    var isSelectedSubject:Bool = false
    
    @IBOutlet weak var vSubjects1: UIView!
    
    @IBOutlet weak var lblSubject: UILabel!
    
    @IBOutlet weak var vDates1: UIView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var vArea1: UIView!
    
    @IBOutlet weak var lblArea: UILabel!
    
    @IBOutlet weak var imgPlusMenu: UIImageView!
    @IBOutlet weak var vHours1: UIView!
    
    @IBOutlet weak var lblHour: UILabel!
    
    var dicSearchProvider:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()//עבור השליחה לשרת
    
    @IBAction func btnSearch(_ sender: AnyObject) {
        
        Global.sharedInstance.searchDomain = txtfSubject.text!
        Global.sharedInstance.viewConNoInternet = self
        txtCity.dismissSuggestionTableView()
        if hhFromHour > hhToHour
        {
            Alert.sharedInstance.showAlert("ILLEGAL_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
        else
        {
            if txtCity.text != ""
            {
                lblArea.text = txtCity.text
                chosenCity = txtCity.text!
            }
            else
            {
                chosenCity = ""
            }
            dicSearchProvider["iSupplierFieldType"] = chosenDomain as AnyObject
            if chosenCity == ""
            {
                dicSearchProvider["nvCity"] = nil
            }
            else
            {
                dicSearchProvider["nvCity"] = chosenCity as AnyObject
                isValidSearch = true
            }
            
            if dateToServer == ""
            {
                dicSearchProvider["dtDateDesirable"] = nil
                
            }
            else
            {
                dicSearchProvider["dtDateDesirable"] = dateToServer as AnyObject
                isValidSearch = true
            }
            if chosenFromHour == ""
            {
                dicSearchProvider["tFromHour"] = nil
            }
            else
            {
                dicSearchProvider["tFromHour"] = chosenFromHour as AnyObject
                isValidSearch = true
            }
            if chosenToHour == ""
            {
                dicSearchProvider["tToHour"] = nil
            }
            else
            {
                dicSearchProvider["tToHour"] = chosenToHour as AnyObject
                isValidSearch = true
            }
            
            dicSearchProvider["nvlong"] = Global.sharedInstance.currentLong?.description as AnyObject
            dicSearchProvider["nvlat"] = Global.sharedInstance.currentLat?.description as AnyObject
            
            if dicSearchProvider["nvLong"] != nil || dicSearchProvider["nvlat"] != nil || Int((dicSearchProvider["iSupplierFieldType"]?.description)!) != 0
            {
                isValidSearch = true
            }
            
            if isValidSearch == false
            {
                Alert.sharedInstance.showAlert("NOT_DATA_TO_SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            }
            else
            {
                self.generic.showNativeActivityIndicator(self)
                
                
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)
//                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                }
                else
                {
                    api.sharedInstance.SearchProviders(dicSearchProvider,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in       //  Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                                {
                                    Alert.sharedInstance.showAlert("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                                }
                                else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                {
                                    Global.sharedInstance.dicResults = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                    self.dismiss(animated: false, completion: {
                                    Global.sharedInstance.dicSearchProviders = self.dicSearchProvider
                                    Global.sharedInstance.whichSearchTag = 2
                                    self.delegateSearch.openSearchResults()
                                    })
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
//                        Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
                    })
                }
            }
        }
    }
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var bSubject: UIButton!
    
    @IBOutlet weak var lblAdvertising: UILabel!
    @IBAction func bSubject(_ sender: AnyObject) {
        
        
        if !isSelectedSubject
        {
            if txtCity.text != ""
            {
                lblArea.text = txtCity.text
                chosenCity = txtCity.text!
            }
            else
            {
                chosenCity = ""
            }
            
            txtfSubject.placeholder = "SUBJECT_PLACE_HOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            dismissKeyboard()
            txtCity.isHidden = true
            tblCities.isHidden = true
            filterSubArr = []
            filterAreaArr = []
            tblSubject.reloadData()
            //txtCity.text = ""
            //txtfSubject.text = ""
            isSubjectFlag = true
            tblSubject.isHidden = false
            txtfSubject.isHidden = false
            txtfSubject.becomeFirstResponder()
            dates.isHidden = true
            hour1.isHidden = true
            hours2.isHidden = true
            lineView.isHidden  = true
            
            openArrow(bSubject, btn: btnSubject)
            closeArrow(btnArea, btn2: btnDate, btn3: btnHour)
            changeFontStyle(bArea, btn2: bDate, btn3: bHours)
            vSubjects1.isHidden = true
            vArea1.isHidden = true
            vHours1.isHidden = true
            vDates1.isHidden = true
        }
        else
        {
            // hideViews(vSubjects1)
        }
        
        
        openSubject()
        
    }
    
    //func close
    @IBOutlet weak var btnSubject: UIButton!
    @IBAction func btnSubject(_ sender: AnyObject) {
        openSubject()
        
    }
    
    @IBOutlet weak var bArea: UIButton!
    @IBAction func bArea(_ sender: AnyObject) {
        dismissKeyboard()
        txtCity.isHidden = false
        txtCity.becomeFirstResponder()
        txtfSubject.isHidden = true
        txtCity.placeholder = "AREA_PLACE_HOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        filterAreaArr = []
        filterSubArr = []
        tblSubject.reloadData()
        tblCities.reloadData()
        //txtCity.text = ""
        isSubjectFlag = false
        tblSubject.isHidden = true
        tblCities.isHidden = false
        dates.isHidden = true
        hour1.isHidden = true
        hours2.isHidden = true
        lineView.isHidden  = true
        
        openArrow(bArea, btn: btnArea)
        closeArrow(btnSubject, btn2: btnDate, btn3: btnHour)
        changeFontStyle(bSubject, btn2: bDate, btn3: bHours)
        //  hideViews(vArea1)
        vSubjects1.isHidden = false
        vArea1.isHidden = true
        vHours1.isHidden = true
        vDates1.isHidden = true
    }
    
    @IBOutlet weak var btnArea: UIButton!
    @IBAction func btnArea(_ sender: AnyObject) {
        
        openArea()
    }
    
    @IBOutlet weak var bDate: UIButton!
    @IBAction func bDate(_ sender: AnyObject) {
        dismissKeyboard()
        if txtCity.text != ""
        {
            lblArea.text = txtCity.text
            chosenCity = txtCity.text!
        }
        else
        {
            chosenCity = ""
        }
        //txtfSubject.text = ""
        txtfSubject.isHidden = true
        //txtCity.text = ""
        txtCity.isHidden = true
        tblSubject.isHidden = true
        tblCities.isHidden = true
        dates.isHidden = false
        hour1.isHidden = true
        hours2.isHidden = true
        lineView.isHidden  = true
        
        openArrow(bDate, btn: btnDate)
        closeArrow(btnArea, btn2: btnSubject, btn3: btnHour)
        changeFontStyle(bArea, btn2: bSubject, btn3: bHours)
        vSubjects1.isHidden = false
        vArea1.isHidden = false
        vHours1.isHidden = true
        vDates1.isHidden = true
    }
    
    @IBOutlet weak var btnDate: UIButton!
    @IBAction func btnDate(_ sender: AnyObject) {
        openDate()
    }
    
    @IBOutlet weak var bHours: UIButton!
    @IBAction func bHours(_ sender: AnyObject) {
        dismissKeyboard()
        if txtCity.text != ""
        {
            lblArea.text = txtCity.text
            chosenCity = txtCity.text!
        }
        else
        {
            chosenCity = ""
        }
        //txtfSubject.text = ""
        txtfSubject.isHidden = true
        //txtCity.text = ""
        txtCity.isHidden = true
        tblSubject.isHidden = true
        tblCities.isHidden = true
        dates.isHidden = true
        hour1.isHidden = false
        hours2.isHidden = false
        lineView.isHidden  = false
        
        openArrow(bHours, btn: btnHour)
        closeArrow(btnArea, btn2: btnDate, btn3: btnSubject)
        changeFontStyle(bArea, btn2: bDate, btn3: bSubject)
        vSubjects1.isHidden = false
        vArea1.isHidden = false
        vHours1.isHidden = true
        vDates1.isHidden = false
    }
    
    @IBOutlet weak var btnHour: UIButton!
    @IBAction func btnHour(_ sender: AnyObject) {
        openHour()
    }
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var hour1: UIDatePicker!
    @IBOutlet weak var hours2: UIDatePicker!
    @IBOutlet weak var dates: UIDatePicker!
    @IBOutlet weak var tblSubject: UITableView!
    @IBOutlet weak var tblCities: UITableView!
    @IBOutlet weak var txtfSubject: UITextField!
    @IBOutlet weak var txtCity: SuggestiveTextField!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewSubject: UIView!
    @IBOutlet weak var viewArea: UIView!
    @IBOutlet var imgView: UIView!
    @IBOutlet weak var rangeHoursView: UIView!
    @IBOutlet weak var dateChooseView: UIView!
    
    @IBAction func clsBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            bHours.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            bSubject.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            bArea.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            bDate.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            
        }
        else
        {
            bHours.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            bSubject.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            bArea.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            bDate.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        }
        
        lblAdvertising.text = "ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        // if Global.sharedInstance.rtl
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            
            imgPlusMenu.image = UIImage(named: "plus.png")
        }
        else
        {
            imgPlusMenu.image = UIImage(named: "plusEnglish.png")
        }
        
        isValidSearch = false
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AdvantageSearchViewController.imageTapped))
        imgPlusMenu.isUserInteractionEnabled = true
        imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
        googlePlacesAutocomplete.delegate = self
        
        bSubject.setTitle("SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        bArea.setTitle("AREA".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        bDate.setTitle("DESIRED_DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        bHours.setTitle("RANGE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnSearch.setTitle("SEARCH".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        //  self.imgView.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
        txtfSubject.isHidden = true
        txtCity.isHidden = true
        tblSubject.isHidden = true
        tblCities.isHidden = true
        dates.isHidden = true
        hour1.isHidden = true
        hours2.isHidden = true
        lineView.isHidden = true
        
        lblSubject.text = ""
        lblArea.text = ""
        lblDate.text = ""
        lblHour.text = ""
        
        hour1.layer.borderWidth = 1
        hours2.layer.borderWidth = 1
        dates.layer.borderWidth = 1
        lineView.layer.borderWidth = 1
        
        hour1.layer.borderColor = UIColor.black.cgColor
        hours2.layer.borderColor = UIColor.black.cgColor
        dates.layer.borderColor = UIColor.black.cgColor
        lineView.layer.borderColor = UIColor.black.cgColor
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AdvantageSearchViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let tapSubject:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(AdvantageSearchViewController.openSubject))
        vSubjects1.addGestureRecognizer(tapSubject)
        let tapArea:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(AdvantageSearchViewController.openArea))
        vArea1.addGestureRecognizer(tapArea)
        let tapDate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(AdvantageSearchViewController.openDate))
        vDates1.addGestureRecognizer(tapDate)
        let tapHour:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(AdvantageSearchViewController.openHour))
        vHours1.addGestureRecognizer(tapHour)
        
        txtfSubject.delegate = self
        txtCity.delegate = self
        
        self.tblSubject.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tblCities.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        txtfSubject.borderStyle = .none
        txtCity.borderStyle = .none
        
        dates.addTarget(self, action: #selector(AdvantageSearchViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hour1.addTarget(self, action: #selector(AdvantageSearchViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        hours2.addTarget(self, action: #selector(AdvantageSearchViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        dates.minimumDate = Date()
        
        tblSubject.layer.borderWidth = 1
        tblSubject.backgroundColor = UIColor.clear
        
        tblCities.layer.borderWidth = 1
        tblCities.backgroundColor = UIColor.clear
        
        let dateFormatterHours = DateFormatter()
        dateFormatterHours.dateFormat = "HH:mm"
        hour1.date = dateFormatterHours.date(from: "00:00")!
        hours2.date = dateFormatterHours.date(from: "00:00")!
        
        
        self.searchResults = Array()
        self.tblSubject.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.tblCities.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    override func viewWillLayoutSubviews() {
        
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        let height = bounds.size.height
        self.view.superview!.bounds = CGRect(x:0,y:-52,width:width,height: height)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            bHours.titleLabel!.textAlignment = .right
            bSubject.titleLabel!.textAlignment = .right
            bArea.titleLabel!.textAlignment = .right
            bDate.titleLabel!.textAlignment = .right
            
        }
        else
        {
            bHours.titleLabel!.textAlignment = .left
            bSubject.titleLabel!.textAlignment = .left
            bArea.titleLabel!.textAlignment = .left
            bDate.titleLabel!.textAlignment = .left
        }
        
        isValidSearch = false
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viewHeader)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: viewSubject)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: viewArea)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: dateChooseView)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: rangeHoursView)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: vSubjects1)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: vArea1)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: vDates1)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color6, width: 2, any: vHours1)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSubjectFlag == true
        {
            return filterSubArr.count // your number of cell here
        }
        else
        {
            
            return self.searchResults.count
            
            //return filterAreaArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "subjects")as!SubjectsTableViewCell
        
        gradientLine(cell, width: cell.layer.frame.width, height: cell.layer.frame.height)
        
        if isSubjectFlag == true
        {
            cell.setDisplayData(filterSubArr[indexPath.row].nvCategoryName)
        }
        else
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            cell1.textLabel?.text = self.searchResults[indexPath.row]
            return cell1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if isSubjectFlag == true
        {
            lblSubject.text = filterSubArr[indexPath.row].nvCategoryName
            txtfSubject.text = filterSubArr[indexPath.row].nvCategoryName
            chosenDomain = filterSubArr[indexPath.row].iCategoryRowId
        }
        else
        {
            
            // 1
            //self.dismissViewControllerAnimated(true, completion: nil)
            tableView.isHidden = true
            // 2
            let correctedAddress:String! = self.searchResults[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.symbols)
            let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false")
            
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                // 3
                do {
                    if data != nil{
                        //                       let dic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as!  NSDictionary
                        //
                        //                        let lat = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat")?.objectAtIndex(0) as! Double
                        //                        let lon = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng")?.objectAtIndex(0) as! Double
                        // 4
                        //self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row] )
                    }
                }catch {
                    print("Error")
                }
            })
            // 5
            task.resume()
            
        }
    }
    
    func tableView(_ tableView: UITableView!, heightForRowAtIndexPath indexPath: IndexPath!) -> CGFloat {
        return txtfSubject.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //MARK: - keyboard
    
    ///dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        txtCity.dismissSuggestionTableView()
        self.view.endEditing(true)
        if txtCity.text != ""
        {
            lblArea.text = txtCity.text
            chosenCity = txtCity.text!
        }
        else
        {
            chosenCity = ""
        }
        txtCity.isHidden = true
        tblCities.isHidden = true
        filterSubArr = []
        filterAreaArr = []
        tblSubject.reloadData()
        //txtCity.text = ""
        //txtfSubject.text = ""
        tblSubject.isHidden = true
        txtfSubject.isHidden = true
        dates.isHidden = true
        hour1.isHidden = true
        hours2.isHidden = true
        lineView.isHidden  = true
        closeAllArrow()
        changeAllFontStyle()
        vSubjects1.isHidden = false
        vArea1.isHidden = false
        vHours1.isHidden = false
        vDates1.isHidden = false
        
    }
    
    //MARK: - textField
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtfSubject
        {
            //בדיקה שלא הכניס ספרות
            let badCharacters = CharacterSet.decimalDigits.inverted
            if txtfSubject.text!.rangeOfCharacter(from: badCharacters) == nil && txtfSubject.text != "" {
                txtfSubject.text = ""
                lblSubject.text = ""
                Alert.sharedInstance.showAlert("ILLEGAL_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            }
        }
    }
    
    
    //for autoCopmlete:
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        if isSubjectFlag == true
        {
            filterSubArr = []
            
            for subject in AppDelegate.arrDomainFilter
            {
                let myString:NSString! = subject.nvCategoryName as NSString
                
                let substringRange :NSRange! = myString.range(of: substring)
                
                if (substringRange.location == 0)
                {
                    filterSubArr.append(subject/*.nvCategoryName*/)
                }
            }
        }
        else
        {
        }
        tblSubject.reloadData()
    }
    
    ////for the autoComplete
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCity
        {
            Global.sharedInstance.isAddressCity = true
            googlePlacesAutocomplete.input = textField.text! + string
            googlePlacesAutocomplete.fetchPlaces()
        }
        else //txtfSubject
        {
            //בשביל ה-autoComplete
            let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            searchAutocompleteEntriesWithSubstring(substring)
            
            if string == "" && txtfSubject.text?.count == 1
            {
                txtfSubject.text = ""
                lblSubject.text = ""
            }
        }
        
        
        return true
    }
    
    //MARK: - on click buttons
    func closeArrow(_ btn1:UIButton,btn2:UIButton,btn3:UIButton)
    {
        
        btn1.setTitleColor(UIColor.black, for: UIControl.State())
        btn2.setTitleColor(UIColor.black, for: UIControl.State())
        btn3.setTitleColor(UIColor.black, for: UIControl.State())
    }
    
    func closeAllArrow()
    {
        
        
        btnSubject.setTitleColor(UIColor.black, for: UIControl.State())
        btnArea.setTitleColor(UIColor.black, for: UIControl.State())
        btnDate.setTitleColor(UIColor.black, for: UIControl.State())
        btnHour.setTitleColor(UIColor.black, for: UIControl.State())
    }
    
    func changeAllFontStyle()
    {
        bSubject.setTitleColor(UIColor.black, for: UIControl.State())
        bArea.setTitleColor(UIColor.black, for: UIControl.State())
        bDate.setTitleColor(UIColor.black, for: UIControl.State())
        bHours.setTitleColor(UIColor.black, for: UIControl.State())
        
        bSubject.titleLabel!.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
        bArea.titleLabel!.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
        bDate.titleLabel!.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
        bHours.titleLabel!.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
    }
    
    
    func changeFontStyle(_ btn1:UIButton,btn2:UIButton,btn3:UIButton)
    {
        btn1.setTitleColor(UIColor.black, for: UIControl.State())
        btn2.setTitleColor(UIColor.black, for: UIControl.State())
        btn3.setTitleColor(UIColor.black, for: UIControl.State())
        
        btn1.titleLabel!.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
        btn2.titleLabel!.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
        btn3.titleLabel!.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
    }
    
    func openArrow(_ btnText:UIButton,btn:UIButton)
    {
        
        btn.setTitleColor(Colors.sharedInstance.color3, for: UIControl.State())
        btnText.setTitleColor(Colors.sharedInstance.color3, for: UIControl.State())
        btnText.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 18)
    }
    
    
    func gradientLine(_ cellView:UIView,width:CGFloat,height:CGFloat)
    {
        
        let lineForCells:UIImageView = UIImageView(frame: CGRect(x: 0,y: height + (height / 2.2), width: width , height: 1.5))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0).cgColor,
            UIColor.white.cgColor]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: width + (width / 3), height: 1)
        
        lineForCells.layer.insertSublayer(gradient, at: 0)
        cellView.addSubview(lineForCells)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        if (sender as UIDatePicker) == dates
        {
            chosenDate = sender.date
            let dateString = dateFormatter.string(from: sender.date)
            //bDate.setTitle(dateString, forState: .Normal)
            lblDate.text = dateString
            
            dateToServer = Global.sharedInstance.convertNSDateToString(sender.date)
        }
        else
        {
            hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hour1.date))
            mmFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hour1.date))
            
            hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hours2.date))
            mmToHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hours2.date))
            
            if mmFromHour != 0
            {
                hhFromHour = hhFromHour + mmFromHour / 60
            }
            
            if mmToHour != 0
            {
                hhToHour = hhToHour + mmToHour / 60
            }
            if hhFromHour > hhToHour
            {
                if sender == hours2
                {
                    
                    hour1.date =  hours2.date
                }
                else if sender == hour1
                {
                    hours2.date = hour1.date
                }
            }
            
            
            let outputFormatter: DateFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            //24hr time format
            let hoursString = outputFormatter.string(from: self.hour1.date) + "-" + outputFormatter.string(from: self.hours2.date)
            // bHours.setTitle(hoursString,forState: .Normal)
            
            //אם שעת התחלה וסיום זהות - לא נשמר
            if outputFormatter.string(from: self.hour1.date) == outputFormatter.string(from: self.hours2.date)
            {
                lblHour.text = ""
                chosenFromHour = ""
                chosenToHour = ""
                hhFromHour = 0.0
                hhToHour = 0.0
            }
            else
            {
                lblHour.text = hoursString
                let hoursArr = hoursString.components(separatedBy: "-")
                if hoursArr.count == 2
                {
                    chosenFromHour = hoursArr[0]
                    chosenToHour = hoursArr[1]
                }
            }
            
            
        }
    }
    
    
    func dismissViewController()
    {
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        delegate.dismissViewController()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: tblSubject) || touch.view!.isDescendant(of: vSubjects1) || touch.view!.isDescendant(of: vArea1) || touch.view!.isDescendant(of: vDates1) || touch.view!.isDescendant(of: vHours1)) {
            
            return false
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
            for place in listPlaces{
                placesName += [place.name]
            }
            listAutocompletePlace=listPlaces
            txtCity.setSuggestions(placesName)
            txtCity.matchStrings(txtCity.text)
            txtCity.showSuggestionTableView()
            //            tableView.hidden = false
            
        }
    }
    
    func googlePlaceGeocoded(_ latitude:Double, longitude:Double)
    {
        //        mapView.clear()
        //        var marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        //        marker.title = txfAddressSearch.text
        //        mapView.selectedMarker = marker
        //        marker.map = mapView
        //
        //        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 15)
        //        mapView.camera = camera
        self.txtCity.text = ""
    }
    
    func googlePlaceReverseGeocode(_ address: String) {
        txtCity.text = address
    }
    func googlePlaceReverseGeocode(_ address: String , country: String ,city: String)
    {
        
    }
    
    
    
    
    
    @objc func openSubject()
    {
        if txtCity.text != ""
        {
            lblArea.text = txtCity.text
            chosenCity = txtCity.text!
        }
        else
        {
            chosenCity = ""
        }
        txtfSubject.placeholder = "SUBJECT_PLACE_HOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        dismissKeyboard()
        txtCity.isHidden = true
        tblCities.isHidden = true
        filterSubArr = []
        filterAreaArr = []
        tblSubject.reloadData()
        //txtCity.text = ""
        //txtfSubject.text = ""
        isSubjectFlag = true
        tblSubject.isHidden = false
        txtfSubject.isHidden = false
        txtfSubject.becomeFirstResponder()
        dates.isHidden = true
        hour1.isHidden = true
        hours2.isHidden = true
        lineView.isHidden  = true
        
        openArrow(bSubject, btn: btnSubject)
        closeArrow(btnArea, btn2: btnDate, btn3: btnHour)
        changeFontStyle(bArea, btn2: bDate, btn3: bHours)
        vSubjects1.isHidden = true
        vArea1.isHidden = true
        vHours1.isHidden = true
        vDates1.isHidden = true
        
    }
    
    @objc func openArea()  {
        dismissKeyboard()
        txtCity.placeholder = "AREA_PLACE_HOLDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        txtCity.isHidden = false
        txtCity.becomeFirstResponder()
        txtfSubject.isHidden = true
        filterAreaArr = []
        filterSubArr = []
        tblSubject.reloadData()
        tblCities.reloadData()
        //txtCity.text = ""
        isSubjectFlag = false
        txtCity.isHidden = false
        tblSubject.isHidden = true
        tblCities.isHidden = false
        dates.isHidden = true
        hour1.isHidden = true
        hours2.isHidden = true
        lineView.isHidden  = true
        
        openArrow(bArea, btn: btnArea)
        closeArrow(btnSubject, btn2: btnDate, btn3: btnHour)
        changeFontStyle(bSubject, btn2: bDate, btn3: bHours)
        // hideViews(vArea1)
        vSubjects1.isHidden = false
        vArea1.isHidden = true
        vHours1.isHidden = true
        vDates1.isHidden = true
    }
    @objc func openDate() {
        dismissKeyboard()
        if txtCity.text != ""
        {
            lblArea.text = txtCity.text
            chosenCity = txtCity.text!
        }
        else
        {
            chosenCity = ""
        }
        //txtfSubject.text = ""
        txtfSubject.isHidden = true
        //txtCity.text = ""
        txtCity.isHidden = true
        tblSubject.isHidden = true
        tblCities.isHidden = true
        dates.isHidden = false
        hour1.isHidden = true
        hours2.isHidden = true
        lineView.isHidden  = true
        
        openArrow(bDate, btn: btnDate)
        closeArrow(btnArea, btn2: btnSubject, btn3: btnHour)
        changeFontStyle(bArea, btn2: bSubject, btn3: bHours)
        vSubjects1.isHidden = false
        vArea1.isHidden = false
        vHours1.isHidden = true
        vDates1.isHidden = true
        
    }
    
    @objc func openHour(){
        dismissKeyboard()
        if txtCity.text != ""
        {
            lblArea.text = txtCity.text
            chosenCity = txtCity.text!
        }
        else
        {
            chosenCity = ""
        }
        //txtfSubject.text = ""
        txtfSubject.isHidden = true
        //txtCity.text = ""
        txtCity.isHidden = true
        tblSubject.isHidden = true
        tblCities.isHidden = true
        dates.isHidden = true
        hour1.isHidden = false
        hours2.isHidden = false
        lineView.isHidden  = false
        
        openArrow(bHours, btn: btnHour)
        closeArrow(btnArea, btn2: btnDate, btn3: btnSubject)
        changeFontStyle(bArea, btn2: bDate, btn3: bSubject)
        vSubjects1.isHidden = false
        vArea1.isHidden = false
        vHours1.isHidden = true
        vDates1.isHidden = false
        
    }
    
    
    @objc func imageTapped(){
        var clientStoryBoard2:UIStoryboard?
        clientStoryBoard2 = UIStoryboard(name: "Testing", bundle: nil)
        let viewCon:ClientNewEvent = clientStoryBoard2?.instantiateViewController(withIdentifier: "ClientNewEvent") as! ClientNewEvent
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil) 
    }
    
    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }
    
}
