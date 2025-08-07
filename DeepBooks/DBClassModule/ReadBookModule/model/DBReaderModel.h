//
//  DBReaderModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBReaderModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSAttributedString *attributeString;
@property (nonatomic, strong) NSArray *contentList;

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *site_path_reload;
@property (nonatomic, copy) NSString *updated_at;


@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentChapter;

@property (nonatomic, strong) NSArray *chapterCacheList;

@property (nonatomic, copy) NSString *catalogForm;
@property (nonatomic, copy) NSString *chapterForm;
@property (nonatomic, copy) NSString *chapterId;

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, assign) BOOL isAdPage;

@property (nonatomic, assign) NSInteger cumulativeTime;
@property (nonatomic, assign) NSInteger readPageNum;

@property (nonatomic, assign) BOOL slotEndAd;
@property (nonatomic, assign) BOOL gridEndAd;
@property (nonatomic, assign) NSInteger slotAdDiff;
@property (nonatomic, assign) NSInteger gridAdDiff;

- (void)onlySetPageIndex:(NSInteger)pageIndex;
- (void)onlySetChapterIndex:(NSInteger)chapterIndex;

- (void)updateReaderModelData;

- (DBReaderModel *)getNextPageChapterModelWithDiff:(NSInteger)diff;
- (DBReaderModel *)getNextPageChapterNosetModelWithDiff:(NSInteger)diff;
@end

NS_ASSUME_NONNULL_END
