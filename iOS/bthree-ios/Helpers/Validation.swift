//
//  Validation.swift
//  Bthere
//
//  Created by User on 14.2.2016.
//  Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
//  Copyright © 2018 Bthere. All rights reserved.

import UIKit

class Validation: NSObject {
    static let sharedInstance = Validation()
    
    func mailValidation(_ string:String)->Bool
    {
        return (NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")).evaluate(with: string)
        
    }
    
    func phoneNumberValidation(_ value: String) -> Bool {
        if value.characters.count == 9
        {  //טלפון
            return (NSPredicate(format:"SELF MATCHES %@", "^\\d{2}?([ .-]?)\\d{3}?([ .-]?)\\d{4}$")).evaluate(with: value)
        }
        else if value.characters.count == 10
        { //פלאפון
            return (NSPredicate(format:"SELF MATCHES %@", "^\\d{3}?([ .-]?)\\d{3}?([ .-]?)\\d{4}$")).evaluate(with: value)
        }
        else
        {
            return false
        }
        
    }
    
    func  idValidation(_ string:String)->Bool
    {
        if string.characters.count != 9//בדיקה אם מכיל 9 ספרות
        {
            return false
        }
        return true
        //תקינות של תעודת זהות

    }
    
    //func to check validation of the business hours
    // return true - when hours were chosen
    // return false - when it is null
    func BusinessHoursValidate()-> Bool
    {
    for item in Global.sharedInstance.arrWorkHours
    {
        if item.iDayInWeekType != 0
        {
        return true
        }
    }
    return false
    }
    
    func isTzValid(_ tz:String) -> Bool {
                var sum:Int = 0
                var devidedNumber:Int = 0
                var id:Int = (Int)(tz)!
                let checkDigit:Int = id%10
                id = id/10
                for i:Int in 0  ..< 8 
                {
                    devidedNumber = id%10
                    if i%2 == 0
                    {
                        let sumOfDevided = devidedNumber*2
                        sum += sumOfDevided%10+sumOfDevided/10
                    }
                    else
                    {
                        sum += devidedNumber
                    }
                    id = id/10
                }
                if (sum+checkDigit)%10 == 0
                {
                    return true
                }
                return false
    }
}
