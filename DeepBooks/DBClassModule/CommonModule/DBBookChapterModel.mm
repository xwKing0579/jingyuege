//
//  DBBookChapterModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/4.
//

#import "DBBookChapterModel.h"
#import "DBBookChapterManager.h"


@interface DBBookChapterModel () <WCTTableCoding>

@end

@implementation DBBookChapterModel

WCDB_IMPLEMENTATION(DBBookChapterModel)

WCDB_SYNTHESIZE(num_words)

WCDB_SYNTHESIZE(title)
WCDB_SYNTHESIZE(body)
WCDB_SYNTHESIZE(id)
WCDB_SYNTHESIZE(chapter_index)

WCDB_PRIMARY(id)


+ (DBBookChapterModel *)getBookChapter:(NSString *)chapterForm chapterId:(NSString *)chapterId{
    NSString *name = [DBBookChapterManager tableNameFromType:DBTableBooksChapter append:chapterForm];
    if (!name) return nil;
    return [DBBookChapterManager getObjWithClass:self.class name:name condition:DBBookChapterModel.id == chapterId];
}

+ (NSArray <DBBookChapterModel *>*)getAllBookChapter:(NSString *)chapterForm{
    NSString *name = [DBBookChapterManager tableNameFromType:DBTableBooksChapter append:chapterForm];
    if (!name) return nil;
    return [DBBookChapterManager getAllObjsWithClass:self.class name:name];
}

- (BOOL)updateChapterWithChapterForm:(NSString *)chapterForm{
    NSString *name = [DBBookChapterManager tableNameFromType:DBTableBooksChapter append:chapterForm];
    if (!name) return NO;
    return [DBBookChapterManager insertObj:self name:name];
}

+ (BOOL)updateChapters:(NSArray <DBBookChapterModel *>*)chapters chapterForm:(NSString *)chapterForm{
    NSString *name = [DBBookChapterManager tableNameFromType:DBTableBooksChapter append:chapterForm];
    if (!name) return NO;
    return [DBBookChapterManager insertObjs:chapters name:name];
}

+ (NSUInteger)getBookChapterMemory:(NSString *)chapterForm{
    [DBBookChapterManager tableNameFromType:DBTableBooksChapter append:chapterForm];
    return [DBBookChapterManager getDataFileSize];
}

+ (BOOL)removeBookChapter:(NSString *)chapterForm{
    [DBBookChapterManager tableNameFromType:DBTableBooksChapter append:chapterForm];
    return [DBBookChapterManager removeBookCacheFiles];
}

+ (NSString *)getDataFileMemory:(NSUInteger)cacheSize{
    NSString *booksCache;
    if (cacheSize < 1024) {
        booksCache = [NSString stringWithFormat:@"%ld", cacheSize];
    } else if (cacheSize < 1024 * 1024) {
        booksCache = [NSString stringWithFormat:@"%.1fKB", cacheSize / 1024.0];
    } else if (cacheSize < 1024 * 1024 * 1024) {
        booksCache = [NSString stringWithFormat:@"%.1fMB", cacheSize / (1024.0 * 1024.0)];
    } else {
        booksCache = [NSString stringWithFormat:@"%.1fGB", cacheSize / (1024.0 * 1024.0 * 1024.0)];
    }
    return booksCache;
}

+ (NSString *)getAllBooksChapterMemory{
    NSUInteger cacheSize = 0;
    for (DBBookModel *book in DBBookModel.getAllReadingBooks) {
        NSUInteger size = [DBBookChapterModel getBookChapterMemory:book.chapterForm];
        if (size < 50*1024) continue;
        cacheSize += size;
    }
    return [self getDataFileMemory:cacheSize];
}

+ (void)removeAllBooksChapterMemory{
    for (DBBookModel *book in DBBookModel.getAllReadingBooks) {
        [self removeBookChapter:book.chapterForm];
    }
}


@end
