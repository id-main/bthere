//
//  InformationViewController.swift
//  Bthere
//
//  Created by User on 22.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//דף ספק קיים -הסבר על המערכת
class InformationViewController: NavigationModelViewController{
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var lblAboutTitle: UILabel!
    
    @IBOutlet weak var txtViewAbout: UITextView!
    
    @IBOutlet weak var collIcons: UICollectionView!
    
    @IBOutlet weak var lblIconsTitle: UILabel!
    
    
    //// pop up explain
    
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var btnCloseIn: UIButton!
    
    @IBAction func btnCloseIn(_ sender: AnyObject) {
        viewPopUp.isHidden = true
    }
    
    
    @IBOutlet weak var lblTitleIn: UILabel!
    
    @IBOutlet weak var viewImage: UIView!
    
    @IBOutlet weak var imgAbout: UIImageView!
    
    @IBOutlet weak var txtViewAboutIn: UITextView!
    
    var arrIconsNames:Array<String>?
    var arrImg:Array<String>?
    
    let language = Bundle.main.preferredLocalizations.first! as NSString
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPopUp.isHidden = true
        
       // let layout = UICollectionViewFlowLayout()
        // Do any additional setup after loading the view.
        arrImg = ["2People.png","call.png","ix.png","strips.png","eyeIkon.png","ministar.png","garb.png","ipic.png","mat.png","paper.png","graf.png","man.png"]
        arrIconsNames = ["aaa","bbb","ccc","ddd","eee","fff","ggg","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp"]
        
       // if language == "he"
        //    NSBundle.mainBundle().preferredLocalizations.first
                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
            collIcons.transform = scalingTransform
            collIcons.transform = scalingTransform
            collIcons.transform = scalingTransform
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UICollectionViewDelegate
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        //Aligning right to left on UICollectionView
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        let cell:InformationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformationCollectionViewCell",for: indexPath) as! InformationCollectionViewCell
        cell.setDisplayData(arrImg![indexPath.row])
     //   if language == "he"
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            cell.transform = scalingTransform
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
         viewPopUp.isHidden = false
        //כאן להוסיף את הטקסט המתאים לכל אייכון
        imgAbout.image = (collIcons.cellForItem(at: indexPath) as! InformationCollectionViewCell).imgIcon.image
        lblTitleIn.text = arrIconsNames![indexPath.row]
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 10
//    }
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath?) -> CGSize {
//        return CGSize(width: view.frame.size.width / 5, height:  view.frame.size.width / 5 )
//    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.size.width / 5, height:  view.frame.size.width / 5 )
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.size.width / 5, height:  view.frame.size.width / 5 )
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
