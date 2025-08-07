//
//  DBSQLManager.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import "DBSQLManager.h"
#import "DBBookModel.h"
#import "DBBookSourceModel.h"
#import "DBBookCatalogModel.h"
static WCTDatabase *_wscb;
@implementation DBSQLManager

+ (WCTDatabase *)createDB{
    if (!_wscb) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingPathComponent:UIApplication.bundleName];
        _wscb = [[WCTDatabase alloc] initWithPath:path];
    }
    return _wscb;
}

+ (NSString *)tableNameFromType:(DBTableType)type{
    return [self tableNameFromType:type append:@""];
}

+ (NSString *)tableNameFromType:(DBTableType)type append:(NSString *)append{
    NSString *tableName = @"";
    if (!_wscb) [self createDB];
    
    if (![_wscb isOpened] && ![_wscb canOpen]) {
        NSLog(@"db打开失败");
        return tableName;
    }
    
    Class cls = DBBookModel.class;
    switch (type) {
        case DBTableBooksCollect:
            tableName = @"books_collect";
            break;
        case DBTableBooksReading:
            tableName = @"books_reading";
            break;
        case DBTableBooksSource:
        {
            tableName = append;
            cls = DBBookSourceModel.class;
            break;
        }
        case DBTableBooksCatalog:
        {
            tableName = append;
            cls = DBBookCatalogModel.class;
            break;
        }
        default:
            break;
    }
    if (tableName.length == 0) return nil;
    if (![_wscb tableExists:tableName]){
        BOOL isCreate = [_wscb createTable:tableName withClass:cls];
        if (!isCreate) {
            NSLog(@"创建表格失败");
            return tableName;
        }
    }

    return tableName;
}


+ (BOOL)insertObj:(WCTObject *)obj name:(NSString *)name{
    if (!obj || !name) return NO;
    return [self.createDB insertOrReplaceObject:(WCTObject *)obj intoTable:name];
}

+ (BOOL)insertObjs:(NSArray <WCTObject *>*)objs name:(NSString *)name{
    if (!objs || !name) return NO;
    return [self.createDB insertOrReplaceObjects:(NSArray<WCTObject *> *)objs intoTable:name];
}

+ (BOOL)removeObjs:(const WCDB::Expression &)condition name:(NSString *)name{
    if (!name) return NO;
    return [self.createDB deleteFromTable:name where:condition];
}

+ (BOOL)removeTableName:(NSString *)name{
    if (!name) return NO;
    return [self.createDB deleteFromTable:name];
}

+ (NSArray *)getAllObjsWithClass:(Class)cls name:(NSString *)name{
    if (![self.createDB tableExists:name]){
        return @[];
    }
    return [self.createDB getObjectsOfClass:cls fromTable:name];
}

+ (NSArray *)getAllObjsWithClass:(Class)cls name:(NSString *)name orderBy:(const WCDB::OrderingTerms &)orderBy{
    if (!name) return @[];
    return [self.createDB getObjectsOfClass:cls fromTable:name orders:orderBy];
}

+ (NSArray *)getAllObjsWithClass:(Class)cls name:(NSString *)name where:(const WCDB::Expression &)where orderBy:(const WCDB::OrderingTerms &)orderBy{
    if (!name) return @[];
    return [self.createDB getObjectsOfClass:cls fromTable:name where:where orders:orderBy];
}

+ (id)getObjWithClass:(Class)cls name:(NSString *)name condition:(const WCDB::Expression &)condition{
    if (!name) return nil;
    return [self.createDB getObjectOfClass:cls fromTable:name where:condition];
}

+ (id)getObjsWithClass:(Class)cls name:(NSString *)name condition:(const WCDB::Expression &)condition{
    if (!name) return nil;
    return [self.createDB getObjectsOfClass:cls fromTable:name where:condition];
}

+ (NSUInteger)getDataFileSize{
    [self.createDB close];
    return [self.createDB getFilesSize];
}

+ (BOOL)removeBookCacheFiles{
    [self.createDB close];
    return [self.createDB removeFiles];
}


@end
