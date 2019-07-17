//
//  DB_template.m
//
//
//  All rights reserved.
//

#import "DB_template.h"
#import "DataMasterProcessor.h"




@implementation DB_template
@synthesize TableName,db;
-(BOOL)MyStringisEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:@"NULL"]||[str isEqualToString:@"(null)"]|| [str isEqualToString:@"<null>"] || [str isEqualToString:@"null"] ||str==nil){
        return YES;
    }
    return NO;
}
+(void)setDataBaseName:(NSString*)name{
    if(!name) {
          name =@"localusers.sqlite";
    }
    NSUserDefaults* prefs=[NSUserDefaults standardUserDefaults];
    [prefs setObject:name forKey:@"database_file_name"];
    [prefs synchronize];
}
- (NSString *)applicationDocumentsDirectory {
 /*   return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0]; */
  //  NSURL *ghomedir = [NSURL URLWithString:cacheDirectory];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *newpath = [libraryPath stringByAppendingString:@"/com.bthere.new"];
    NSLog(@"ce cale %@", newpath);
    return libraryPath;
}
-(void)updateNames{
    NSString* databaseFileName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"database_file_name"]];
    BOOL egol = [self MyStringisEmpty:databaseName];
   if(!egol){
        databaseName = databaseFileName;
    } else {
        databaseName =@"localusers.sqlite";
        NSUserDefaults *no =   [NSUserDefaults standardUserDefaults];
        [no setObject:databaseName forKey:@"database_file_name"];
        [no synchronize];
    }
    databasePath = [[NSString alloc]init];
    NSString *documentsDir = [[NSString alloc]init];
    documentsDir = [NSString stringWithFormat:@"%@",[self applicationDocumentsDirectory]];
    BOOL egol1 = [self MyStringisEmpty:documentsDir];
    if(!egol1) {
    databasePath = [[self applicationDocumentsDirectory]
                      stringByAppendingPathComponent:databaseName];
    } else {
        NSLog(@"Eroare de path NSDocumentDirectory");
    }
    [self checkAndCreateDatabase];
    
    db = [FMDatabase databaseWithPath:databasePath];
    if(db_debug==1)
    {
        [db setLogsErrors:TRUE];
        [db setTraceExecution:TRUE];
    }else
    {
        [db setLogsErrors:FALSE];
        [db setTraceExecution:FALSE];
    }
    
    if (![db open]) {
        if(db_debug) NSLog(@"Could not open db.");
    }else {
        if(db_debug) NSLog(@"DB Open....");
    }

}



-(void) checkAndCreateDatabase{
    BOOL success;
    BOOL result =NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    if(success) {
        return;
    }
    
    NSString* databaseFileName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"database_file_name"]];
    BOOL egol = [self MyStringisEmpty:databaseName];
    NSLog(@"databaseFileName %@",databaseFileName);
    if(!egol){
        databaseName = databaseFileName;//@"localusers.sqlite";
    } else {
        databaseName =@"localusers.sqlite";
    }
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    if([[NSFileManager defaultManager] fileExistsAtPath:databasePathFromApp] ) {
        NSError * err = NULL;
        NSFileManager * fm = [[NSFileManager alloc] init];
        BOOL EGOL = [self MyStringisEmpty:databasePath];
        if(!EGOL) {
            result = [fm copyItemAtPath:databasePathFromApp toPath:databasePath error:&err];
            if(!result) {
                NSLog(@"Error: %@", err);
            } else {
                result =YES;
                NSLog(@"s-a copiat DB");
            }
        }
    }
    else { NSLog(@"no file here to process!");
    }
}



-(void)dumpCurrentDatabase{

    NSFileManager* fileManager = [NSFileManager defaultManager];

    if([fileManager fileExistsAtPath:databasePath]){

        NSError* error;

        [fileManager removeItemAtPath:databasePath error:&error];

    }

}

-(id)initDB
{ 
    self=[super init];
   [self updateNames];
       return self;
}

-(void) flush_table
{ 
    NSString* qry=[NSString stringWithFormat:@"DELETE FROM %@",TableName];
    [db executeUpdate:qry];
    
}
-(void)flushTable:(NSString*)table{
    NSString* qry=[NSString stringWithFormat:@"DELETE FROM %@",table];
    [db executeUpdate:qry];
    
}


-(void)transaction_begin
{
    [db beginTransaction];
}

-(void)transaction_rollback
{
    [db rollback];
}

