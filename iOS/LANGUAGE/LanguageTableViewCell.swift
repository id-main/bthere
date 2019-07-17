//
//  LanguageTableViewCell.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    var delegate:deleteMessageDelegate!=nil
    @IBOutlet weak var viewLang: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBut: UIView!
    var row:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var lblLang: UILabel!
    func setDisplayData(_ lang:String){
        lblLang.textAlignment = .center
        lblLang.text = lang
    }
    
    func SelectLang(){
        if viewLang.tag == 0{
            viewLang.backgroundColor = Colors.sharedInstance.color4
            lblLang.textColor = UIColor.white
            viewLang.tag = 1
            delegate.deleteMessage(self.row)
        }
        else{
            viewLang.backgroundColor = UIColor.clear
            lblLang.textColor = UIColor.black
            viewLang.tag = 0
        }
    }
    
}
