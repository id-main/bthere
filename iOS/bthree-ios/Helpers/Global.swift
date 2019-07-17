//
//  Global.swift
//  Bthere
//
//  Created by User on 11.2.2016.
//  Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
//  Copyright © 2018 Bthere. All rights reserved.

import UIKit
import EventKit
import EventKitUI
import Contacts
import AddressBook
import CoreTelephony
import PhoneNumberKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class Global: NSObject {
    static let sharedInstance = Global()
    //    private static var __once: () = {
//            Static.instance=Global()
//        }()
//    class var sharedInstance:Global {
//        struct Static {
//            static var onceToken:Int=0
//            static var instance:Global?=nil
//        }
//        _ = Global.__once
//        let deaufult:UserDefaults = UserDefaults.standard
//        
//        if deaufult.value(forKey: "LogOut") != nil
//        {
//            if deaufult.value(forKey: "LogOut") as! Bool == true
//                
//            {
//                UserDefaults.standard.set(false, forKey: "LogOut")
//                UserDefaults.standard.synchronize()
//                Static.instance = Global()
//            }
//        }
//        
//        return Static.instance!
//    }
    //Adjust Calendar zone
    var isInMeetingProcess:Int = 0
    
    var adjustCalendarUserInfo:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    
    var iServiceTimeSUM:Int = 0
    var ISFROMMULTIPLEAPPOINTMENTS:Bool =  false
    let phoneNumberKit = PhoneNumberKit()
    var canselectmultiple:Bool = false
    var moreservices:Int = 0
    var newslabel:String = ""
    var isFLIPPINGFORMLANGUAGE:Bool = false
    var isFIRSTREGISTER:Bool = false
    var isFIRSTSUPPLIER:Bool = false // you show pop-up with employees permission only once
    var rtl:Bool = false
    var fromChangeLanguage = false
    var langSelected = ""
    var viewConNoInternet:UIViewController?//למקרה שאין אינטרנט בעת שמגיע להודעת       generic השגיאה שיסיר מהויו קונטרולר את ה
    
    var freeHoursForWeek:Array<Array<providerFreeDaysObj>> = [Array<providerFreeDaysObj>(),Array<providerFreeDaysObj>(),Array<providerFreeDaysObj>(),Array<providerFreeDaysObj>(),Array<providerFreeDaysObj>(),Array<providerFreeDaysObj>(),Array<providerFreeDaysObj>()]//מערך המכיל 7 ימים בשבוע עם השעות הפנויות לכל יום
    
    var bthereEventsForWeek:Array<Array<OrderDetailsObj>> =
        [Array<OrderDetailsObj>(),Array<OrderDetailsObj>()
            ,Array<OrderDetailsObj>(),Array<OrderDetailsObj>()
            ,Array<OrderDetailsObj>(),Array<OrderDetailsObj>()
            ,Array<OrderDetailsObj>()]//מערך המכיל 7 ימים בשבוע עם אירועי ביזר לכל יום
    
    var giveServices:giveMyServicesViewController!
    
    var datDesigncalendar:DayDesignCalendarViewController?
    var dayDesigncalendarAppointment12:dayClientForAppointment12ViewController?
    var dayDesignCalendarSupplier:DayDesignSupplierViewController?
    
    var freeHoursForCurrentDay:Array<providerFreeDaysObj> = []//מערך שמכיל את כל השעות הפנויות של היום שעליו לחצו
    var lastDateGetTurns = Date()
    //var datDesigncalendarToSupplier:DayDesigCalendarViewController?//n
    var indexRowForIdGiveService:Int = -1
    //שמירת האינדקס של השורה לצורך ההגעה לid של הנותן שרות
    var indexRowForIdService:Int = -1
    //שמירת האינדקס של השורה לצורך ההגעה לid של השרות
    //המשתנים הבאים הם לצורך הצגת הפרטים בפופאפ פרטי התור
    var currentProviderToCustomer:SearchResulstsObj = SearchResulstsObj()// שומר את פרטי הספק,בינתיים
    var hourFreeEvent = ""//השעה של הארוע הפנוי שנבחר
    var hourFreeEventEnd = ""//השעת סיום הארוע הפנוי שנבחר
    var hourBthereEvent = ""//השעה של תחילת הארוע של ביזר להצגה על הפופאפ של פרטי הזמנה
    var hourBthereEventEnd = ""
    var orderDetailsFoBthereEvent:OrderDetailsObj = OrderDetailsObj()
    var isFromViewMode = false//האם הגיע לרישום לקוח דרך מצב צפיה
    var ARRAYEMPLOYEE:Array<objEMPLOYEE> = Array<objEMPLOYEE>()
    var ARRAYCALENDAR:Array<objEMPLOYEE> = Array<objEMPLOYEE>()
    var eventBthereDate:Date = Date()
    var eventBthereDateStart:Date = Date()
    var eventBthereDateEnd:Date = Date()
    var dayFreeEvent = ""//היום של הארוע הפנוי שנבחר
    var NewEventToHour:String = ""
    
    var dateDayClick:Date = Date()//תאריך של הארוע הפנוי שנבחר להצגה בפופאפ
    var dateEventBthereClick = Date()//תאריך של הארוע של ביזר שנבחר להצגה בפופאפ
    var isShowClickDate:Bool = false// האם להראות יום מהתאריך הנוכחי או מתאריך שנלחץ בתצוגת חודש
    var calendarAppointment:ModelCalendarForAppointmentsViewController?
    
    var model:Int = -1//מציין באיזה מודל נמצאים: יומן לקוח=1 , יומן ספק שהלקוח רואה=2
    var calendarClient:ModelCalenderViewController!
    
    var calendarAppointmentForSupplier:CalendarSupplierViewController?
    
    var isSelected:Bool = false
    var fromCalendar:Bool = false
    var calendarDesigned:Int = 0
    var globalData:RgisterModelViewController!
    //לכתובת:
    var isAddressCity = false
    var GlobalDataForDelegate:GlobalDataViewController!
    var didOpenBusinessDetails = false
    
    var isRegisterProviderClick:Bool = false//לחצו על רישום כספק
    var isRegisterClientClick:Bool = false//לחצו על רישום לקוח
    
    var isVclicedForWorkerForEdit = false//האם מסומן וי בשעות זהות לעןבד בשביל עריכה
    var isClickNoEqual:Bool = false//האם לחץ על האיקס של שעות שונות בעובד
    var isClickEqual:Bool = false
    var clickNoCalendar:Bool = false
    var fromClickEqualHours:Bool = false
    var fromClickEqualHoursChange:Bool = false
    var fromEdit:Bool = false
    var isSetDataNull:Bool = false
    var eleventCon:CalendarSupplierViewController!
    var headersForTblInCell:Array<String> = []
    //    var flagsHeadersForTblInCell:Array<Int> = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    var PresentViewMe:UIViewController?
    var isDeleted = false
    var isDeletedGiveMyService = false
    var isSyncWithGoogelCalendar:Bool = true//האם יש סנכרון עם היומן האישי ביומן לקוח
    var isSyncWithGoogelCalendarSupplier:Bool = true //האם יש סנכרון עם היומן האישי ביומן ספק
    var isSyncWithGoogleCalendarAppointment:Bool = true//האם יש סנכרון עם היומן האישי בתצוגת ספק שהלקוח רואה
    
    var nameOfCustomer:String = ""
    var mycustomers:MyCostumersViewController?
    var listDesign:ListDesignViewController?
    var appointmentsCostumers:CostumerAppointmentsViewController?
    var BthereEventList:BthereEventListViewcontroller?
    var WorkerCell:ItemInSection3TableViewCell?
    var isProvider = false//מציין האם נמצאים עכשיו בספק
    var isFromMenu = false
    var dateFreeDays:Array<Date> = []
    var isFromprintCalender = false
    var fReadRegulation = false//מציין האם מולא שדה קריאת תקנון ברישום
    var isHoursSelectedItem:Bool = false
    let calendar = Foundation.Calendar.current
    var domainBuisness:String = ""
    var flagIfValidSection1:Bool = false
    var flagIsSecond1Valid:Bool = true
    var  isFirstSectionValid:Bool = true
    var isOpenHoursForPlus:Bool = false
    var isOpenHoursForPlusAction:Bool = false
    var countFlag = 0
    var whichReveal:Bool = false //לקוח או ספק
    var sectionKind:Int = 0
    var rowKind:Int = 0
    var giveServiceName:String = ""//שמירת שם של הנותן שרות בשביל שאם נחזור לעמוד נציג מזה
    var heightModel:CGFloat = 0
    var defaults = UserDefaults.standard
    var heightForNotificationCell:CGFloat = 0
    //\\  var addressBook = ABAddressBookCreateWithOptions(nil, nil)?.takeRetainedValue()
    var phone:Array<String> = []
    var ifOpenCell:Bool = false
    var data:Array<String> = []
    var contactList:Array<Contact> = Array<Contact>()
    var searchcontactList:Array<Contact> = Array<Contact>()
    var selectedCellForEditService:Array<Bool> = []//מערך של פלאגים שמסמלים האם סל בעריכה של שרות פתוח או סגור
    ////googlePlus
//    var googleSignIn: GPPSignIn!
//    var signIn: GPPSignIn?
    var isGooglePlusChecked  = false
    var heightForCell:CGFloat = 0
    var categoriesArray:Array<String> = []
    var arrayViewModel:Array<UIViewController> = []//contains all reigster supplier views-helps to navigate between pages
    var arrEventsCurrentMonth:Array<EKEvent> = []
    var arrEvents:Array<EKEvent> = []
    var flagIsClickOnNoSameHour:Bool = false
    ///flags to check validation in registerController
    var registerViewCon:RegisterViewController?
    var isValid_FullName:Bool = true
    var isValid_Phone:Bool = true
    var isValid_Email:Bool = true
    var isValid_Address:Bool = true
    //עובדים
    var recessForWorker:Bool = false//האם נלחץ הפסקות לעובד
    var hoursForWorker:Bool = false//האם נלחץ שעות פעילות לעובד
    var hoursForWorkerFromPlus:Bool = false//האם נלחץ שעות פעילות לעובד מלחיצה על פלוס
    var recessForWorkerFromPlus:Bool = false//האם נלחץ הפסקות לעובד מלחיצה על פלוס
    var dicGetFreeDaysForServiceProvider:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()// המשתנה אותו נשלח לשרת שמכיל את קודי נותני השרות ושל קודי השרותים A variable that is sent to the server containing the service provider codes and service codes
    var hoursForWorkerFromEdit:Bool = false//האם נלחץ שעות פעילות לעובד בעריכה
    var lastChooseIndex:Int = -1 //בשביל הכל בסוג התראה רציתי לשמור על האינדקס האחרון שלחצו עליו
    var recessForWorkerFromEdit:Bool = false//האם נלחץ שעות הפסקות לעובד בעריכה
    var arrayGiveServicesKods:Array<Int> = []//מערך לשמירת הקודים של הנותני שרות לצורך שליחה לשרת כדי לקבל את השעות הפנויות A value for saving the codes of service providers to send to the server to receive the available hours
    var arrayServicesKods:Array<Int> = []//מערך לשמירת כל הקודים של השרותים
    var arrayServicesKodsToServer:Array<Int> = []//מערך לשרת לשמירת הקודים של השרותים לצורך שליחה לשרת כדי לקבל את השעות הפנויות
    //לדף של בחירת נותן שרות
    var multipleAppointmentsSupplierIDs:Array<Array<Int>> = Array<Array<Int>>()
    var idWorker:Int = -1//משתנה שיאותחל במס׳ של האיש צוות בעת לחיצה על השורה
    var giveServicesArray:Array<User> = []
    var idSupplierWorker:Int = -1
    var arrayServicesNames:Array<String> = []//מערך של כל שמות השירותים לעסק
    var serviceName:String = ""//שם השרות אותו מזמינים
    var multipleServiceName:Array<String> = []//שם השרותים אותם מזמינים בבחירה מרובה
    var arrCellsMultiple:Array<Bool> = Array<Bool>()
    var fromHourArray:Array<Date> = []//שעות התחלה של תורים ליום מסוים
    var endHourArray:Array<Date> = []//שעות סיום של תורים פנויים ליום מסוים
    
    var eventList:[AnyObject] = []
    
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var hasEvent = false
    var currentUser:User = User()//משתנה זה מאותחל בלקוח הנוכחי שעכשיו על המכשיר
    var currentProvider:Provider = Provider()
    //מכיל את מה שחוזר מהפונקציה getProviderAllDetails - כל פרטי הספק
    var currentProviderDetailsObj:ProviderDetailsObj = ProviderDetailsObj()
    var currentProviderBuisnessDetails:Provider = Provider()//שומר את מה שחוזר מהפונקציה getProviderBuisnessDetails-לעמוד הראשון של רישום ספק
    var RegisterNotEnd = false///מציין האם משתמש סיים את תהליך הרישום כולו : true=מילא חלק מהפרטים
    // בשביל דף התראות שומר לכל סל שיש בו בחירה מרובה מה נבחר בו
    var flagsHeadersForTblInCell:Dictionary<Int,Array<Array<Int>>> = [0:[[],[1,1,1,1]]
        ,2:[[],[-1,-1,-1],[-1,-1,-1]]
        ,3:[[],[-1,-1],[-1,-1,-1]]]
    var isCamera = false
    
    var MessageArray:Array<String> =
        ["WELCOME_TO_BTHERE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"KEY_SENTANCE_SLOGEN".localized(LanguageMain.sharedInstance.USERLANGUAGE),"NEW_VERSION_HERE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"DISCOUNTS_FOR_FIRST_REGISTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var selectedItemsForSaveData:Dictionary<Int,Array<String>> = [0:["",""]
        ,2:["","",""]
        ,3:["","",""]
        ,4:["",""]]
    var isFromRegister = Bool()//מציין אם נכנסו דרך לוגין או הרשמה רגילה
    var imgCostumersArray:Array<String> = ["","4.png","user-icon.png","","4.png","user-icon.png"]
    //JMODE  var nameCostumersArray:Array<String> = ["דוד לוי","חיים","יצחק כהן","משה כץ","זאב בן דוד"]
    var ISFROMSETTINGS:Bool = false
    var nameCONTACTSArray:NSMutableArray = []
    var SEARCHnameCONTACTSArray:NSMutableArray = []
    var nameCostumersArray:NSMutableArray = []
    //jmode add for my customer
    var searchCostumersArray:NSMutableArray = []
    var ISSEARCHINGCUSTOMER:Bool = false
    var ISSEARCHINGCONTACT:Bool = false
    var isfromSPECIALiWorkerUserId:Int = 0
    var myCustomerOrdersARRAY:NSArray = []
    var CurrentProviderArrayWorkers:NSMutableArray = []
    //jmode freedays general loged in
    var NOWORKINGDAYS:NSMutableArray = []
    //jmode freedays for all workers
    var FREEDAYSALLWORKERS:NSMutableArray = []
    var FREEDAYSALLCALENDARS:NSMutableArray = []
    var fIsValidDetails = false
    var iSupplierServiceIdForDeleteUserPermission:NSMutableArray = NSMutableArray() //on update general details the deleted services are send to server to cancel permissions
    var kindNotificationsTableViewCell:KindNotificationsTableViewCell?
    var isDescCellOpenFirst = true
    //מערכים השומרים לכל סקשין האם מסומן בוי או באיקס
    var arrNotificationsV:Array<Bool> = [true,true,true,true,true]
    var arrNotificationsX:Array<Bool> = [false,false,false,false,false]
    var isExtTblHeightAdded60 = false
    var tagCellOpenedInTbl = -1//save the cell's tag opened inTbl in notifications page(= -1 if itself opened)
    var isOpen :Bool = false//to know if tbl is open
    //שומר את כל מה הטבלאות שחוזרות מהפונקציה:GetSysAlertsList
    var arrSysAlerts:Array<SysAlerts> = Array<SysAlerts>()
    //שומר את כל מה הטבלאות שחוזרות מהפונקציה:GetSysAlertsList
    var dicSysAlerts: Dictionary<String,Array<SysAlerts>> =  Dictionary<String,Array<SysAlerts>>()
    var arrayDicForTableViewInCell:Dictionary<Int,Array<Array<String>>> =
        [0:[[],[]]
            ,2:[[],[],[]]
            ,3:[[],[],[]]]
    
    
    
    //אוביקט מוכן לשליחה לשרת לפונקציה:AddProviderAlertSettings
    var addProviderAlertSettings:AddProviderAlertSettings = AddProviderAlertSettings()
    //2do - למחוק בהמשך...
    //var selectedSavedCustomer = "פופאפ"//משתנה זמני עד שהשרת יעדכן בשימור לקוחות את האוציות של פופאפ,מייל,הודעות
    //אוביקט מוכן לשליחה לשרת לפונקציה:AddProviderBusinessProfile
    var addProviderBusinessProfile:AddProviderBusinessProfile = AddProviderBusinessProfile()
    
    var helperTable:UITableView?
    var helperTable1:UITableView?
    var countInitInGlobalData:Int = 0
    //SyncContacts מוכן לשליחה לשרת לפונקציה dictionary
    var dicSyncContacts:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    
    var modelCalenderForAppointment:ModelCalendarForAppointmentsViewController?
    var modelCalender:ModelCalenderViewController?
    var itemInCol:ItemInCollectionInSection1CollectionViewCell?
    //מודל הרשמה-בשביל הדלגייט של שמירת פרטי הספק בשרת
    var rgisterModelViewController:RgisterModelViewController?
    //\\05.04.2017 JMODE ADD
    var supplierSettings:SupplierSettings?
    var detailsCustomerViewController:DetailsCustomerViewController?
    var isFromBack = false
    
    //for auto complete
    var filterSubArr:Array<String> = []
    
    var currentOpenedMenu:UIViewController?
    
    var viewConGlobalData:GlobalDataViewController?
    var giveMyServices:giveMyServicesViewController?
    
    //----
    var currentLat: CLLocationDegrees?
    var currentLong: CLLocationDegrees?
    
    var searchDomain = ""//שומר את הטקס שנרשם בשורת החיפוש או את התחום מחיפוש מתקדם
    var dicSearchProviders:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()//מתמלא לפי הנתונים שנשלחו לשרת בחיפוש, עבור שנה מיקום
    
    var whichSearchTag:Int = -1//חיפוש רגיל - 1, חיפוש מתקדם - 2
    var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()//עבור השליחה לשרת
    var searchResult:SearchResultsViewController?
    var entranceCustomer:entranceCustomerViewController?
    var giveMyServicesForBusinessProfile:giveMyServicesViewController?
    var isSettingsOpen = false
    var viewCon2:ViewBusinessProfileVC?
    var providerBusinessProfile:AddProviderBusinessProfile = AddProviderBusinessProfile()
    
    var viewCon:ListServicesViewController?
    var arrayWorkers:Array<String> = []
    var firstGiveService:Bool = true//מיועד כדי לגלול את הנותן שרות הראשון
    var firstShowResults:Bool = true//מיועד כדי לגלול את התוצאת חיפוש הראשונה מעט שמאלה
    var firstService:Bool = true //מיועד כדי לגלול את השירות הראשון מעט שמאלה
    var getFreeDaysForService:Array<providerFreeDaysObj> =  Array<providerFreeDaysObj>()
    var ordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()// מערך תורי ביזר ללקוח
    var ordersOfClientsTemporaryArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
    var isOpenSale:Bool = true//לדעת האם הויו של העלאת מבצע
    
    var placeIdForMap = ""
    
    var couponsForProvider:Array<CouponObj> = Array<CouponObj>()//רשימת מבצעים
    
    var dicResults:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
    var dicResultHourFree:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()//לתוכו מאוחסנות השעות הפנויות של נותן שרות
    
    var didOpenSearchResult = false
    var isFromSearchResults = false//כדי לדעת איך להציג את הדף פרופיל עסקי עריכה או תצוגה.
    var isFromEntranceOrProviders:Int = 0 // 1 is for entrance, 2 is for providers 
    //MARK: - ItemInSection3TableViewCell
    var txtAdressItem3 = false
    var isTblAddresssOpen:Int32 = 0
    var cutrrentRowForAddress:Int = -1 //save the current row, to know how many to scroll
    var isOpenAddressTbl = false // האם הטבלה של הכתובות פתוחה
    //true - לפתוח  false - לסגור
    var isStillOpen = false//נדלק בתוך הפונקציה שפותחת את הטבלה - כדי שבעת גלילה אדע אם עדיין הטבלה פתוחה
    var indexForArr:Int = -1
    var item3:ItemInSection3TableViewCell?
    var hoursActiveTableViewCell:HoursActiveTableViewCell?
    //flags for validation
    var isValid_fName:Bool = false
    var isValid_lName:Bool = false
    var isValidPhone:Bool = false
    var isValidEmail:Bool = false
    
    //MARK: -  GlobalData ״נתונים כלליים״
    var isReturn2RowsForHours = false
    var isOpenWorker = false//נדלק בעת הוספת עובד ונכבה בשמירת העובד,משמש כדי למנוע הצגת סל ריק בעת גלילה
    
    var txtSearch:String = ""
    var isFromSave = false
    var isReloadForEdit = false
    var isNewService = false//האם צריך לפתוח את הסל של שרות ומוצר מכפתור הוסף שרות
    var isAddWorker = false
    var isFromFirstSave = false
    var isOpenNewWorker = false
    var isOpenHours = false
    var countCellHoursOpenFromEdit = 0//מונה כמה סלים של שעות פעילות בעריכה פתוחים לצורך חישוב הגובה לאחר השנוי שכל פעם פתוח רק סל אחד משתנה זה יכול להכיל או אפס או 1
    var countCellEditOpen = 0//משתנה זה מכיל כמה סלים של עריכה פתוחים לצורך חישוב הגובה
    
    var isOpenHoursForNewWorker = false
    var fSection5 = false
    var indexPathNew:IndexPath?
    var indexPathWithSection5:IndexPath?
    var isContinuPressed = false//מציין האם לחצו על המשך בהרשמה
    var arrEditWorkers:Array<Bool> = []
    
    var headersCellRequired:Array<Bool> = [false,false,true,false,true]
    var selectedCell:Array<Bool> = [false,false,false,false,false,false]//מערך של פלאגים שמיצג האם הסלים החיצוניים פתוח או סגור
    var currentEditCellOpen:Int = -1//שומר את הסל הנוכחי שפתוח בנתונים כלליים כדי לדעת את מי לסגור בלחיצה על סל נוסף (לא ניתן לפתוח מספר סלים בו זמנית),
    // = 1- כאשר הכל סגור
    
    //___________flags for validation_______________________
    var isClickCon:Bool = false
    var delegateValidData:validDataDelegate!=nil
    var isAllFlagsFalse = true//לפרטי עובדים
    var isFromEdit:Bool = false//דגל המציין האם הגיעו לפונקציה של התקינות מעריכה
    var isServiceProviderEditOpen = false//דגל המציין האם עריכת עובד פתוח
    var isFromEditService:Bool = false//דגל שנדלק בעת לחיצה על עריכת שרות או מוצר
    //לשרותי העסק
    var isValidDiscount = false
    var isValidMinConcurrentCustomers = false
    var isValidPrice = false
    var isValidServiceName = false
    var isValidTimeInterval = false
    var isValidTimeOfService = false
    var isValidMaxConcurrent = false
    var fDiscount = false
    var isNewServicePlusOpen = false //דגל למניעת ריקון הנתונים בשרות או מוצר בעת גלילה
    var fisValidWorker = false//the flag is true when the section 2 - workers is valid, if not = false
    //I use it because the func that check the validation always returns true
    var isFirst:Bool = true
    var isFirstBussinesServices:Bool = true
    var isFirstCalenderSetting:Bool = true
    var isNotDuplicateCount:Int = 0
    var fDomain:Bool = false
    var fIsSaveConHoursPressed:Bool = false
    var fIsValidHours:Array<Bool> = [true,true,true,true,true,true,true]// בשביל העסק - שעות
    var fIsValidRest:Array<Bool> = [true,true,true,true,true,true,true]//בשביל העסק - הפסקות
    var fIsValidHoursChild:Array<Bool> = [true,true,true,true,true,true,true]//בשביל עובדים - שעות
    var fIsValidRestChild:Array<Bool> = [true,true,true,true,true,true,true]//בשביל עובדים - הפסקות
    
    var isValidHours:Bool = true
    var fIsEmptyOwnerHours = false
    var fIsEmptyBussinesServices = false
    var fIsSaveConBussinesServicesPressed:Bool = false
    var fIsEmptyCalenderSetting = false
    var fIsSaveConCalenderSettingPressed:Bool = false
    var isValidWorkerDetails:Bool = true
    var selectedCellEdit:Int = 0//שומר את האינדקס של העובד העכשוי שפתוח בעריכה
    
    //______________Properties to server__________________
    
    var isDateNil = false
    var GlobalDataVC:GlobalDataViewController?
    var hoursActive:HoursActiveTableViewCell?
    
    //--------for the delegate saveData------
    var itemInSection3TableViewCell:ItemInSection3TableViewCell?
    var saveTableViewCell:SaveTableViewCell?
    var itemInSection2TableViewCell:ItemInSection2TableViewCell?
    //---------------------------------------
    
    
    //אוביקט שמכיל את כל מה שצריך לשלוח לשרת מדף נתונים כלליים
    var generalDetails:objGeneralDetails = objGeneralDetails()
    //מכיל את מה שחוזר מהפונקציה בשרת getProviderDetails -פרטי הספק מדף נתונים כלליים
    //var currenProviderDetails:objGeneralDetails = objGeneralDetails()
    var arrIsRestChecked:Array<Bool> = [false,false,false,false,false,false,false]
    var arrIsRestCheckedChild:Array<Bool> = [false,false,false,false,false,false,false]
    
    var isOwner:Bool = true
    
    //if isOwner=true -------------------
    
    var fIsRestBefore = false
    
    //שעות פעילות
    
    //שעות פעילות חדש-----
    var numbersOfLineInLblHours:Int = 1
    var numbersOfLineInLblRest:Int = 1
    var isBreak = false
    var addRecess = false//אם לחצו על הוסף הפסקות נדלק,בסגירת הסל נכבה
    var onOpenTimeOpenHours = false//נדלק מיד בפתיחת הסל של שעות פעילות כי אז צריך לאתחל את הדייט פיקר לפי מה שנבחר כדי שיהיה שונה בשעות ובהפסקות
    var onOpenRecessHours = false//נדלק מיד בלחיצה על הוסף הפסקות של שעות פעילות כי אז צריך לאתחל את הדייט פיקר לפי מה שנבחר כדי שיהיה שונה בשעות ובהפסקות
    var isFirstHoursOpen = false//נדלק בפעם הראשונה שפותחים את השעות פעילות
    var isFirstRecessHoursOpen = false//נדלק בפעם הראשונה שפותחים את ההפסקות
    var isSelectAllHours = false
    var isSelectAllRest = false
    var isSelectAllHoursChild = false
    var isSelectAllRestChild = false
    var isRest = false//מציין האם נבחרו הפסקות,נדלק בפעם הראשונה שבוחרים הפסקות
    //------------
    
    
    var workingHours:objWorkingHours = objWorkingHours()
    var hourShow:String = ""//שומר את הסטרינג של השעות פעילות שבנחרו להצגה
    var hourShowRecess:String = ""//שומר את הסטרינג של ההפסקות שבנחרו להצגה
    var hourShowRetain:String = ""
    var hourShowRecessRetain:String = ""
    var hourShowChild:String = ""
    var hourShowRecessChild:String = ""
    
    var isHourScrolled = false
    
    var hourShowFirstWorker:String = ""
    var hourShowRecessFirstWorker:String = ""
    //משתנים אלו הם לצורך רענון גובה הסל של הצגת השעות וההפסקות אם הגובה של הלייבל השתנה
    var lastLblHoursHeight:CGFloat = 0.0//שומר את גובה הלייבל שעות הקודם של הצגת השעות פעילות בנתונים כלליים
    var currentLblHoursHeight:CGFloat = 0.0//שומר את גובה הלייבל שעות הנוכחי של הצגת השעות פעילות בנתונים כלליים
    var lastLblRestHeight:CGFloat = 0.0//שומר את גובה הלייבל הפסקות הקודם של הצגת השעות פעילות בנתונים כלליים
    var currentLblRestHeight:CGFloat = 0.0//שומר את גובה הלייבל הפסקות הנוכחי של הצגת השעות פעילות בנתונים כלליים
    
    //שומר לכל יום את השעות פעילות שנבחרו
    var arrWorkHours:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    var NEWARRAYOBJWORKINGHOURS:Array<objWorkingHours> = Array<objWorkingHours>()
    var NEWARRAYOBJEMPLOYEEWORKINGHOURS:Array<objWorkingHours> = Array<objWorkingHours>()
    var employehassamehours:Bool = true
    var EMPLOYE_TO_EDIT:User = User()
    var NEW_EMPLOYEE_EDIT:objEMPLOYEE = objEMPLOYEE()
    var myIndexForEditWorker:Int = 0 //which Employee is edited from settings
    var myIndexForEditCalendar:Int = 0 //which Calendar is edited from settings

    //שומר לכל יום האם הוא בחור או לא כדי שכששומרים  את השעות פעילות נשווה לפי זה עם מה שנשמר באוביקט:arrWorkHours ונמחק את הימים שאין צורך לשומרם
    var isHoursSelected:Array<Bool> = [false,false,false,false,false,false,false]
    var isHoursSelectedRest:Array<Bool> = [false,false,false,false,false,false,false]
    var isHoursSelectedChild:Array<Bool> = [false,false,false,false,false,false,false]
    var isHoursSelectedRestChild:Array<Bool> = [false,false,false,false,false,false,false]
    
    ///הפסקות
    var workingHoursRest:objWorkingHours = objWorkingHours()
    var arrWorkHoursRest:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    var firstTimeOpenedHours:Bool = false
    var firstTimeOpenedRestHours:Bool = false
    
    //היה כשהיה את השעות פעילות הישן
    //    //indexPath to save the current index path of day which selected to save it's hours
    //    var currentIndexPath:Int = -1//שעות פעילות
    //    var currentIndexPathRest:Int = -1//הפסקות
    
    //indexPath to save the current button's tag of day which selected to save it's hours
    var currentBtnDayTag:Int = -1//שומר את הטאג של היום שעליו לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל שעות פעילות
    var lastBtnDayTag:Int = -1//שומר את הטאג של היום שעליו לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל שעות פעילות
    var currentBtnDayTagRest:Int = -1//לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל הפסקות
    var lastBtnDayTagRest:Int = -1//שומר את הטאג של היום שעליו לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל הפסקות
    
    
    //-------------------------------------------
    
    
    //if isOwner=false -------------------
    
    //שעות פעילות
    var workingHoursChild:objWorkingHours = objWorkingHours()//אוביקט זמני לשמירת שעות ליום בודד
    var arrWorkHoursChild:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]//מערך זמני לשמירת שעות לעובד מסויים
    ///הפסקות
    var workingHoursRestChild:objWorkingHours = objWorkingHours()
    var arrWorkHoursRestChild:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    
    //indexPath to save the current button's tag of day which selected to save it's hours
    var currentBtnDayTagChild:Int = -1//שומר את הטאג של היום שעליו לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל שעות פעילות
    var lastBtnDayTagChild:Int = -1//שומר את הטאג של היום שעליו לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל שעות פעילות
    var currentBtnDayTagRestChild:Int = -1//לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל הפסקות
    var lastBtnDayTagRestChild:Int = -1//שומר את הטאג של היום שעליו לחצו-הטאג מאותחל לפי שיום ראשון=0 וכו׳ בשביל הפסקות
    
    //    //indexPath to save the current index path of day which selected to save it's hours
    //    var currentIndexPathChild:Int = -1//שעות פעילות
    //    var currentIndexPathRestChild:Int = -1//הפסקות
    
    //------------------------------------
    
    //מכיל את נתוני העובדים שהספק מוסיף בשביל השרת
    var serviceProvider:objServiceProviders = objServiceProviders()
    var serviceProviderForEdit = objServiceProvidersForEdit()
    // מערך של כל העובדים עם כל פרטיהם,שומר לכל עובד את השעות פעילות וההפסקות,זה עוזר לעריכת פרטי העובד
    var arrObjServiceProvidersForEdit:Array<objServiceProvidersForEdit> = Array<objServiceProvidersForEdit>()
    
    // flags to business service
    var isFirstOpenKeyBoard = false
    var isFirstCloseKeyBoard = false
    
    // flags to add/remove keyBoard events
    var didSection3Closed = true
    var didServicesClosed = true
    var didCalendarSettingClose = true
    
    var calendarSetting:CalenderSettingTableViewCell?
    var businessService:BussinesServicesTableViewCell?
    
    //MARK: - Client Exist
    //בשביל דף אני רוצה להזמין
    var indexCellSelected = 0//שומר את האינדקס של הסל שבו לחצו על בחירה מרובה
    var isFirstCellSelected = false//מציין האם זה הסל הראשון שבחור
    var numCellsCellected = 0//סופר כמה מסומנים יש כדי שאם אין שום מסומנים נציג את הצורה הרגילה של הסלים
    
    var providerName:String = String()//providerName after is select
    var providerID:Int = Int()//providerName after is select
    //flags for pop up "detailsAppointmetClientViewController":
    var whichDesignOpenDetailsAppointment:Int = 0//1 = opened from day,2 = from week, 3 = from list turn on when open the pop up, to know where to go back
    var isCancelAppointmentClick = false//turn on if click on cancel
    //MONTHCALANDER
    var currDateSelected:Date = Date()
    var desingMonth:MonthDesignedViewController!
    var designMonthAppointment:MonthClientForAppointmentDesignViewController!
    //MonthDesignedViewController__________________________________________________
    var hourFreeEventInPlusMenu = ""//  בתפריט פלוס השעה של הארוע הפנוי שנבחר
    
    //WaitingList
    var arrWaitingList:Array<WaitingListObj> = Array<WaitingListObj>()//רשימת ההמתנה ללקוח
    //notificationsForDefinationsViewController
    var customerAlertsSettingsObj:CustomerAlertsSettingsObj = CustomerAlertsSettingsObj()//שומר את ההתרות שמסמן הלקוח בדף התראות מהגדרות
    var menuPlusViewController:MenuPlusViewController?
    //new 23-01-17
    //שומר את מערך המבצעים לדף הדקה ה-90
    var arrDiscount90Obj:Array<Discount90Obj> = Array<Discount90Obj>()
    //שומר לכל חודש בשנה האם התקבלו הנתונים של ימים פנויים לחודש מהשרת,כדי למנוע מצב שילחץ על מעבר חודש לפני שהנתונים של חודש זה יתקבלו
    var arrMonthFinishGetFreeDays:Array<Bool> = [false,false,false,false,false,false,false,false,false,false,false,false,false]
    
    var employeesPermissionsArray:Array<Int> = Array<Int>()
    
    //iustin notifications issue
