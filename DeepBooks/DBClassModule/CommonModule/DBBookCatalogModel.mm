//
//  DBBookCatalogModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/5.
//

#import "DBBookCatalogModel.h"
#import "DBSQLManager.h"
//#import <WCDB/WCDB.h>
#import "WCDBObjc.h"
@interface DBBookCatalogModel () <WCTTableCoding>

@end

@implementation DBBookCatalogModel


WCDB_IMPLEMENTATION(DBBookCatalogModel)
WCDB_SYNTHESIZE(path)
WCDB_SYNTHESIZE(url)
WCDB_SYNTHESIZE(is_content)
WCDB_SYNTHESIZE(name)
WCDB_SYNTHESIZE(updated_at)
WCDB_SYNTHESIZE(title)

WCDB_PRIMARY(path)


+ (NSArray *)getBookCatalogs:(NSString *)catalogForm{
    return [DBSQLManager getAllObjsWithClass:self.class name:catalogForm];
}

- (BOOL)updateCatalogsWithCatalogId:(NSString *)catalogForm{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksCatalog append:catalogForm];
    return [DBSQLManager insertObj:self name:name];
}

+ (BOOL)updateCatalogs:(NSArray <DBBookCatalogModel *>*)catalogs catalogForm:(NSString *)catalogForm{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksCatalog append:catalogForm];
    return [DBSQLManager insertObjs:catalogs name:name];
}

+ (BOOL)deleteCatalogsForm:(NSString *)catalogForm{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksCatalog append:catalogForm];
    return [DBSQLManager removeTableName:name];
}

@end
