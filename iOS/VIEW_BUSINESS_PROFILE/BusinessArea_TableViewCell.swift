//
//  BusinessArea_TableViewCell.swift
//  BThere
//
//  Created by User on 8.2.2016.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class BusinessArea_TableViewCell: UITableViewCell {

    //dictionary to check if a button checked
    var dicButtons:Dictionary<UIButton,Bool> = Dictionary<UIButton,Bool>()

    
    //MARK: - Outlet
    
    @IBOutlet weak var lbl_tchum1: UILabel!
    
    @IBOutlet weak var lbl_tchum2: UILabel!
    
    @IBOutlet weak var lbl_tchum3: UILabel!
 
    @IBOutlet weak var lbl_tchum4: UILabel!
  
    //when click on buttons to check domain,change the button's image to √:(same action to all buttons)
    @IBAction func btnImg1(_ sender: UIButton)
    {
        if dicButtons[sender] == true
        {
            dicButtons[sender] = false
            let image:UIImage = UIImage(named: "circleEmpty1.png")!
            sender.setBackgroundImage(image, for: UIControl.State());
        }
        else
        {
            dicButtons[sender] = true
            let image:UIImage = UIImage(named: "circleFill.png")!
            sender.setBackgroundImage(image, for: UIControl.State())
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //set the cell content
    func setDisplayData(_ content:String)
    {
        lbl_tchum1.text = content
        lbl_tchum2.text = content
        lbl_tchum3.text = content
        lbl_tchum4.text = content
    }


}
