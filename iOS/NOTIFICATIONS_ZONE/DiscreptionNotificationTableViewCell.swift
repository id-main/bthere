//
//  DiscreptionNotificationTableViewCell.swift
//  bthere.git
//
//  Created by User on 8.2.2016.
//
//

import UIKit
protocol openInCellDelegate{
    func openCellsUnder(_ cell:UITableViewCell,btn:UIButton)
}

//לדף התראות-הסל הראשון של תאור ההתראה
class DiscreptionNotificationTableViewCell: UITableViewCell {
    
    var delegate:openInCellDelegate! = nil
    
    let imageVClick = UIImage(named: "OK-select-strock-black.png")
    let imageV = UIImage(named: "OK-strock-black.png")
    let imageXClick = UIImage(named: "cancel-select-strock.png")
    let imageX = UIImage(named: "cancel-strock-black..png")
    
    @IBAction func btnOpen(_ sender: UIButton)
    {
        delegate.openCellsUnder(self,btn: btnOk)
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        
        delegate.openCellsUnder(self,btn: btnCancel)
    }
    @IBOutlet weak var lblDiscreption: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var viewTop: UIView!
    
    //MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setDisplayData(_ desc:String){
        
        lblDiscreption.text = desc
        if Global.sharedInstance.arrNotificationsV[self.tag]
        {
//            btnOk.setBackgroundImage(imageVClick, forState: .Normal)
//            btnCancel.setBackgroundImage(imageX, forState: .Normal)
            btnOk.setImage(imageVClick, for: UIControl.State())
            btnCancel.setImage(imageX, for: UIControl.State())
        }
        if Global.sharedInstance.arrNotificationsX[self.tag]
        {
//            btnOk.setBackgroundImage(imageV, forState: .Normal)
//            btnCancel.setBackgroundImage(imageXClick, forState: .Normal)
            btnOk.setImage(imageV, for: UIControl.State())
            btnCancel.setImage(imageXClick, for: UIControl.State())
        }
    }

}
