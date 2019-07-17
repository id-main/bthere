//
//  LanguageMain.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 31.08.2017
//  Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
//  Copyright © 2018 Bthere. All rights reserved.

import UIKit

class LanguageMain: NSObject {
    static let sharedInstance = LanguageMain()
    var USERLANGUAGE = "he"
    func setLanguage() {
               //  let langCultureCode: String = "ro_RO" etc
        var langCode: String = "he"
        let USERDEF = UserDefaults.standard
        USERDEF.removeObject(forKey: "AppleLanguages")
        if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
            USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
            USERDEF.synchronize()
        }
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 1 {
            langCode = "en"
            USERDEF.set([langCode/*, "he", "ro"*/], forKey: "AppleLanguages")
            USERDEF.synchronize()
            
        } else  if USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            langCode = "he"
            USERDEF.set([langCode/*, "en","ro"*/], forKey: "AppleLanguages")
            USERDEF.synchronize()
        } else if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 2 {
            langCode = "ro"
            USERDEF.set([langCode/*, "en", "he"*/], forKey: "AppleLanguages")
            USERDEF.synchronize()
        }
        else if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 3 {
            langCode = "ru"
            USERDEF.set([langCode/*, "en", "he"*/], forKey: "AppleLanguages")
            USERDEF.synchronize()
        }
         print( USERDEF.value(forKey:"AppleLanguages"))
        self.USERLANGUAGE = langCode
    }
}
