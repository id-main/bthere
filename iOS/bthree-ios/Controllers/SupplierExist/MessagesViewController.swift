//
//  MessagesViewController.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים דף הודעות מגיע מתפריט צד
class MessagesViewController: NavigationModelViewController ,UITableViewDelegate,UITableViewDataSource,deleteMessageDelegate{

    @IBOutlet weak var tblMessages: UITableView!
    var selectedMessages:Array<Bool> = [false,false,false,false]//מערך זה אותחל כרגע באופן ידני אך לאחר הקריאה לשרת יאותחל כמספר ההודעות שהתקבלו מהשרת
    override func viewDidLoad() {
        super.viewDidLoad()
tblMessages.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return Global.sharedInstance.MessageArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if selectedMessages[section] == false{
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0{
            let  cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell")as!MessageTableViewCell
            cell.setDisplayData(Global.sharedInstance.MessageArray[indexPath.section],dateMes: Date())
            cell.selectionStyle = .none
            if indexPath.section == 0{
                cell.viewTop.isHidden = false
            }
            else{
                cell.viewTop.isHidden = true
            }
            if selectedMessages[indexPath.section] == true{
                cell.viewButtom.isHidden = true
            }
            else{
                  cell.viewButtom.isHidden = false
            }
            return cell
        }
        let  cell = tableView.dequeueReusableCell(withIdentifier: "AllMessageTableViewCell")as!AllMessageTableViewCell
        cell.section = indexPath.section
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedMessages[indexPath.section] == false{
            selectedMessages[indexPath.section] = true
        }
        else{
            selectedMessages[indexPath.section] = false

        }
        //tblMessages.reloadData()
        self.tblMessages.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
        return view.frame.size.height*0.1
        }
        return view.frame.size.height*0.2

    }
    
    func  deleteMessage(_ section:Int){
        selectedMessages.remove(at: section)
        
     tblMessages.reloadData()
    }
    //    var verticalSpace = NSLayoutConstraint(item: self.imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.button, attribute: .Bottom, multiplier: 1, constant: 50)
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