-(void)transaction_commin
{
    [db commit];
}



-(void)deallocDB
{
    [db close];
}


-(BOOL)insertItem:(NSDictionary*)dic inTable:(NSString*)table{
    if(!dic){
        NSLog(@"%s data set %@ is empty",__func__,table);
        return YES;
    }
    NSMutableArray* colums=[[NSMutableArray alloc] initWithArray:[dic allKeys]];
    
    NSArray* tableColumns=[self getColumnsForTable:table];
    
    for (int i=0;i<[colums count];i++) {
        NSString* column=[colums objectAtIndex:i];
        BOOL ok=NO;
        for (NSString* col in tableColumns) {
            if([column isEqualToString:col]){
                ok=YES;
            }
        }
        if(!ok){
            [colums removeObjectAtIndex:i];
            i--;//just for extra care and more prefromance inexistence
        }
    }
    
    
    
    NSString* query = [NSString stringWithFormat:@"REPLACE INTO %@(",table];
    for (NSString* column in colums) {
        int index =(int)[colums indexOfObject:column];
        
        
        query=[query stringByAppendingString:column];
        if(index<[colums count]-1){
            query=[query stringByAppendingString:@", "];
        }
    }
    query=[query stringByAppendingString:@") VALUES ("];
    
    for(NSString* column in colums){
        query=[query stringByAppendingString:@"?"];
        if([colums indexOfObject:column]<[colums count]-1){
            query=[query stringByAppendingString:@", "];
        }
    }
    query=[query stringByAppendingString:@");"];
    
    
    NSMutableArray* row = [[NSMutableArray alloc] initWithCapacity:[colums count]];
    for(NSString* column in colums){
        [row addObject:[dic objectForKey:column]];
    }
    
    BOOL ok=YES;
    @try {
        ok=ok&&[db executeUpdate:query withArgumentsInArray:row];
    }
    @catch (NSException *exception) {
        NSLog(@"%s DB error %@",__func__,[exception debugDescription]);
    }
    return ok;
    
}


-(BOOL)insertArrayOfItems:(NSArray*)objects inTable:(NSString*)table{
    NSLog(@"%s %@",__func__,table);
    if(!(objects&&[objects count])){
        NSLog(@"%s data set %@ is empty",__func__,table);
        return YES;
    }
    
    //   NSLog(@"table : %@",table);
    
 
    
    NSMutableArray* colums=[[NSMutableArray alloc] initWithArray:[[objects objectAtIndex:0] allKeys]];
    NSMutableArray* tableColumns=[[NSMutableArray alloc] initWithArray:[self getColumnsForTable:table]];
    
    NSLog(@"tableColumns : %@",tableColumns);
    
    for (int i=0;i<[colums count];i++) {
        NSString* column=[colums objectAtIndex:i];
        BOOL ok=NO;
        for (NSString* col in tableColumns) {
            if([column isEqualToString:col]){
                ok=YES;
            }
        }
        if(!ok){
            [colums removeObjectAtIndex:i];
            i--;//just for extra care and more prefromance inexistence
        }
    }
     if([table isEqualToString:@"stiri"]){
        for (int i=0;i<[tableColumns count];i++) {
            NSString* column=[tableColumns objectAtIndex:i];
            for (NSString* col in colums) {
                if([column isEqualToString:col]){
                    [tableColumns removeObjectAtIndex:i];
                    i--;
                }
            }
        }
        
        NSLog(@"table columns : %@",tableColumns);
    }
       NSString* query = [NSString stringWithFormat:@"REPLACE INTO %@(",table];
    
    
    for (NSString* column in colums) {
        int index =(int)[colums indexOfObject:column];
        
        
        query=[query stringByAppendingString:column];
        if(index<[colums count]-1){
            query=[query stringByAppendingString:@", "];
        }
    }
    
    query=[query stringByAppendingString:@") VALUES ("];
    
    for(NSString* column in colums){
        query=[query stringByAppendingString:@"?"];
        if([colums indexOfObject:column]<[colums count]-1){
            query=[query stringByAppendingString:@", "];
        }
    }
    query=[query stringByAppendingString:@");"];
    NSMutableArray* dataSetToInsert=[[NSMutableArray alloc] initWithCapacity:[objects count]];
     for (NSDictionary* obj in objects) {
        NSMutableArray* row = [[NSMutableArray alloc] initWithCapacity:[colums count]];
        for(NSString* column in colums){
            if([obj objectForKey:column]){
                [row addObject:[obj objectForKey:column]];
            }else{
                [row addObject:@""];
            }
        }
        [dataSetToInsert addObject:row];
    }
    
    if([table isEqualToString:@"user_cards"]){
        NSLog(@"data set to insert : %@",dataSetToInsert);
        
        
    }
    
    
  
    
    // }
    
    
    
    
    
    return YES;
    
}


