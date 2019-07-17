//
//  NewEventTableViewCell.swift
//  Bthere
//
//  Created by User on 12.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

//קבע אירוע - הסל הראשון
class NewEventTableViewCell: UITableViewCell,UITextFieldDelegate {

    var delegate:editTextInCellDelegate!=nil
    @IBOutlet weak var txtFText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtFText.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplatData(_ value:String)
    {
        //txtFText.placeholder = value
        txtFText.attributedPlaceholder = NSAttributedString(string:value, attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black]))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate.editTextInCell(0, text: txtFText.text! as AnyObject)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
