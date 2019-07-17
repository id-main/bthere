//
//  abtest.m
//  BThere
//
//  Created by BThere on 12/15/16.
//  Copyright © 2016 Webit. All rights reserved.
//
#import "abtest.h"
#import "AFSecurityPolicy.h"

@implementation CheamaIOSObject
-(NSString *) cheamaIOS {
    NSString *cheama = @"ABTESTING";

    return cheama;
}
- (AFSecurityPolicy*)customSecurityPolicy :(int )WHICHDOMAIN {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    NSString *cerPath = @"";
     if (WHICHDOMAIN == 0) {
    cerPath = [[NSBundle mainBundle] pathForResource:@"devbthere" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setValidatesDomainName:YES];
    [securityPolicy setPinnedCertificates:@[certData]];
     } else if (WHICHDOMAIN == 1) {
         cerPath = [[NSBundle mainBundle] pathForResource:@"qabthere" ofType:@"cer"];
         NSData *certData = [NSData dataWithContentsOfFile:cerPath];
         [securityPolicy setAllowInvalidCertificates:NO];
         [securityPolicy setValidatesDomainName:YES];
         [securityPolicy setPinnedCertificates:@[certData]];
     } else if (WHICHDOMAIN == 2) {
         cerPath = [[NSBundle mainBundle] pathForResource:@"bthere" ofType:@"cer"];
         NSData *certData = [NSData dataWithContentsOfFile:cerPath];
         [securityPolicy setAllowInvalidCertificates:NO];
         [securityPolicy setValidatesDomainName:YES];
         [securityPolicy setPinnedCertificates:@[certData]];
     }
    return securityPolicy;
    /*
     [policy setValidatesDomainName:NO];
     [policy setAllowInvalidCertificates:YES];
     self.securityPolicy = policy;
     self.securityPolicy.allowInvalidCertificates = YES;
     */
}
-(NSArray *) CERLOCAL :(int )WHICHDOMAIN {
    NSArray *REZULTAT = [[NSArray alloc] init];
    if (WHICHDOMAIN == 0) {
NSString *pathToCert = [[NSBundle mainBundle]pathForResource:@"devbthere" ofType:@"cer"];
NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
REZULTAT =  @[localCertificate];
    } else if (WHICHDOMAIN == 1) {
        NSString *pathToCert = [[NSBundle mainBundle]pathForResource:@"qabthere" ofType:@"cer"];
        NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
       REZULTAT =  @[localCertificate];
    } else if (WHICHDOMAIN == 2) {
        NSString *pathToCert = [[NSBundle mainBundle]pathForResource:@"bthere" ofType:@"cer"];
        NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
       REZULTAT =  @[localCertificate];
    }
    return REZULTAT;
}
-(NSString *)formatStringWithoutCommas :(NSString *)mystr {
    NSString *newStr =@"";
    if(mystr.length >2) {
        NSString *secondChar =[mystr substringToIndex:2];
        if([secondChar isEqualToString:@", "]) {
           newStr = [mystr substringWithRange:NSMakeRange(2, mystr.length -2)];
        } else {
        newStr = mystr;
        }
    } else {
          newStr = mystr;
    }
     return newStr;
}
-(BOOL)primaDatainApp {
    NSUserDefaults* prefs=[NSUserDefaults standardUserDefaults];
    if(![prefs objectForKey:@"E_LOGAT"]){
        [prefs setValue:@"0" forKey:@"E_LOGAT"];
        [prefs synchronize];
    }
    BOOL eprimadata =NO;
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"splash_firstb.c0d";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        eprimadata =YES;
        NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* fileName = @"splash_firstb.c0d";
        NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
            [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
            NSString *aString = @"1";
            [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
        } else {
            NSString *aString = @"1";
            [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
        }
    } else {
        eprimadata =NO;

    }
    NSLog(@"ddd %i", eprimadata);
    return eprimadata;
   
}

/* swift version
 func primaDatainApp() -> Bool {
 var prefs = UserDefaults.standard
 if !prefs.object(forKey: "E_LOGAT")! {
 prefs.setValue("0", forKey: "E_LOGAT")
 prefs.synchronize()
 }
 var eprimadata = false
 var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
 var fileName = "splash_firstb.c0d"
 var fileAtPath = URL(fileURLWithPath: filePath).appendingPathComponent(fileName).absoluteString
 if !FileManager.default.fileExists(atPath: fileAtPath) {
 eprimadata = true
 var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
 var fileName = "splash_firstb.c0d"
 var fileAtPath = URL(fileURLWithPath: filePath).appendingPathComponent(fileName).absoluteString
 if !FileManager.default.fileExists(atPath: fileAtPath) {
 FileManager.default.createFile(at: fileAtPath, contents: nil, attributes: nil)
 var aString = "1"
 aString.data(using: String.Encoding.utf8).write(toFile: fileAtPath, atomically: false)
 }
 else {
 var aString = "1"
 aString.data(using: String.Encoding.utf8).write(toFile: fileAtPath, atomically: false)
 }
 }
 else {
 eprimadata = false
 }
   print("ddd \(eprimadata)")
 return eprimadata
 }


*/

@end
