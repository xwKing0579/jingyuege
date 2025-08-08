//
//  DBReaderModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import "DBReaderModel.h"
#import "DBBookCatalogModel.h"
#import "DBBookChapterModel.h"
#import "DBReadBookSetting.h"


@implementation DBReaderModel

- (void)setChapterCacheList:(NSArray *)chapterCacheList{
    if (chapterCacheList.count == 0) return;
    _chapterCacheList = chapterCacheList;
    
    if (self.currentChapter > chapterCacheList.count-1){
        self.currentPage = 0;
        self.currentChapter = chapterCacheList.count-1;
    }
    [self updateReaderModelData];
}

- (void)setCurrentChapter:(NSInteger)currentChapter{
    _currentChapter = currentChapter;
    [self updateReaderModelData];
}

- (void)onlySetPageIndex:(NSInteger)pageIndex{
    _currentPage = pageIndex;
}

- (void)onlySetChapterIndex:(NSInteger)chapterIndex{
    _currentChapter = chapterIndex;
}

- (void)updateReaderModelData{
    if (_currentChapter > _chapterCacheList.count-1) {
        [self clearOldModelCacheData];
        return;
    }
    DBBookCatalogModel *catalog = _chapterCacheList[_currentChapter];
    if (!catalog) {
        [self clearOldModelCacheData];
        return;
    }
    
    NSString *chapterId = catalog.path;
    NSString *title = [NSString stringWithFormat:@"%@\n\n",catalog.title];

    DBBookChapterModel *chapterModel = [DBBookChapterModel getBookChapter:_chapterForm chapterId:chapterId];
    NSString *content = chapterModel.body;
    
    self.title = title;
    self.content = content.length > 0 ? content : DBConstantString.ks_chapterLoadFailed.textMultilingual;
    self.chapterId = chapterId;
    
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = setting.lineSpacing;
    paraStyle.alignment = NSTextAlignmentJustified;
    NSAttributedString *attributeString = [NSAttributedString combineAttributeTexts:@[DBSafeString(title),self.content]
                                                           colors:@[setting.textColor]
                                                            fonts:@[[UIFont fontWithName:setting.fontName size:setting.titleFontSize],
                                                                    [UIFont fontWithName:setting.fontName size:setting.textFontSize]]
                                                                              attrs:@[@{},@{NSParagraphStyleAttributeName:paraStyle,
                                                                          NSKernAttributeName:@(setting.wordSpacing)}]
    ];
    NSArray *contentList = [DBReadBookSetting calculateCanvasesForAttributedString:attributeString];
    self.attributeString = attributeString;
    self.contentList = contentList;
   
    if (self.currentPage > contentList.count-1){
        self.currentPage = contentList.count-1;
    }
}

- (void)clearOldModelCacheData{
    self.title = @"";
    self.content = DBConstantString.ks_chapterLoadFailed.textMultilingual;
    self.chapterId = @"";
    self.attributeString = nil;
    self.contentList = @[];
}

- (DBReaderModel *)getNextPageChapterModelWithDiff:(NSInteger)diff{
    DBReaderModel *model = self;
    
    NSInteger pageIndex = model.currentPage;
    NSInteger nextPageIndex = pageIndex + diff;
 
    if (nextPageIndex < 0){
        model.currentChapter -= 1;
        model.currentPage = model.contentList.count-1;
    }else if (nextPageIndex > model.contentList.count-1){
        if (model.currentChapter+1 >= model.chapterCacheList.count) return model;
        model.currentChapter += 1;
        model.currentPage = 0;
    } else{
        model.currentPage = nextPageIndex;
    }
    model.readPageNum += diff;
    return model;
}

- (DBReaderModel *)getNextPageChapterNosetModelWithDiff:(NSInteger)diff{
    DBReaderModel *model = self;
    
    NSInteger pageIndex = model.currentPage;
    NSInteger nextPageIndex = pageIndex + diff;
 
    if (nextPageIndex < 0){
        [model onlySetChapterIndex:model.currentChapter-1];
        [model onlySetPageIndex:model.contentList.count-1];
    }else if (nextPageIndex > model.contentList.count-1){
        if (model.currentChapter+1 >= model.chapterCacheList.count) return model;
        [model onlySetChapterIndex:model.currentChapter+1];
        [model onlySetPageIndex:0];
    } else{
        [model onlySetPageIndex:nextPageIndex];
    }
    model.readPageNum += diff;
    return model;
}

@end
