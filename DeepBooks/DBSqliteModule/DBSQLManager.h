//
//  DBSQLManager.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import <Foundation/Foundation.h>
//#import <WCDB/WCDB.h>
#import "WCDBObjc.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DBTableType) {
    DBTableBooksCollect,
    DBTableBooksReading,
    DBTableBooksSource,  //来源
    DBTableBooksCatalog, //目录
    DBTableBooksChapter, //章节
};


@interface DBSQLManager : NSObject

+ (NSString *)tableNameFromType:(DBTableType)type;
+ (NSString *)tableNameFromType:(DBTableType)type append:(NSString *)append;

+ (BOOL)insertObj:(WCTObject *)obj name:(NSString *)name;
+ (BOOL)insertObjs:(NSArray <WCTObject *>*)objs name:(NSString *)name;

+ (BOOL)removeObjs:(const WCDB::Expression &)condition name:(NSString *)name;
+ (BOOL)removeTableName:(NSString *)name;

+ (NSArray *)getAllObjsWithClass:(Class)cls name:(NSString *)name;
+ (NSArray *)getAllObjsWithClass:(Class)cls name:(NSString *)name orderBy:(const WCDB::OrderingTerms &)orderBy;
+ (NSArray *)getAllObjsWithClass:(Class)cls name:(NSString *)name where:(const WCDB::Expression &)where orderBy:(const WCDB::OrderingTerms &)orderBy;

+ (id)getObjWithClass:(Class)cls name:(NSString *)name condition:(const WCDB::Expression &)condition;
+ (id)getObjsWithClass:(Class)cls name:(NSString *)name condition:(const WCDB::Expression &)condition;


//获取储存大小
+ (NSUInteger)getDataFileSize;
+ (BOOL)removeBookCacheFiles;

@end

NS_ASSUME_NONNULL_END
