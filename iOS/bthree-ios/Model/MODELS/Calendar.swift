//
//  Calendar.swift
//  Bthere
//
//  Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
//  Copyright © 2018 Bthere. All rights reserved.

import UIKit

class Calendar: NSObject {
    static let sharedInstance = Calendar()
    var calendar = Foundation.Calendar.current
    var carrentDate:Date = Date()
    var timezone = TimeZone(abbreviation: "GMT+02")!
    func getNumsDays(_ date:Date)->Int{
        let components = (calendar as NSCalendar).components([.month, .year], from: date)
        let dateFinal = calendar.date(from: components)!
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: dateFinal)
        let numDays = range.length
        return numDays
    }
    func getDayOfWeek(_ today:Date)->Int? {
        let myComponents = (calendar as NSCalendar).components(.weekday, from: today)
        let weekDay = myComponents.weekday
        return weekDay
    }
    func getFirstDay(_ date:Date)->Date{ //מחזירה את היום הראשון בחודש שנשלח
        var components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        components.day = 1 //TODO:לבדק שתמיד חוזר הראשון
        let dateFinal = calendar.date(from: components)!
        return dateFinal
    }
    //מוסיפה חודש בודד לתאריך
    func addMonth(_ date:Date) -> Date{
        let date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .month, value: 1, to: date, options: [])//
        return date!
    }
    //מןסיפה מספר חודשים רצוי לתאריך
    func addMonths(_ date:Date,numMonthAdd:Int) -> Date{
        let date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .month, value: numMonthAdd, to: date, options: [])//
        return date!
    }
    func addDay(_ date:Date) -> Date{
        let date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: date, options: [])//
        return date!
    }
    func addDays(_ date:Date, numDays: Int) -> Date{
        let date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: numDays, to: date, options: [])//
        return date!
    }
    func reduceDay(_ date:Date) -> Date{
        let date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: date, options: [])//
        return date!
    }
    func MinusDay(_ date:Date, day:Int) -> Date{
        let date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: -day, to: date, options: [])//
        return date!
    }
    //func that reduce days from a month nd add days and return the day of month
    func reduceAddDay(_ date:Date,reduce:Int,add:Int) -> Int{
        var date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: -reduce, to: date, options: [])//
        date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: add, to: date!, options: [])
        let components = (calendar as NSCalendar).components([.day], from: date!)
        let dayInMonth = components.day
        return dayInMonth!
    }
    func getMonth(_ date:Date,reduce:Int,add:Int) -> Int{
        
        var date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: -reduce, to: date, options: [])//
        date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: add, to: date!, options: [])
        let componentsmonth = (calendar as NSCalendar).components([.month], from: date!)
        let monthInMonth = componentsmonth.month
        return monthInMonth!
    }
    func getYear(_ date:Date,reduce:Int,add:Int) -> Int{
        var date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: -reduce, to: date, options: [])//
        date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: add, to: date!, options: [])
        let componentsmonth = (calendar as NSCalendar).components([.year], from: date!)
        let YearInDate = componentsmonth.year
        return YearInDate!
    }
    func getDay(_ date:Date,reduce:Int,add:Int) -> Int{
        let componentsmonth = (calendar as NSCalendar).components([.day], from: date)
        let DayInDate = componentsmonth.day
        return DayInDate!
    }
    func reduceAddDay_Date(_ date:Date,reduce:Int,add:Int) -> Date{
        var date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: -reduce, to: date, options: [])//
        date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .day, value: add, to: date!, options: [])
        return date!
    }
    func removeMonth(_ date:Date) -> Date{
        let date = (Foundation.Calendar.current as NSCalendar).date(byAdding: .month, value: -1, to: date, options: [])//
        return date!
    }
    func from( _ year:Int, month:Int, day:Int) -> Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        let gregorian = Foundation.Calendar(identifier: .gregorian)
        let date = gregorian.date(from: c)
        return date!
    }
    func logicalOneYearAgo(_ from: Date) -> Date {
        let gregorian: Foundation.Calendar = Foundation.Calendar(identifier: .gregorian)
        var offsetComponents: DateComponents = DateComponents()
        offsetComponents.year = -1
        return (gregorian as NSCalendar).date(byAdding: offsetComponents, to: from, options:[])!
    }
    func oneYearNext(_ from:Date) -> Date {
        let gregorian: Foundation.Calendar = Foundation.Calendar(identifier: .gregorian)
        var offsetComponents: DateComponents = DateComponents()
        offsetComponents.year = 1
        let nextYear: Date = (gregorian as NSCalendar).date(byAdding: offsetComponents, to: from, options: [])!
        return nextYear
    }
    func getPartsOfDate(_ from:Date , to:DateComponents) ->Date
    {
        var componentsFrom = (calendar as NSCalendar).components([.day, .month, .year], from: from) //year month day
        componentsFrom.hour = 0
        componentsFrom.minute = 0
        componentsFrom.hour = to.hour
        componentsFrom.minute =  to.minute
        let dateFinal = calendar.date(from: componentsFrom)!
        return dateFinal
    }
    //not in use in calls
    func saveEventInDeviceCalander()
    {
    }
    //returns integers from hh:mm string
    func hoursminutesfromString(hminutes: String) -> Array<Int> {
        var myarr =  Array<Int> ()
        var numHOURS:Int = 0
        var numMINUTES:Int = 0
        let hourminString = hminutes
        if hourminString.contains(":") {
            let splited = hourminString.components(separatedBy: ":")
            if splited.count == 2 {
                if splited[0].count == 2 &&  splited[1].count == 2 {
                    
                    // 1. first clean hours
                    let a1 =  splited[0].substring(to: 1)
                    if a1 == "0" {
                        //now get the real hour
                        let a2 =  splited[0].substring(from: 0)
                        if a2 == "0" {
                            numHOURS = 0
                        }
                        else {
                            let IntHOUR:Int = Int(a2)!
                            numHOURS = IntHOUR
                        }
                    }
                    else {
                        let a3 = splited[0]
                        let IntHOUR:Int = Int(a3)!
                        numHOURS = IntHOUR
                    }
                    //second clean minutes
                    let a4 =  splited[1].substring(to: 1)
                    if a4 == "0" {
                        //now get the real hour
                        let a5 =  splited[1].substring(from: 0)
                        if a5 == "0" {
                            numMINUTES = 0
                        }
                        else {
                            let IntMINUTES:Int = Int(a5)!
                            numMINUTES = IntMINUTES
                        }
                    }
                    else {
                        let a5 = splited[1]
                        let IntMINUTES:Int = Int(a5)!
                        numMINUTES = IntMINUTES
                    }
                    
                    //all logic in this condition
                    myarr.append(numHOURS)
                    myarr.append(numMINUTES)
                }
            }
        }
        
        
        
        return myarr
    }
    
}
