//
// weekdayevents.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 13.03.20§7
//  Copyright © 2017 Bthere. All rights reserved.
//
import UIKit

class weekdayevents: NSObject {
// day, index, hour, array
    var day:Int = 0
    var index:Int = 0
    var fromHour:Int = 0
    var allevents:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
       override init() {
        day = 0
        index = 0
        fromHour = 0
        allevents = Array<allKindEventsForListDesign>()
    }
    
    init(_day:Int,_index:Int,_fromHour:Int,_toHour:String,_allevents:Array<allKindEventsForListDesign>) {
        day = _day
        index = _index
        fromHour = _fromHour
        allevents = _allevents
    }
}
