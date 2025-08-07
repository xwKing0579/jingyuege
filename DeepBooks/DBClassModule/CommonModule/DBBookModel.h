//
//  DBBookModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBookModel : NSObject

@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, assign) NSInteger words_number;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, copy) NSString *ltype;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, assign) BOOL isLastRead;

@property (nonatomic, copy) NSString *site_path; //阅读源
@property (nonatomic, copy) NSString *site_path_reload; //目录是否更新
@property (nonatomic, copy) NSString *last_chapter_name; //最新章节

@property (nonatomic, assign) NSInteger collectDate; //添加时间
@property (nonatomic, assign) NSInteger updateTime; //书本操作时间(n种操作)
@property (nonatomic, assign) NSInteger lastReadTime; //最后阅读时间
@property (nonatomic, copy) NSString *updated_at; //文章更新时间

@property (nonatomic, copy) NSString *sourceForm; 
@property (nonatomic, copy) NSString *catalogForm;
@property (nonatomic, copy) NSString *chapterForm;

@property (nonatomic, assign) NSInteger read_time; //阅读总时长
@property (nonatomic, assign) NSInteger chapter_index;
@property (nonatomic, assign) NSInteger page_index;
@property (nonatomic, copy) NSString *readChapterName; //上次阅读章节名称，模糊匹配其他源同名书籍
@property (nonatomic, assign) CGFloat pageOffsetY;

@property (nonatomic, assign) BOOL is_top; //是否置顶
@property (nonatomic, assign) BOOL isClosePush; //是否关闭更新提醒
@property (nonatomic, assign) BOOL isCultivate;  //培养中

- (BOOL)insertCollectBook; //新增或更新
- (BOOL)updateCollectBook; //先判断存在不，存在则更新
- (BOOL)updateReadingBook; //新增或更新
- (BOOL)removeCollectBook;
- (BOOL)removeReadingBook;

+ (BOOL)insertCollectBooks:(NSArray *)books;

+ (NSArray *)getAllCollectBooks;
+ (NSArray *)getAllReadingBooks;
+ (NSArray *)getAllCultivateBooks;
+ (BOOL)removeAllReadingBooks;
+ (BOOL)removeAllCollectBooks;
+ (BOOL)removeCollectBooksInIds:(NSArray *)ids;
+ (BOOL)removeReadingBooksInIds:(NSArray *)ids;

+ (DBBookModel *)getCollectBookWithId:(NSString *)bookId;
+ (DBBookModel *)getReadingBookWithId:(NSString *)bookId;


+ (NSUInteger)getAllBooksDataFileSize;

+ (BOOL)removeBookCacheFiles;
@end


NS_ASSUME_NONNULL_END
