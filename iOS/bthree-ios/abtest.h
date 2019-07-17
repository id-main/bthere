//
//  abtest.h
//  BThere
//
//  Created by BThere on 12/15/16.
//  Copyright © 2016 Webit. All rights reserved.
//

#ifndef abtest_h
#define abtest_h


#endif /* abtest_h */
#import <UIKit/UIKit.h>
#import <Foundation/foundation.h>
#import "AFSecurityPolicy.h"

@interface CheamaIOSObject : NSObject

-(NSString *) cheamaIOS;
-(BOOL)primaDatainApp;
-(NSString *)formatStringWithoutCommas :(NSString *)mystr;
-(AFSecurityPolicy*)customSecurityPolicy :(int )WHICHDOMAIN;
-(NSArray *) CERLOCAL :(int )WHICHDOMAIN;
@end
