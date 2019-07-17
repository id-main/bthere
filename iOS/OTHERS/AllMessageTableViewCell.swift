//
//  AllMessageTableViewCell.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol deleteMessageDelegate {
    func  deleteMessage(_ section:Int)
}
class AllMessageTableViewCell: UITableViewCell{
    var section:Int = 0
    var delegate:deleteMessageDelegate!=nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let tapGestureMessages = UITapGestureRecognizer(target:self, action:Selector("deleteMessageFrom"))
//        deleteMessage.userInteractionEnabled = true
//        deleteMessage.addGestureRecognizer(tapGestureMessages)
//        tapGestureMessages.delegate = self
        
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AllMessageTableViewCell.deleteMessageFrom))
        recognizer.numberOfTapsRequired = 1
        deleteMessage.isUserInteractionEnabled = true
        deleteMessage.addGestureRecognizer(recognizer)

    }

    @IBOutlet weak var deleteMessage: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var txvtDesc: UITextView!
    func setDisplayData(_ desc:String){
        txvtDesc.text = desc
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return false
    }
    
    @objc func deleteMessageFrom(){
        Global.sharedInstance.MessageArray.remove(at: section)
        delegate.deleteMessage(section)
    }

}
