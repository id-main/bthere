//
//  KindNotificationsTableViewCell.swift
//  bthere.git
//
//  Created by User on 9.2.2016.
//
//

import UIKit

protocol openOrCloseTblDelegate {
    func openOrCloseTbl()
}
//סוג ההתראה-מדף התראות
class KindNotificationsTableViewCell: UITableViewCell,openOrCloseTblDelegate{
    
    //MARK: - Properties
    
    var delegate:reloadTableInCellDelegate! = nil
    var sectionCell:Int = 0
    var rowCell:Int = 0
    var stringSelected:String = ""//מה שנבחר-להצגה על הסל
    
    //MARK: - Outlet
    
    @IBOutlet weak var viewOpenTbl: UIView!
    @IBOutlet weak var openTbl: UIButton!
    @IBOutlet weak var itemSelected: UILabel!
    @IBOutlet weak var descLblInCell: UILabel!
    
    @IBOutlet weak var btnOpenTbl: UIButton!
    @IBAction func openTbl(_ sender: UIButton) {
        openOrCloseTbl()
    }
    
    //MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemSelected.textAlignment = .right
        let tapOpenTbl:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTable))
        viewOpenTbl.addGestureRecognizer(tapOpenTbl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDisplayData(_ desc:String,_itemSelected:String){
        
        descLblInCell.text = desc
        if Global.sharedInstance.selectedItemsForSaveData[sectionCell]![rowCell] != ""
        {
            itemSelected.text = Global.sharedInstance.selectedItemsForSaveData[sectionCell]![rowCell]
        }
        else
        {
            itemSelected.text = _itemSelected
        }
    }

    //MARK: - Functions
    
    @objc func openTable()
    {
        stringSelected = ""
        if Global.sharedInstance.tagCellOpenedInTbl == -1//הטבלה סגורה
        {
            Global.sharedInstance.tagCellOpenedInTbl = (self.textLabel?.tag)!
            Global.sharedInstance.isOpen = true
            delegate.openTable(btnOpenTbl,cell: self)
        }
        else if Global.sharedInstance.tagCellOpenedInTbl == self.textLabel?.tag//אותו סל שפתח את הטבלה
        {
            Global.sharedInstance.tagCellOpenedInTbl = -1
            
            for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind].count
            {
                if Global.sharedInstance.flagsHeadersForTblInCell[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind][i] == 1
                {
                    if stringSelected == ""
                    {
                        stringSelected = Global.sharedInstance.headersForTblInCell[i]
                    }
                    else
                    {
                        stringSelected = stringSelected + "," + Global.sharedInstance.headersForTblInCell[i]
                    }
                }
            }
            if stringSelected != ""
            {
                itemSelected.text = stringSelected
            }
            Global.sharedInstance.selectedItemsForSaveData[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind] = stringSelected
            Global.sharedInstance.isOpen = false
            delegate.closeTbl()
        }
    }
    //בלחיצה על הוי של פתיחת הטבלה הפנימית או סגירתה
    func openOrCloseTbl()
    {
        stringSelected = ""
        if Global.sharedInstance.tagCellOpenedInTbl == -1//הטבלה סגורה
        {
            Global.sharedInstance.tagCellOpenedInTbl = (self.textLabel?.tag)!
            Global.sharedInstance.isOpen = true
            delegate.openTable(openTbl,cell: self)
        }
        else //if Global.sharedInstance.tagCellOpenedInTbl == self.textLabel?.tag//אותו סל שפתח את הטבלה
        {
            Global.sharedInstance.isDescCellOpenFirst = false
            if Global.sharedInstance.isExtTblHeightAdded60 == true//ארועים של לקוחות-הוסיפו גובה לטבלה החיצונית
            {
                delegate.scrollExternalTbl()//החזרת גודל הטבלה החיצונית לגודלה הרגיל(הטבלה החיצונית גדלה בעת פתיחת הטבלה הפנימית כדי שיהיה אפשר לגלול את הפנימית לצורך בחירה)
            }
            Global.sharedInstance.tagCellOpenedInTbl = -1
            if Global.sharedInstance.sectionKind == 2 && Global.sharedInstance.rowKind == 1
            {
                //אם מבטלים את הדיפולטיבי ומיד רוצים לבחור מישהו אחר במקום בלי לסגור עדיין את הטבלה, שלא יבחר גם את מה שהיה קודם כדיפולטיבי אלא רק את הנוכחי שבחור
                if !Global.sharedInstance.flagsHeadersForTblInCell[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind].contains(1)//הכל איקס
                {
                    Global.sharedInstance.flagsHeadersForTblInCell[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind][1] = 1//שמירת הערך הדיפולטיבי
                }
            }
            
            for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind].count
            {
                if Global.sharedInstance.flagsHeadersForTblInCell[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind][i] == 1
                {
                    if stringSelected == ""
                    {
                        stringSelected = Global.sharedInstance.headersForTblInCell[i]
                        //אם זה הכל מספיק לכתוב על הלייבל של מה שנבחר רק ״הכל״ בלי לפרט מה וכן גם לשמור שבחר הכל
                        if stringSelected == Global.sharedInstance.headersForTblInCell[0] && Global.sharedInstance.sectionKind == 0// = "הכל"
                        {
                            break//כדי שלא ימשיך לשרשר את שאר הדברים שמסומנים כתוצאה מה״הכל״
                        }
                    }
                    else
                    {
                        stringSelected = stringSelected + "," + Global.sharedInstance.headersForTblInCell[i]
                    }
                }
            }
            if stringSelected != ""
            {
                itemSelected.text = stringSelected
            }
            Global.sharedInstance.selectedItemsForSaveData[Global.sharedInstance.sectionKind]![Global.sharedInstance.rowKind] = stringSelected
            Global.sharedInstance.isOpen = false
            delegate.closeTbl()
        }
    }
    
}
