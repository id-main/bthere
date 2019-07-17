//
//  DB_template.m
// 

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


//1 on 0 off
#define db_debug 0
#define database_version 65
@interface DB_template : NSObject {
    FMDatabase* db;  
    NSString* TableName;
    NSString* databaseName;
    NSString* databasePath;
}

@property(nonatomic,retain) NSString* TableName;
@property(nonatomic,retain) FMDatabase* db;
+(void)setDataBaseName:(NSString*)name;
-(id)initDB;

-(void) deallocDB;
//fast insert
-(BOOL)insertItem:(NSDictionary*)dic inTable:(NSString*)table;
-(BOOL)insertArrayOfItems:(NSArray*)dic inTable:(NSString*)table;

//fast delete
-(void) flush_table;
-(void)flushTable:(NSString*)table;

-(void)transaction_begin;
-(void)transaction_rollback;
-(void)transaction_commin;
-(int)getLastInsertedRowId;

//used for quick simple queryes
-(NSArray*)getArrayFromTable:(NSString*)table columnsSet:(NSArray*)columns_set withConditions:(NSDictionary*)conditions;
-(NSArray*)getArrayForQuerry:(NSString*)query;
-(NSArray*)getColumnsForTable:(NSString*)table;
-(BOOL)checkForColumn:(NSString*)column inTable:(NSString*)table;
-(void)addColumn:(NSString*)column toTable:(NSString*)table havingType:(NSString*)type; //does not support default value or not null
-(BOOL)MyStringisEmpty:(NSString *)str;
@end
