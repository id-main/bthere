//
//  GlobalDetailsTableViewController.swift
//  bthree-ios
//
//  Created by User on 23.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//תת דף של נתונים כללים
class GlobalDetailsTableViewController: UITableViewController,UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ReloadCollectionDelegate  {
    
    var subjectsDesc:Array<String> = ["SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SUBJECT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var headersCell:Array<String> =
    ["BUSINESS_DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE),"LEADING_SENTENCE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ACTIVE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"WORKER_DETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"BUSINESS_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"CALENDAR_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var headersCellRequired:Array<Bool> = [false,true,false,true,false,false]
    
    let notificationsRowsInSection:Dictionary<Int,Int> = [0:2,1:1,2:2,3:2,4:2,5:2]
    
    var selectedCell:Array<Bool> = [false,false,false,false,false,false]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if selectedCell[section] == true{
            return notificationsRowsInSection[section]!
            
        }
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row)
        {
            
            //cell ראשי
            //            let cell11 = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell") as! MainTableViewCell
            //
            //            cell11.setDisplayData(headersCell[indexPath.section])
            //            cell11.layer.borderColor = Colors.sharedInstance.color1.CGColor
            //            cell11.layer.borderWidth = 1
            //            return cell11
        case 0:
            let cell:MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell")as!MainTableViewCell
            cell.tag = indexPath.section
//            cell.setDisplayData(headersCell[indexPath.section], hidden: headersCellRequired[indexPath.section])

            if indexPath.section != 1 && indexPath.section != 3
            {
                cell.setDisplayData(headersCell[indexPath.section],hidden: false,imageArrow: "",textArrow: "")
            }
            else
            {
                cell.setDisplayData(headersCell[indexPath.section],hidden: true,imageArrow: "",textArrow: "")
            }
            return cell
            //אם לחצו עליו
        default:
            switch(indexPath.section)
            {
                //תחום העסק
            case(0):
                //
                //                let cell0 = tableView.dequeueReusableCellWithIdentifier("cell_BusinessArea", forIndexPath: indexPath) as! BusinessArea_TableViewCell
                //                //2do
                //תוכן הcell-
                //בינתיים אין צורך להפעיל את הפונקציה
                //cell0.setDisplayData("תחום")
                //                return cell0
                //                let cell1:Section2TableViewCell = tableView.dequeueReusableCellWithIdentifier("Section2TableViewCell")as! Section2TableViewCell
                //                cell1.delegat = self
                //                cell1.setDisplayData()
                //                return cell1
                let cell:Section2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Section2TableViewCell")as!Section2TableViewCell
                cell.delegat = self
                cell.setDisplayData()
                return cell
                
                
            default:
                let cell:Section2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Section2TableViewCell")as!Section2TableViewCell
                cell.delegat = self
                cell.setDisplayData()
                return cell
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {if indexPath.row == 0{
        //            if indexPath.section != 1
        //            {
        if selectedCell[indexPath.section] == false                 {
            selectedCell[indexPath.section] = true
        }
        else
        {
            selectedCell[indexPath.section] = false
        }
        tableView.reloadData()
        }
        //}
    }
    
    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if section == 0{
        //            return 1
        //        }
        return subjectsDesc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Aligning right to left on UICollectionView
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        //        if indexPath.section == 0 {
        //            let cell:ImageDetailsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageDetailsCollectionViewCell", forIndexPath: indexPath) as! ImageDetailsCollectionViewCell
        //            cell.setDisplayData(detailsProduct.sNameFileD)
        //            cell.transform = scalingTransform
        //            return cell
        //        }
        let cell:ItemInCollectionInSection1CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemInCollectionInSection1CollectionViewCell", for: indexPath) as! ItemInCollectionInSection1CollectionViewCell
        cell.setDisplayData(subjectsDesc[indexPath.row])
        if Global.sharedInstance.rtl
        {
        cell.transform = scalingTransform
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if indexPath.section == 0{
        //            let viewCon:ProductImageViewController = storyboard!.instantiateViewControllerWithIdentifier("ProductImageViewController") as! ProductImageViewController
        //            viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        //            viewCon.pImage = ApiGlobal.sharedInstace.getImageFromUrl(detailsProduct.sNameFileD)
        //            self.presentViewController(viewCon, animated: true, completion: nil)
        //        }else{
        //            let viewCon:ProductImageViewController = storyboard!.instantiateViewControllerWithIdentifier("ProductImageViewController") as! ProductImageViewController
        //            viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        //            viewCon.pImage = ApiGlobal.sharedInstace.getImageFromUrl(detailsProduct.imgList[indexPath.row].sFileImg)
        //            self.presentViewController(viewCon, animated: true, completion: nil)
        //        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.height * 0.2, height: view.frame.size.height * 0.2)
    }
    
    //MARK: - ReloadCollectionDelegate
    func ReloadCollection(_ collImages:UICollectionView){
        collImages.reloadData()
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
