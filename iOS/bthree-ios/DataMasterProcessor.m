//
//  DataMasterProcessor.m
//
//
//  Created by Ioan Ungureanu far away in future
//  Copyright (c) 2016 BThere. All rights reserved.
//

#import "DataMasterProcessor.h"
#import "DB_template.h"
#import "FMDatabaseAdditions.h"
@interface DataMasterProcessor()

@end
@implementation DataMasterProcessor
//1 -(NSArray*)getUser; //toate top din db
//-(BOOL)insertUser:(NSString*)phonenumber :(NSString*)avazut; CREATE TABLE "useri" ("numaruser" VARCHAR PRIMARY KEY  NOT NULL , "afisat" VARCHAR)
//string is empty
-(BOOL)MyStringisEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str isEqualToString:@"(null)"]|| [str isEqualToString:@"<null>"] || [str isEqualToString:@"null"] ||str==nil){
        return YES;
    }
    return NO;
}
//CREATE TABLE "stiri" ("idstire" VARCHAR UNIQUE ,
//                      "time" VARCHAR,
//                      "title" VARCHAR,
//                      "url" VARCHAR,
//                      "tip" VARCHAR,    // 0=new    1=top  2=saved for later
//                      "status" VARCHAR) // 0=unread 1=read 2=fav
//se putea face o metoda cu parametru 0 1 2 dar am preferat sa fie explicite aici
-(NSArray*)getUser :(NSString *) numberphone{
    NSArray* data;
    NSString* query=@"";
    DB_template *db = [[DB_template alloc] initDB];
    query=[NSString stringWithFormat:@"SELECT * FROM useri WHERE `numaruser`=='%@' ", numberphone];// LIMIT 10 for fast test
    
    data=[db getArrayForQuerry:query];
    NSLog(@"my dd  %@ %@",numberphone, data);
    [db deallocDB];
    return data;
}


-(BOOL)insertUser:(NSString*)phonenumber { // local users in sqlite
   
    
      NSString *vazut =@"1";
  
    BOOL ok =NO;
    DB_template* db = [[DB_template alloc] initDB];
    [db.db open];
    [db.db setShouldCacheStatements:YES];

    static NSString *insertSQLStatment = @"REPLACE INTO useri (`numaruser`,`afisat`) VALUES ( ?, ?)";
    [db.db beginTransaction];
        if(![self MyStringisEmpty:phonenumber]) {
       [db.db executeUpdate:insertSQLStatment withArgumentsInArray:@[phonenumber,vazut]];
        } else {
            NSLog(@"no id no title no insert");
        }
 
    ok= [db.db commit];
NSLog(@"am inserat user %i %@",ok, phonenumber);
    [db.db close];
    return ok;
}




////////////////////////////////////////////////


@end
