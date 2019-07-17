//
//  lagnForClientTableViewCell.swift
//  Bthere
//
//  Created by User on 10.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class lagnForClientTableViewCell: UITableViewCell {
    var delegate:deleteMessageDelegate!=nil
    var row:Int = 0
    var delegateChangeLanguage:changeLanguageDelegate!=nil
    @IBOutlet weak var viewLang: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBut: UIView!
    @IBOutlet weak var lblLang: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewLang.isUserInteractionEnabled = true
        viewLang.tag = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func setDisplayData(_ lang:String) {
        lblLang.textAlignment = .center
        lblLang.text = lang
    }
    
    func SelectLang(){
        if viewLang.tag == 0
        {
            viewLang.backgroundColor = Colors.sharedInstance.color3
            lblLang.textColor = UIColor.white
            viewLang.tag = 1
            delegate.deleteMessage(self.row)
        }
        else
        {
            if viewLang.tag == 0
            {
                viewLang.backgroundColor = UIColor.clear
                lblLang.textColor = UIColor.black
                viewLang.tag = 0
            }
        }
    }
}
