//
//  objServiceProvidersForEdit.swift
//  Bthere
//
//  Created by User on 4.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class objServiceProvidersForEdit: NSObject {
    //מכיל את כל פרטי העובד:שם,טלפון וכו׳
    var objsers:objUsers = objUsers()
    //שומרת את השעות פעילות של העובד
    var arrObjWorkingHours:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    //שומר את ההפסקות של העובד
    var arrObjWorkingRest:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    var isHoursSelected:Array<Bool> = [false,false,false,false,false,false,false]//מציין לכל יום האם הוא בחור או לא
    var isHoursSelectedRest:Array<Bool> = [false,false,false,false,false,false,false]//מציין לכל יום בהפסקות האם הוא בחור או לא
    
    var isSelectAllHours:Bool = false
    var isSelectAllRecess:Bool = false
    
    var bSameWH:Bool = false
    
    override init() {
        objsers = objUsers()
        arrObjWorkingHours = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        arrObjWorkingRest = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        isHoursSelected = [false,false,false,false,false,false,false]
        isHoursSelectedRest = [false,false,false,false,false,false,false]
        isSelectAllHours = false
        isSelectAllRecess = false
        bSameWH = false
    }
    
    init(_objsers:objUsers,_arrObjWorkingHours:Array<objWorkingHours>,_arrObjWorkingRest:Array<objWorkingHours>,_isHoursSelected:Array<Bool>,_isHoursSelectedRest:Array<Bool>,_isSelectAllHours:Bool,_isSelectAllRecess:Bool,_bSameWH:Bool) {
        
        objsers = _objsers
        arrObjWorkingHours = _arrObjWorkingHours
        arrObjWorkingRest = _arrObjWorkingRest
        isHoursSelected = _isHoursSelected
        isHoursSelectedRest = _isHoursSelectedRest
        isSelectAllHours = _isSelectAllHours
        isSelectAllRecess = _isSelectAllRecess
        bSameWH = _bSameWH
    }
    
}
