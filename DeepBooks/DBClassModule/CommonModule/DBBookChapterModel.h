//
//  DBBookChapterModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBookChapterModel : NSObject

@property (nonatomic, assign) BOOL is_encrypt;
@property (nonatomic, assign) NSInteger num_words;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *title; //解密内容
@property (nonatomic, copy) NSString *body; //解密内容

@property (nonatomic, assign) NSInteger chapter_index; //章节


@property (nonatomic, copy) NSString *id;

+ (DBBookChapterModel *)getBookChapter:(NSString *)chapterForm chapterId:(NSString *)chapterId;
+ (NSArray <DBBookChapterModel *>*)getAllBookChapter:(NSString *)chapterForm;

- (BOOL)updateChapterWithChapterForm:(NSString *)chapterForm;
+ (BOOL)updateChapters:(NSArray <DBBookChapterModel *>*)chapters chapterForm:(NSString *)chapterForm;

+ (NSUInteger)getBookChapterMemory:(NSString *)chapterForm;
+ (BOOL)removeBookChapter:(NSString *)chapterForm;

+ (NSString *)getAllBooksChapterMemory;
+ (void)removeAllBooksChapterMemory;

+ (NSString *)getDataFileMemory:(NSUInteger)cacheSize;
@end

NS_ASSUME_NONNULL_END
