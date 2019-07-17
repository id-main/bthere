//
//  langForClientViewController.swift
//  Bthere
//
//  Created by User on 10.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit


protocol changeLanguageDelegate{
    func changeLanguage(_ iLang:String)
}
class langForClientViewController: NavigationModelViewController ,UITableViewDataSource,UITableViewDelegate,deleteMessageDelegate,changeLanguageDelegate{
    var isfromsettings:Bool = false
    var arrayLanguages:Array<String> = ["עברית","English","Romana","русский","العربية"]
    var arrayLanguagesKey:Array<String> = ["he","en","ro","ru","ar"]
    let language = Bundle.main.preferredLocalizations.first! as NSString
    var indexLanguageInIphone = 0//שומר את המיקום של שפת האייפון שבמכשיר
    var intSelected:Int = -1 //lang selected to save
    var section = 0
    var langSelected = ""
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblLang: UITableView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBAction func btnClose(_ sender: AnyObject) {
        if self.isfromsettings == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller:UINavigationController = UINavigationController()
            let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
            let vc = storyboardCExist.instantiateViewController(withIdentifier: "CustomerSettings") as! CustomerSettings
            frontviewcontroller.pushViewController(vc, animated: false)
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btnSave(_ sender: AnyObject) {
        switch intSelected {
        case -1:
            showAlertDelegateX("NO_LANGUAGE_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            return
        case 0: //he
            Global.sharedInstance.defaults.set(0, forKey: "CHOOSEN_LANGUAGE")
            Global.sharedInstance.defaults.synchronize()
        case 1: //en
            Global.sharedInstance.defaults.set(1, forKey: "CHOOSEN_LANGUAGE")
            Global.sharedInstance.defaults.synchronize()
        case 2: //ro
            Global.sharedInstance.defaults.set(2, forKey: "CHOOSEN_LANGUAGE")
            Global.sharedInstance.defaults.synchronize()
        case 3:
            Global.sharedInstance.defaults.set(3, forKey: "CHOOSEN_LANGUAGE")
            Global.sharedInstance.defaults.synchronize()
        default:
            Global.sharedInstance.defaults.set(1, forKey: "CHOOSEN_LANGUAGE")
            Global.sharedInstance.defaults.synchronize()
        }
        LanguageMain.sharedInstance.setLanguage()
        Global.sharedInstance.reloadrootview()
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:26)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            btnClose.transform = scalingTransform
            backImage.transform = scalingTransform
        }
        btnClose.imageView!.contentMode = .scaleAspectFit
        AppDelegate.fromChangeLanguage = false
        lblTitle.text = "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnSave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        tblLang.separatorStyle = .none
        tblLang.isScrollEnabled = false
        self.view.addBackground()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "lagnForClientTableViewCell")as!lagnForClientTableViewCell
        cell.lblLang.textAlignment = .center
        cell.setDisplayData(arrayLanguages[indexPath.row])
        cell.selectionStyle = .none
        cell.row = indexPath.row
        cell.delegate = self
        if indexPath.row != self.section{
            cell.viewLang.backgroundColor = UIColor.clear
            cell.lblLang.textColor = UIColor.black
            cell.viewLang.tag = indexPath.row
        }
        if indexPath.row == 0{
            cell.viewTop.isHidden = false
        }
        else{
            cell.viewTop.isHidden = true
        }
        if indexPath.row == 2 {
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = Colors.sharedInstance.color6
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell1 in self.tblLang.visibleCells {
            if let customCell:lagnForClientTableViewCell =  cell1 as? lagnForClientTableViewCell {
                customCell.viewLang.backgroundColor = UIColor.clear
                customCell.lblLang.textColor = UIColor.black
            }
        }
        print("languagechoose \(arrayLanguages[indexPath.row])")
        intSelected = indexPath.row
        guard let cell = self.tblLang.cellForRow(at: indexPath) as? lagnForClientTableViewCell
            else { return }
        if cell.viewLang.tag == indexPath.row {
            cell.viewLang.backgroundColor = Colors.sharedInstance.color3
            cell.lblLang.textColor = UIColor.white
        }
        else{
            cell.viewLang.backgroundColor = UIColor.clear
            cell.lblLang.textColor = UIColor.black
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height*0.1
    }
    
    func deleteMessage(_ section:Int){
        
    }
    
    func changeLanguage(_ iLang:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.changeLanguage(iLang)
        Alert.sharedInstance.showAlert("LANG_CHANGE_NEXR_ENTRANCE".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
    }
}