//    var numberOfNotifications:Int = 0
    
    //MARK: - Functions
    func cutStringBySpace(_ fullName:String,strToCutBy:String)->Array<String>
    {
        let name = fullName
        let nameArr = name.components(separatedBy: strToCutBy)
        //        let firstName: String = nameArr[0]
        //        let lastName: String? = nameArr.count > 1 ? nameArr[1] : nil
        return nameArr
    }
    
    //ארועים לחודש מסויים
    func setEventsArray()
    {
        arrEventsCurrentMonth = []
        for item in Global.sharedInstance.eventList
        {
            let event = item as! EKEvent
            
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
            
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)
            
            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!
            
            let yearEvent =  componentsEvent.year
            let monthEvent = componentsEvent.month
            //let dayEvent = componentsEvent.day
            
            if yearEvent == yearToday && monthEvent == monthToday
            {
                arrEventsCurrentMonth.append(event)
                //\\        print("eveeeent \(event.startDate)")
                hasEvent = true
            }
        }
        
    }
    
    func setAllEventsArray()
    {
        self.arrEvents = []
        for item in Global.sharedInstance.eventList
        {
            let event = item as! EKEvent
            
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
            
            //let componentsEvent = calendar.components([.Day, .Month, .Year], fromDate: event.startDate)
            
            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!
            
            //            let yearEvent =  componentsEvent.year
            //            let monthEvent = componentsEvent.month
            //            let dayEvent = componentsEvent.day
            
            //            if yearEvent == yearToday && monthEvent == monthToday
            //            {
            arrEvents.append(event)
            hasEvent = true
       //\\     print("what is add \(event.title) \(event.startDate.description)")
            //            }
        }
        
        arrEvents =   arrEvents.sorted(by: { ($0 ).startDate.timeIntervalSinceNow < ($1 ).startDate.timeIntervalSinceNow })
    }
    //ממירה תמונה לסטרינג
    func setImageToString(_ image:UIImage)->String{
        //var data:NSData
       // var imagerec = image
        var imageData:NSString
        var dataForJPEGFile:Data
        var quality:CGFloat = 1.0
        if let _:UIImage=image{
            if UIDevice.current.userInterfaceIdiom == .pad {
                quality = 0.7
            }
            dataForJPEGFile = image.jpegData(compressionQuality: quality)!
            //            imagerec = UIImage(data:dataForJPEGFile)!
            //          // let newSize:CGSize = CGSizeMake(image.size.width*0.85, image.size.height*0.85)
            //             let newSize:CGSize = CGSizeMake(image.size.width, image.size.height)
            //            UIGraphicsBeginImageContext(newSize)
            //            imagerec.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
            //            let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()!
            //            UIGraphicsEndImageContext()
            //   data = UIImagePNGRepresentation(newImage)!
            // dataForJPEGFile = UIImageJPEGRepresentation(newImage, 1)!//picks down
            imageData = dataForJPEGFile.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString
            let imageSize: Int = imageData.length
            print("size of image in KB: %f ", Double(imageSize) / 1024.0)
            return imageData as String
        }
        else{
            return ""
        }
    }
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        var neededwidth:CGFloat = 640
        if UIDevice.current.userInterfaceIdiom == .pad {
        } else {
            neededwidth = 1024
        }
        var newImage = UIImage()
        if image.size.height > 0 || image.size.width > 0 {
            let scale = neededwidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: neededwidth, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: neededwidth, height: newHeight))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    ////////////////////
    //parse
    func parseJsonToInt(_ intToParse:AnyObject)->Int
    {
        let c = intToParse
        let int:String = (c.description)!
        if let checkIfParse = Int(int)
        {
            return checkIfParse
        }
        return 0
    }
    func parseJsonToBool(_ intToParse:Bool)->Int
    {
        let c = intToParse
        if c == true {
        return 1
        }
        return 0
    }
    
    func parseJsonToFloat(_ floatToParse:AnyObject)->Float
    {
        let num = floatToParse
        let floatNum:String = (num.description)
        if (floatNum as NSString).floatValue != 0
        {
            return (floatNum as NSString).floatValue
        }
        return 0
        
        //        if (floatToParse.text) != nil
        //        {
        //        if (floatToParse.text as NSString).floatValue != 0
        //        {
        //            return (floatToParse.text as NSString).floatValue
        //        }
        //        }
        //        return 0
    }
    
    func parseJsonToDouble(_ doubleToParse:AnyObject)->Double
    {
        let num = doubleToParse
        let doubleNum:String = (num.description)
        if (doubleNum as NSString).doubleValue != 0
        {
            return (doubleNum as NSString).doubleValue
        }
        return 0
    }
    
    func parseJsonToString (_ stringToParse:AnyObject)-> String
    {
        //   if (stringToParse.isKindOfClass(NSNull.cl))
        let c:String = stringToParse.description
        if c == "<null>"
        {
            return ""
        }
        else if let checkIfParse:String = c
        {
            return checkIfParse
        }
        // if let string
        // {
        // return string
        //}
        return ""
    }
    
    func getDateFromString(_ dateString: String)->Date
        //NSString
    {
        //       let date1 = Global.sharedInstance.cutStringBySpace(dateString, strToCutBy: " ")
        var date = Date()
        if dateString != ""
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            //\\ dateFormatter.dateStyle = .ShortStyle
            if let _ = dateFormatter.date(from: dateString)
            {
                date = dateFormatter.date(from: dateString)!
            }
            
        }
        return date
    }
    func getDateHourMinuteFromString(_ dateString: String)->Date
        //NSString
    {
        //       let date1 = Global.sharedInstance.cutStringBySpace(dateString, strToCutBy: " ")
        var date = Date()
        if dateString != ""
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            //\\ dateFormatter.dateStyle = .ShortStyle
            if let _ = dateFormatter.date(from: dateString)
            {
                date = dateFormatter.date(from: dateString)!
            }

        }
        return date
    }
    //ממיר דייט לדייט לשליחה לשרת
    func convertNSDateToString(_ dateTOConvert:Date)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //let dateStr = dateFormatter.stringFromDate(dateTOConvert)
        
        var myDateString = String(Int64(dateTOConvert.timeIntervalSince1970 * 1000))
        myDateString = "/Date(\(myDateString))/"
        
        
        return myDateString
    }
    func convertNSDateToStringMore(_ dateTOConvert:Date)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //let dateStr = dateFormatter.stringFromDate(dateTOConvert)
        
        var myDateString = String(Int64(dateTOConvert.timeIntervalSince1970 * 1000))
     //   myDateString = "/Date(\(myDateString)"+"+0300)/"
         myDateString = "/Date(\(myDateString))/"
        
        
        return myDateString
    }
    func getTimeZoneFromDateString(_ dateString: String)-> Int {
         var fromtimeZone:Int = 0
        if dateString != ""
        {
            let stringPLus:String = "+"

            let leftparenthesisClosure:String = "("



            if dateString.range(of: leftparenthesisClosure) != nil {
                //\\     print("exists ( ")
                var fullName = dateString.components(separatedBy: "(")

                if let _:String = fullName[1] as String? {
                    let lastName: String? = fullName[1]


                    if lastName!.range(of: stringPLus) != nil {
                        //\\    print("exists +")
                        var fullNameArr = lastName!.components(separatedBy: "+")
                        if fullNameArr.count > 1 {
                            let timezoneString : String? =  fullNameArr[1]
                            if timezoneString!.count >= 4 {
                                let myInt = Int(String(timezoneString![1]))
                              //  print("timezone \(myInt)")
                                if myInt > 0 {
                                    fromtimeZone = myInt!
                                }
                            }
                        }
                    }
                }
            }
        }
                       return fromtimeZone
    }
    func getStringFromDateString(_ dateString: String)-> Date
    {
        //JMODE FIX
        //"/Date(1454097600000+0200)/" or
        //EVENT_DICT.fromHour
        //"/Date(1486679940000)/"
        if dateString != ""
        {
            let stringPLus:String = "+"
            let rightparenthesisClosure:String = ")"
            let leftparenthesisClosure:String = "("
            let blankSpace:String = " "
            
            
            if dateString.range(of: leftparenthesisClosure) != nil {
                //\\     print("exists ( ")
                var fullName = dateString.components(separatedBy: "(")
                var myDouble:Double = Double()
                var fromtimeZone:Int = 0
                var date:Date = Date()
                if let _:String = fullName[1] as String? {
                    let lastName: String? = fullName[1]
                    
                    
                    if lastName!.range(of: stringPLus) != nil {
                        //\\    print("exists +")
                        var fullNameArr = lastName!.components(separatedBy: "+")
                        let lastNam: String? = fullNameArr[0]
                        if fullNameArr.count > 1 {
                            let timezoneString : String? =  fullNameArr[1]
                            if timezoneString!.count >= 4 {
                                let myInt = Int(String(timezoneString![1]))
                             //   print("timezone \(myInt)")
                                if myInt > 0 {
                                    fromtimeZone = myInt!
                                }
                            }
                        }
                        if lastNam?.count > 0 {
                            myDouble = Double(lastNam!)!
                            if let _:Date =  Date(timeIntervalSince1970: (myDouble)/1000.0) as Date? {
                                date = Date(timeIntervalSince1970: myDouble/1000.0)
//                                if fromtimeZone > 0 {
//                                    let calendar = Foundation.Calendar.current
//                                    let datex = calendar.date(byAdding: .minute, value: fromtimeZone * 60, to: date)
//                                    date = datex!
//                                }
                                return date
                            }
                            
                        }
                    }
                        
                    else {
                        if lastName!.range(of: rightparenthesisClosure) != nil{
                            //\\          print("exists )")
                            var fullNameArr = lastName!.components(separatedBy: ")")
                            let lastNam: String? = fullNameArr[0]
                            if lastNam?.count > 0 {
                                myDouble = Double(lastNam!)!
                                if let _:Date =  Date(timeIntervalSince1970: (myDouble)/1000.0) as Date? {
                                    date = Date(timeIntervalSince1970: myDouble/1000.0)
                                    return date
                                }
                                
                            }
                        }
                    }
                }
            } else {
                //it a simple string like in 2017-02-10 10:54:30 +0000
                if dateString.range(of: blankSpace) != nil {
                    //\\         print("exists blankspace ")
                    var fullName = dateString.components(separatedBy: " ")
                    var myDouble:Double = Double()
                    var date:Date = Date()
                    if let _:String = fullName[0] as String? {
                        let lastName: String? = fullName[0]
                        if lastName?.count > 0 {
                            myDouble = Double(lastName!)!
                            if let _:Date =  Date(timeIntervalSince1970: (myDouble)/1000.0) as Date? {
                                date = Date(timeIntervalSince1970: myDouble/1000.0)
                                return date
                            }
                        }
                    }
                }
            }
        }
        
        return Date()
    }
    
    func setContacts() {
       
        Global.sharedInstance.contactList = []
        let store = CNContactStore()
        print(CNContactStore.authorizationStatus(for: .contacts).hashValue)
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .denied:
            print("ask")
          
            
        case .authorized:
            print("access granted")
            // getContactNames()
           // print("lazy \(self.contacts)")
//            var contactsFull: [CNContact] = []
//            contactsFull = self.contacts
//            /////// JMODE PLUS NEW iOS 10 CONTACT LOCATIONS ////////
//            /*
//             <CNContact: 0x10327a090: identifier=76C1AB4E-65D4-4874-8A85-694509F2679F, givenName=Ioan, familyName=Ungureanu, organizationName=, phoneNumbers=(
//             "<CNLabeledValue: 0x17087dc40: identifier=000D8366-2C9F-4E93-ADB4-08CE545BDD1A, label=_$!<Home>!$_, value=<CNPhoneNumber: 0x174229860: countryCode=ro, digits=0726744222>>"
//             ), emailAddresses=(
//             ), postalAddresses=(not fetched)>
//             */
//            var indexForUserid : Int = 0
//            
//            for record:CNContact in contactsFull
//            {
//                phone = []
//                let contactPerson: CNContact = record
//                var givenName = ""
//                var familyName = ""
//                var numecompus = ""
//                var MobNumVar = ""
//                
//                givenName = contactPerson.givenName;
//                familyName = contactPerson.familyName;
//                numecompus = givenName + " " + familyName
//                if contactPerson.phoneNumbers.count > 0 {
//                    //person has 1 or more numbers
//                    for i in 0..<contactPerson.phoneNumbers.count {
//                        MobNumVar = (contactPerson.phoneNumbers[i].value ).value(forKey: "digits") as! String
//                        let cleaned =  cleanPhoneNumber(MobNumVar)
//                        if cleaned.characters.count > 2 {
//                            let numertocompare = cleaned
//                            let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
//                            let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
//                            if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5") {
//                          
//                                //ignore all bad numbers
//                                print("bad number? \(numertocompare)")
//                            } else {
//                                //all this person numbers go to _allPHONES:phone array see below
//                                if !phone.contains(cleaned)   {
//                                    phone.append(cleaned)
//                                }
//                            }
//                        }
//                    }
//                    if phone.count > 0 {
//                       indexForUserid = indexForUserid + 1
//                        let firstvalidphone = phone[0] // only first valid number found is added to _nvPhone
//                        let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: true, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:phone,_nvNickName:numecompus)
//                        if !Global.sharedInstance.contactList .contains(c) {
//                            Global.sharedInstance.contactList.append(c)
//                        }
//                    }
//                }
//            }
//            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "nvLastName", ascending: true)
//            let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvLastName < $1.nvLastName })
//            Global.sharedInstance.contactList = sortedByFirstNameSwifty 
//            
//            print("ce are aici iar \(Global.sharedInstance.contactList )")
                    ////    END PARSING ////
        case .notDetermined:
                        print("requesting access...")
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded
                    else{
                        print("error")
                        return
                }
                print("no try access granted")
                //  self.getContactNames()
                
                
            }
        default:
            print("Not handled")
                  }
      
    }
    
    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }()
    
    
    //    func setContactsOLD()
    //    {
    //              print("Succesful.")
    //            if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined)
    //            {
    //                  print("requesting access...")
    //                ABAddressBookRequestAccessWithCompletion(addressBook,{success, error in
    //                    if success {
    //                        self.getContactNames()
    //                    }
    //                    else
    //                    {
    //                          print("error")
    //                    }
    //                })
    //
    //            }
    //            else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted)
    //            {
    //                  print("access denied")
    //            }
    //            else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized)
    //            {
    //                  print("access granted")
    //                getContactNames()
    //            }
    //    }
    //
    //    func getContactNames()
    //    {
    //        //\\ setContactsNEW()
    //        var indexForUserid : Int = 0
    //
    //        let contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
    //        //var index:Int = 0
    //        //var dicPerContact = Array<Dictionary<String, String>>()
    //        //var dicContact = Dictionary<String, Array<Dictionary<String, String>>>()
    //        for record:ABRecordRef in contactList
    //        {
    //            let contactPerson: ABRecordRef = record
    //            let phones : ABMultiValueRef = ABRecordCopyValue(record,kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValueRef
    //
    //
    //            for numberIndex : CFIndex  in 0 ..< 1
    //            {
    //
    //                let phoneUnmaganed = ABMultiValueCopyValueAtIndex(phones, numberIndex)
    //                if let _ = phoneUnmaganed
    //                {
    //                    let phoneNumber : NSString = phoneUnmaganed.takeUnretainedValue() as! NSString
    //                    let newString = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
    //
    //                    phone.append("\(phoneNumber)")
    //                    phone.append(newString)
    //             /*
    //                     first &  last name
    //
    //                     */
    //                    let firstNameJ: String = (ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty) != nil) ?  (ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty).takeRetainedValue() as! String) : " "
    //                    let lastNameJ: String = (ABRecordCopyValue(contactPerson, kABPersonLastNameProperty) != nil) ?  (ABRecordCopyValue(contactPerson, kABPersonLastNameProperty).takeRetainedValue() as! String) : " "
    //                    //\\print ("found first name \(firstNameJ)")
    //                    //\\print ("\n found last name \(lastNameJ)")
    //                    //\\print ("\nand  phone \(phoneNumber)")
    //
    //                    let contactName: String = (ABRecordCopyCompositeName(contactPerson) != nil) ? (ABRecordCopyCompositeName(contactPerson).takeRetainedValue()as String) : " "
    //
    //                    data.append(contactName)
    //                    let myStringArr = contactName.componentsSeparatedByString(" ")
    //                    var name: String = ""
    //                    for str in myStringArr
    //                    {
    //                        name += str + " "
    //                    }
    //
    //                    //JMODE + IMPORTANT !!!
    //                 /*   nvFirstName  = ""
    //                    nvLastName = "" */
    //                    let c:Contact = Contact(_iUserId: indexForUserid++, _iUserStatusType: 1565, _nvContactName: name, _nvPhone: newString as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: true, _nvFirstName: firstNameJ, _nvLastName: lastNameJ)
    //                    if !Global.sharedInstance.contactList .contains(c) {
    //                    Global.sharedInstance.contactList.append(c)
    //                    }
    //                }
    //            }
    //        }
    //
    //        //bad coding below make sure you verify key nvContactName
    //        var myarray = []
    //        myarray = Global.sharedInstance.contactList
    //        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "nvLastName", ascending: true)
    //        var sortedResults: NSArray = myarray.sortedArrayUsingDescriptors([descriptor])
    //        Global.sharedInstance.contactList = sortedResults as! Array<Contact>
    //
    //    }
    
    //פונקציה המאתחלת במערך את כל השעות הפנויות לשבוע המוצג
    func setFreeHours(_ currentDate:Date,dayOfWeek:Int)
    {
        
        freeHoursForWeek[dayOfWeek] = []
        for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count
        {
            let dateDt = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate)
            //היום שיש בו שעות פנויות
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let chosenDate = dateFormatter.string(from: currentDate)
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
            let dateFreeDayStr = dateFormatter.string(from: dateDt)
            
            if chosenDate == dateFreeDayStr
            {
                freeHoursForWeek[dayOfWeek].append(Global.sharedInstance.getFreeDaysForService[i])
            }
        }
    }
    
    //פונקציה המאתחלת במערך את כל האירועים של ביזר לשבוע המוצג
    func getBthereEvents(_ currentDate:Date,dayOfWeek:Int)
    {
        bthereEventsForWeek[dayOfWeek] = []
        
        //מעבר על כל האירועים של ביזר ושמירת האירועים שביום שנשלח
        for item in Global.sharedInstance.ordersOfClientsArray
        {
            let btEvent = item
            
            let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: currentDate)
            
            let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: btEvent.dtDateOrder as Date)
            
            yearToday =  componentsCurrent.year!
            monthToday = componentsCurrent.month!
            dayToday = componentsCurrent.day!
            
            let yearEvent =  componentsEvent.year
            let monthEvent = componentsEvent.month
            let dayEvent = componentsEvent.day
            
            if yearEvent == yearToday && monthEvent == monthToday && dayEvent == dayToday
            {
                bthereEventsForWeek[dayOfWeek].append(btEvent)
            }
        }
    }
    
    
    
    //פונקציה זו מקבלת את כל האירועים הנמצאים בלוח של המכשיר שלי
    func getEventsFromMyCalendar()
    {
        eventList = []
        // Override point for customization after application launch.
        let store: EKEventStore = EKEventStore()
        
//        store.requestAccess(to: .event, completion: {
//            granted, error in
//
//            // put your handler code here
//        })
//
        // Get the appropriate calendar
        let calendar: Foundation.Calendar = Foundation.Calendar.current
        // Create the start date components
        var oneDayAgoComponents: DateComponents = DateComponents()
        //how many days ago to show the events of the calendar
        oneDayAgoComponents.day = -90
        let oneDayAgo: Date = (calendar as NSCalendar).date(byAdding: oneDayAgoComponents, to: Date(), options: [])!
        // Create the end date components
        var oneYearFromNowComponents: DateComponents = DateComponents()
        oneYearFromNowComponents.year = 1
        let oneYearFromNow: Date = (calendar as NSCalendar).date(byAdding: oneYearFromNowComponents, to: Date(), options: [])!
        
        // Create the predicate from the event store's instance method
        let predicate: NSPredicate = store.predicateForEvents(withStart: oneDayAgo, end: oneYearFromNow, calendars: nil)
        
        // Fetch all events that match the predicate
        let events: [EKEvent] = store.events(matching: predicate)
        
        for  e:EKEvent in events
        {
            
            if !(e.notes == "Bthere")
            {
                eventList.append(e)
                //\\    print("what if e\(e.title)")
            }
        }
        
    }
    func changeSizeOfLabelByDevice(_ lbl:UILabel , size:CGFloat)
    {
        lbl.font = UIFont(name: (lbl.font.fontName) as! String, size: size)!
        
    }
    func changeSizeOfButtonByDevice(_ btn:UIButton , size:CGFloat)
    {
        btn.titleLabel?.font = UIFont(name: (btn.titleLabel?.font?.familyName)!, size: 13)!
        
    }
    func uniq<S : Sequence, T : Hashable>(_ source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    func makeCall(_ constactNumber : NSString)
    {
        print("constactNumber: \(constactNumber)")
        if(constactNumber.length == 0)
        {
            print("Contact number in not valid")
            Alert.sharedInstance.showAlertDelegate("INVALID_OCASIONAL_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            
        }
        else
        {
            let CleanconstactNumber = constactNumber.replacingOccurrences(of: " ", with: "")
            if let phoneCallURL:URL = URL(string: "tel://\(CleanconstactNumber)")
            {
                if (UIDevice.current.model.range(of: "iPad") != nil)
                {
                    Alert.sharedInstance.showAlertDelegate("NO_FEATURE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    
                } else
                {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL))
                    {
                        let mobileNetworkCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
                        if( mobileNetworkCode == nil)
                        {
                            Alert.sharedInstance.showAlertDelegate("NO_SIM_SIGNAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else
                        {
                            application.openURL(phoneCallURL);
                        }
                    }
                }
            }
        }
    }
    func logoutUSER(){
        Global.sharedInstance.defaults.removeObject(forKey: "verificationPhone")
        Global.sharedInstance.defaults.set(true, forKey: "LogOut")
        Global.sharedInstance.defaults.set(-1, forKey: "idSupplierWorker")
        Global.sharedInstance.defaults.set(0, forKey: "ismanager")
        Global.sharedInstance.defaults.set(1, forKey: "issimpleCustomer") //false all
        Global.sharedInstance.defaults.set(0, forKey: "isemploye")
        Global.sharedInstance.defaults.removeObject(forKey: "currentClintName")
        Global.sharedInstance.defaults.removeObject(forKey: "currentUserId")
        Global.sharedInstance.defaults.removeObject(forKey: "providerDic")
        Global.sharedInstance.defaults.removeObject(forKey: "isSupplierRegistered")
        Global.sharedInstance.defaults.removeObject(forKey: "supplierNameRegistered")
        Global.sharedInstance.defaults.set(0, forKey:"ISFROMSETTINGS")
        Global.sharedInstance.defaults.synchronize()
        Global.sharedInstance.isFIRSTREGISTER = false
        let manager = FBSDKLoginManager()
        manager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        Global.sharedInstance.defaults.synchronize()
        Global.sharedInstance.providerID = 0 // !IMPORTANT remove all references to previous logged in user in case of bussiness
        Global.sharedInstance.didOpenBusinessDetails = false
        Global.sharedInstance.getEventsFromMyCalendar()
        let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetSysAlertsList(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                let sysAlert:SysAlerts = SysAlerts()
                    if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                if Global.sharedInstance.arrSysAlerts.count != 0
                {
                    Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                    Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                    Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                    Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                    Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                    Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
            })
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        window.makeKeyAndVisible()
    }
    func reloadrootview(){
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        //Hebrew
        let USERDEF = UserDefaults.standard
        if  USERDEF.object(forKey: "CHOOSEN_LANGUAGE") == nil {
            USERDEF.set(0, forKey: "CHOOSEN_LANGUAGE")
            USERDEF.synchronize()
        }
        //now get sys alerts services and categs
        appDelegate.reloadsyscategandalerts()
        if Global.sharedInstance.currentUser.iUserId > 0 && Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil  {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            appDelegate.rtlRELOAD()
         //   appDelegate.setHELPSCREENS()
            Global.sharedInstance.isFLIPPINGFORMLANGUAGE = true
            Global.sharedInstance.isProvider = false //in order to show orange etc
            Global.sharedInstance.whichReveal = false
            self.fromChangeLanguage = true
            let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
            vc.myformchangelanguage = true
            frontviewcontroller?.pushViewController(vc, animated: false)
            
            //initialize REAR View Controller- it is the LEFT hand menu.
            
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            
            appDelegate.window!.rootViewController = mainRevealController
            appDelegate.window?.makeKeyAndVisible()
            
            
        }
        else
        {
            
            appDelegate.rtlRELOAD()
       //     appDelegate.setHELPSCREENS()
            Global.sharedInstance.isFLIPPINGFORMLANGUAGE = true
            Global.sharedInstance.isProvider = false //in order to show orange etc
            Global.sharedInstance.whichReveal = false
            self.fromChangeLanguage = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let vc = storyboard.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
            vc.myformchangelanguage = true
            frontviewcontroller?.pushViewController(vc, animated: false)
            
            //initialize REAR View Controller- it is the LEFT hand menu.
            
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            
            
            appDelegate.window!.rootViewController = mainRevealController
            appDelegate.window?.makeKeyAndVisible()
            
            
        }
    }
    func cleanPhoneNumber(_ nvPhone:String) -> String {
        var  nvTmpPN2:String = ""
        var modedphone = nvPhone
        if  nvPhone != ""
        {
            //add to check if number has country code
            do {
                let phoneNumber = try phoneNumberKit.parse(nvPhone)
                let phoneNumberCustomDefaultRegion = try phoneNumber.countryCode
                if phoneNumberCustomDefaultRegion != 0 {
                    print ("phoneNumberCustomDefaultRegion \(phoneNumberCustomDefaultRegion)")
                    let newString = modedphone.stringByReplacingFirstOccurrenceOfString(target: String(phoneNumberCustomDefaultRegion), withString: "0")
                    modedphone = newString
                    print("formated number is \(modedphone)")
                }
            }
            catch {
                print("Generic parser error")
            }
            for char in (modedphone.characters)
            {
                if (char >= "0" && char <= "9") || char == "*"
                {
                    let c:Character = char
                    nvTmpPN2 = nvTmpPN2 + String(c)
                }
            }
        }
        return nvTmpPN2
    }
    
    
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                dic["iUserId"] = y as AnyObject
            }
            
            api.sharedInstance.GetNewsAndUpdates(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                    Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else{
                    if let abcd = RESPONSEOBJECT["Result"] as? String {
                        self.newslabel = abcd
                        
                    }
                }
                }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
            })
        }
    }
    
}

extension String {
    func localized(_ lang:String) ->String {
        //read bundle saved by user
        let USERDEF = UserDefaults.standard
        var langdefault = "en"
        var langarray = USERDEF.object(forKey: "AppleLanguages") as? Array<String>
        if   USERDEF.object(forKey: "AppleLanguages") == nil {
            //english
            langdefault = "en"
            USERDEF.set([langdefault], forKey: "AppleLanguages")
            USERDEF.synchronize()
        } else {
            if langarray?.count > 0 {
                langdefault = langarray![0]
            }
        }
        let path = Bundle.main.path(forResource: langdefault, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return  NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "") 
        
    }
}
extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
}
    extension String {
        func isRussiantext(title:String) -> Bool {
        var isRussiantext:Bool = false
        let scalars = title.unicodeScalars
        for v in scalars {
        // print(v.value)
        let unicodeValue = v.value
        if (unicodeValue > 1024 || unicodeValue < 1279)    {
        print("isRussiantext.... \(unicodeValue)")
        isRussiantext = true
       // break
        }
        }
            return isRussiantext
        }
    }

