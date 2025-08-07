//
//  DBBookSourceModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBookSourceModel.h"
#import "DBSQLManager.h"
//#import <WCDB/WCDB.h>
#import "WCDBObjc.h"
@interface DBBookSourceModel ()<WCTTableCoding>

@end

@implementation DBBookSourceModel

WCDB_IMPLEMENTATION(DBBookSourceModel)
WCDB_SYNTHESIZE(updated_at)
WCDB_SYNTHESIZE(site_id)
WCDB_SYNTHESIZE(crawl_book_id)
WCDB_SYNTHESIZE(site_path)
WCDB_SYNTHESIZE(last_chapter_name)
WCDB_SYNTHESIZE(site_path_reload)
WCDB_SYNTHESIZE(choose)
WCDB_SYNTHESIZE(site_name)

WCDB_PRIMARY(site_path)

+ (NSArray *)getBookSources:(NSString *)sourceForm{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksSource append:sourceForm];
    return [DBSQLManager getAllObjsWithClass:self.class name:name];
}

+ (BOOL)updateBookSources:(NSArray <DBBookSourceModel *>*)bookSource sourceForm:(NSString *)sourceForm{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksSource append:sourceForm];
    return [DBSQLManager insertObjs:bookSource name:name];
}

@end
