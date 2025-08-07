//
//  DBBookChapterManager.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/28.
//

#import "DBBookChapterManager.h"
#import "DBBookChapterModel.h"
//#import <WCDB/WCDB.h>
#import "WCDBObjc.h"
static NSString *chapterForm = @"Chapter";
@implementation DBBookChapterManager

+ (WCTDatabase *)createDB{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",UIApplication.bundleName,chapterForm]];
    WCTDatabase *chapterWscb = [[WCTDatabase alloc] initWithPath:path];
    return chapterWscb;
}

+ (NSString *)tableNameFromType:(DBTableType)type append:(NSString *)append{
    if (append.length == 0) return nil;
    chapterForm = append;
    NSString *tableName = append;
    WCTDatabase *wct = [self createDB];
    
    if (![wct isOpened] && ![wct canOpen]) {
        return tableName;
    }
    
    Class cls = DBBookChapterModel.class;
    if (![wct tableExists:tableName]){
        BOOL isCreate = [wct createTable:tableName withClass:cls];
        if (!isCreate) {
            return tableName;
        }
    }
    return tableName;
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
