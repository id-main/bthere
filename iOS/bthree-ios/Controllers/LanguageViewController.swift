//
//  LanguageViewController.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
class LanguageViewController: NavigationModelViewController ,UITableViewDataSource,UITableViewDelegate,deleteMessageDelegate{
    var arrayLanguages:Array<String> = ["עברית","English","Romanian","русский","العربية"]
    var section = 0
    var intSelected:Int = -1 //lang selected to save
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblLang: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    
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
        case 3: //ru
            Global.sharedInstance.defaults.set(3, forKey: "CHOOSEN_LANGUAGE")
            Global.sharedInstance.defaults.synchronize()
        default:
            Global.sharedInstance.defaults.set(0, forKey: "CHOOSEN_LANGUAGE")
            Global.sharedInstance.defaults.synchronize()
        }
        LanguageMain.sharedInstance.setLanguage()
        Global.sharedInstance.reloadrootview()
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    
    @IBAction func btnClose(_ sender: AnyObject) {
        back()
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
//        let leftarrowback = UIImage(named: "sageata2.png")
//        self.btnClose.setImage(leftarrowback, for: UIControlState())
//        self.btnClose.setImage(leftarrowback, for: UIControlState())
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            btnClose.transform = scalingTransform
            self.backImg.transform = scalingTransform
        }
        titlescreen.text = "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnSave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
//        btnClose.imageView!.contentMode = .scaleAspectFit
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
        let  cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell")as!LanguageTableViewCell
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
            if let customCell:LanguageTableViewCell =  cell1 as? LanguageTableViewCell {
                customCell.viewLang.backgroundColor = UIColor.clear
                customCell.lblLang.textColor = UIColor.black
            }
        }
        print("languagechoose \(arrayLanguages[indexPath.row])")
        intSelected = indexPath.row
        guard let cell = self.tblLang.cellForRow(at: indexPath) as? LanguageTableViewCell
            else { return }
        
        if cell.viewLang.tag == indexPath.row {
            cell.viewLang.backgroundColor = Colors.sharedInstance.color4
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
    
    func  deleteMessage(_ section:Int){
        
    }
    
    func back()
    {
        let revealController: SWRevealViewController = self.revealViewController()
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewcon)
        revealController.pushFrontViewController(navigationController, animated: true)
    }
    func restart(){
        
    }
}