-(BOOL)keyExists:(NSArray*) table_names key:(NSString *) name{
    for(int i=0; i < [table_names count]; i++){
        NSDictionary * dict = [table_names objectAtIndex:i];
        if([name isEqualToString:[NSString stringWithFormat:@"%@",dict[@"name"]]]){
            return YES;
        }
    }
    
    
    return NO;
}



-(NSArray*)getArrayFromTable:(NSString*)table columnsSet:(NSArray*)columns_set withConditions:(NSDictionary*)conditions{
    
    
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ ",table];
    
    if(columns_set){
        NSString* columns = @"";
        BOOL has_1_column=NO;
        for (NSString* column in columns_set) {
            if(has_1_column){
                query = [query stringByAppendingString:@", "];
                
            }
            columns = [columns stringByAppendingFormat:@"%@",column];
        }
        
        
        query = [NSString stringWithFormat:@"SELECT %@ FROM %@ ",table,columns];
    }else{
        query = [NSString stringWithFormat:@"SELECT * FROM %@ ",table];
    }

    if(conditions){
        NSDictionary* where= [conditions objectForKey:@"where"];
        BOOL has_1_condition=NO;
        if(where){
            query = [query stringByAppendingString:@" WHERE "];
            NSArray* where_keys=[where allKeys];
            for (NSString* operand in where_keys) {
                NSDictionary* condition_type=[where objectForKey:operand];
                if(condition_type){
                    NSArray* condition_keys = [condition_type allKeys];
                    for (NSString* key in condition_keys) {
                        NSString* condition=[condition_type objectForKey:key];
                        if(condition){
                            if(has_1_condition){
                                query = [query stringByAppendingString:@" AND "];
                            }
                            query = [query stringByAppendingFormat:@"%@ %@ %@",key,operand,[condition_type objectForKey:key]];
                            has_1_condition=YES;
                        }
                    }
                }
            }
            
        }
        NSString* sort_column = [conditions objectForKey:@"sort_column"];
        if(sort_column){
            query=[query stringByAppendingFormat:@" ORDER BY %@ ",sort_column];
            NSString* sort_order = [conditions objectForKey:@"sort_order"];
            if(sort_order){
                query=[query stringByAppendingFormat:@" %@ ",sort_order];
            }
        }

        
    }
    

    FMResultSet* set=[db executeQuery:query];
    NSMutableArray* data=[[NSMutableArray alloc] init];
    while ([set next]) {
        [data addObject:[set resultDictionary]];
    }
    
    return data;
}

-(NSArray*)getArrayForQuerry:(NSString*)query{
    
    FMResultSet* set=[db executeQuery:query];
    NSMutableArray* data=[[NSMutableArray alloc] init];
    while ([set next]) {
        [data addObject:[set resultDictionary]];
    }
    
    return data;
}


-(NSArray*)getColumnsForTable:(NSString*)table{
    
    NSString* query = [NSString stringWithFormat:@"PRAGMA table_info(%@)",table];
    NSArray* result=[self getArrayForQuerry:query];
    NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:[result count]];
    for (NSDictionary* dic in result) {
        [array addObject:[dic objectForKey:@"name"]];
    }
    return array;
}

-(int)getLastInsertedRowId{
    int the_id=(int)[db lastInsertRowId];
    NSLog(@"%s %d",__func__,the_id);
    return the_id;
}

-(BOOL)checkForColumn:(NSString*)column inTable:(NSString*)table{
    if(column==nil||[column length]==0){
        NSLog(@"%s coulumn to check is bad %@",__func__,column);
        return YES;
    }
    NSArray* tableColumns=[self getColumnsForTable:table];
    BOOL ok=NO;
    for (NSString* tcol in tableColumns) {
        if([tcol isEqualToString:column]){
            ok=YES;
            break;
        }
    }
    return ok;
}

-(void)addColumn:(NSString*)column toTable:(NSString*)table havingType:(NSString*)type{
    NSString* querry=[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@;",table,column,type];
    [db executeUpdate:querry];
}




@end
