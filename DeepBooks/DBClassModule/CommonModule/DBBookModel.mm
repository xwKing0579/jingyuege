//
//  DBBookModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import "DBBookModel.h"
#import "DBSQLManager.h"
#import "DBReadBookSetting.h"
//#import <WCDB/WCDB.h>
#import "WCDBObjc.h"
@interface DBBookModel () <WCTTableCoding>

@end


@implementation DBBookModel

WCDB_IMPLEMENTATION(DBBookModel)
WCDB_SYNTHESIZE(book_id)
WCDB_SYNTHESIZE(words_number)
WCDB_SYNTHESIZE(total_count)
WCDB_SYNTHESIZE(ltype)
WCDB_SYNTHESIZE(status)
WCDB_SYNTHESIZE(score)
WCDB_SYNTHESIZE(name)
WCDB_SYNTHESIZE(author)
WCDB_SYNTHESIZE(image)
WCDB_SYNTHESIZE(last_chapter_name)

WCDB_SYNTHESIZE(site_path)
WCDB_SYNTHESIZE(site_path_reload)

WCDB_SYNTHESIZE(collectDate)
WCDB_SYNTHESIZE(updateTime)
WCDB_SYNTHESIZE(lastReadTime)
WCDB_SYNTHESIZE(updated_at)

WCDB_SYNTHESIZE(sourceForm)
WCDB_SYNTHESIZE(catalogForm)
WCDB_SYNTHESIZE(chapterForm)

WCDB_SYNTHESIZE(read_time)
WCDB_SYNTHESIZE(readChapterName)
WCDB_SYNTHESIZE(chapter_index)
WCDB_SYNTHESIZE(page_index)
WCDB_SYNTHESIZE(is_top)
WCDB_SYNTHESIZE(isClosePush)
WCDB_SYNTHESIZE(isCultivate)
WCDB_SYNTHESIZE(pageOffsetY)

WCDB_PRIMARY(book_id)


- (NSString *)image{
    if (self.isLocal) return _image?:@"jjVerdantSigil";
    return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_image];
}


- (NSString *)sourceForm{
    return [NSString stringWithFormat:@"book_source_%@",self.book_id];
}

- (NSString *)catalogForm{
    return [NSString stringWithFormat:@"book_catalog_%@",self.book_id];
}

- (NSString *)chapterForm{
    return [NSString stringWithFormat:@"book_chapter_%@",self.book_id];
}

- (BOOL)insertCollectBook{
    return [DBSQLManager insertObj:self name:[DBSQLManager tableNameFromType:DBTableBooksCollect]];
}

- (BOOL)updateCollectBook{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksCollect];
    DBBookModel *model = [DBSQLManager getObjWithClass:self.class name:name condition:DBBookModel.book_id == self.book_id];
    return model ? [DBSQLManager insertObj:self name:name] : NO;
}

- (BOOL)updateReadingBook{
    return [DBSQLManager insertObj:self name:[DBSQLManager tableNameFromType:DBTableBooksReading]];
}

- (BOOL)removeCollectBook{
    return [DBSQLManager removeObjs:DBBookModel.book_id == self.book_id name:[DBSQLManager tableNameFromType:DBTableBooksCollect]];
}

- (BOOL)removeReadingBook{
    return [DBSQLManager removeObjs:DBBookModel.book_id == self.book_id name:[DBSQLManager tableNameFromType:DBTableBooksReading]];
}

+ (BOOL)insertCollectBooks:(NSArray *)books{
    return [DBSQLManager insertObjs:books name:[DBSQLManager tableNameFromType:DBTableBooksCollect]];
}

+ (NSArray *)getAllCollectBooks{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksCollect];
    const WCDB::OrderingTerms &order = DBReadBookSetting.setting.orderType ? DBBookModel.updated_at.asDescOrder() : DBBookModel.updateTime.asDescOrder();
    NSArray *topList = [DBSQLManager getAllObjsWithClass:self.class name:name where:DBBookModel.is_top == YES && DBBookModel.isCultivate == NO orderBy:order];
    NSArray *lastList = [DBSQLManager getAllObjsWithClass:self.class name:name where:DBBookModel.is_top == NO && DBBookModel.isCultivate == NO orderBy:order];
    NSMutableArray *list = [NSMutableArray array];
    [list addObjectsFromArray:topList];
    [list addObjectsFromArray:lastList];
    return list;
}

+ (NSArray *)getAllCultivateBooks{
    NSString *name = [DBSQLManager tableNameFromType:DBTableBooksCollect];
    const WCDB::OrderingTerms &order = DBReadBookSetting.setting.orderType ? DBBookModel.updated_at.asDescOrder() : DBBookModel.updateTime.asDescOrder();
    return [DBSQLManager getAllObjsWithClass:self.class name:name where:DBBookModel.isCultivate == YES orderBy:order];
}

+ (NSArray *)getAllReadingBooks{
    return [DBSQLManager getAllObjsWithClass:self.class name:[DBSQLManager tableNameFromType:DBTableBooksReading] orderBy:DBBookModel.updateTime.asDescOrder()];
}

+ (BOOL)removeAllReadingBooks{
    return [DBSQLManager removeTableName:[DBSQLManager tableNameFromType:DBTableBooksReading]];
}

+ (BOOL)removeAllCollectBooks{
    return [DBSQLManager removeTableName:[DBSQLManager tableNameFromType:DBTableBooksCollect]];
}

+ (BOOL)removeCollectBooksInIds:(NSArray *)ids{
    if (!ids.count) return NO;
    return [DBSQLManager removeObjs:DBBookModel.book_id.in(ids) name:[DBSQLManager tableNameFromType:DBTableBooksCollect]];
}

+ (BOOL)removeReadingBooksInIds:(NSArray *)ids{
    if (!ids.count) return NO;
    return [DBSQLManager removeObjs:DBBookModel.book_id.in(ids) name:[DBSQLManager tableNameFromType:DBTableBooksReading]];
}

+ (DBBookModel *)getCollectBookWithId:(NSString *)bookId{
    return [DBSQLManager getObjWithClass:self.class name:[DBSQLManager tableNameFromType:DBTableBooksCollect] condition:DBBookModel.book_id == bookId];
}

+ (DBBookModel *)getReadingBookWithId:(NSString *)bookId{
    return [DBSQLManager getObjWithClass:self.class name:[DBSQLManager tableNameFromType:DBTableBooksReading] condition:DBBookModel.book_id == bookId];
}

+ (NSUInteger)getAllBooksDataFileSize{
    return [DBSQLManager getDataFileSize];
}

+ (BOOL)removeBookCacheFiles{
    return [DBSQLManager removeBookCacheFiles];
}
@end
