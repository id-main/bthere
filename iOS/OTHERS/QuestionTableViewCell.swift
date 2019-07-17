//
//  QuestionTableViewCell.swift
//  Bthere
//
//  Created by User on 19.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ st:String)  {
        lblQuestion.text = st
    }

}
