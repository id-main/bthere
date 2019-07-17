//
//  DataMasterProcessor.h
/********************* db define ************************
 CREATE TABLE "stiri" ("idstire" VARCHAR UNIQUE ,
 "time" VARCHAR,
 "title" VARCHAR,
 "url" VARCHAR,
 "tip" VARCHAR, 0 1 2 TOP NEW SAVED
 "status" VARCHAR)
// 0=unread 1=read 2=fav
 CREATE TABLE "main"."salvate" ("idstire" VARCHAR UNIQUE ,
 "time" VARCHAR,
 "title" VARCHAR,
 "url" VARCHAR,
 "tip" VARCHAR,
 "status" VARCHAR)
 ********************* db define ************************/

#import <Foundation/Foundation.h>

@interface DataMasterProcessor : NSObject{
   }
//local database with users phones
-(NSArray*)getUser:(NSString*)phonenumber; //toate top din db
-(BOOL)insertUser:(NSString*)phonenumber;
@end
