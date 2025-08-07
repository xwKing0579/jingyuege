//
//  DBPageCoverViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import "DBPageCoverViewController.h"
#import "DBReadCoverViewController.h"
#import "DBReaderPageViewController.h"
#import "DBReadBookSetting.h"
#import "DBReaderEndViewController.h"
#import "DBReaderAdViewController.h"

@interface DBPageCoverViewController ()<DBReadCoverViewControllerDelegate>
@property (nonatomic, strong) DBReadCoverViewController *readingCoverVc;
@property (nonatomic, strong) DBReaderAdViewController *readerAdVc;
@end

@implementation DBPageCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self addChildViewController:self.readingCoverVc];
    [self.view addSubview:self.readingCoverVc.view];
}

- (void)setModel:(DBReaderModel *)model{
    _model = model;
    
    DBReaderPageViewController *nextVc = [[DBReaderPageViewController alloc] init];
    nextVc.model = model;
    [self.readingCoverVc setController:nextVc];
}

#pragma mark - DBReadCoverViewControllerDelegate
- (UIViewController *)coverController:(DBReadCoverViewController *)coverController getAboveControllerWithCurrentController:(UIViewController *)currentController{
    if (self.model.currentChapter == 0 && self.model.currentPage == 0) {
        [self.view showAlertText:@"已经是第一页"];
        return nil;
    }

    DBReaderAdViewController *readerAdVc = [self getReaderAdViewController:NO];
    if (readerAdVc) return readerAdVc;
    return [self getReaderPageController:NO];
}

- (UIViewController *)coverController:(DBReadCoverViewController *)coverController getBelowControllerWithCurrentController:(UIViewController *)currentController{
    if (self.model.isEnd) return nil;
    if (self.model.currentChapter == self.model.chapterCacheList.count-1 && self.model.currentPage == self.model.contentList.count-1) {
        DBReaderEndViewController *endVc = [[DBReaderEndViewController alloc] init];
        endVc.model = self.model;
        self.model.isEnd = YES;
        return endVc;
    }
    
    DBReaderAdViewController *readerAdVc = [self getReaderAdViewController:YES];
    if (readerAdVc) return readerAdVc;
    return [self getReaderPageController:YES];
}

- (void)coverController:(DBReadCoverViewController * _Nonnull)coverController currentController:(UIViewController * _Nullable)currentController finish:(BOOL)isFinish{
    
}

- (DBReaderPageViewController *)getReaderPageController:(BOOL)after{
    DBReaderPageViewController *nextVc = [[DBReaderPageViewController alloc] init];
    if (after){
        if (self.model.isAdPage && !self.readerAdVc.after){
            nextVc.model = self.model;
        }else{
            nextVc.model = [self.model getNextPageChapterModelWithDiff:1];
        }
    }else{
        if (self.model.isEnd) {
            nextVc.model = self.model;
        }else if (self.model.isAdPage){
            if (self.readerAdVc.after){
                nextVc.model = self.model;
            }else{
                nextVc.model = [self.model getNextPageChapterModelWithDiff:-1];
            }
        }else{
            nextVc.model = [self.model getNextPageChapterModelWithDiff:-1];
        }
        if (self.model.isEnd) self.model.isEnd = NO;
    }
    if (self.model.isAdPage) self.model.isAdPage = NO;
    return nextVc;
}

- (DBReaderAdViewController *)getReaderAdViewController:(BOOL)after{
    if (self.model.isAdPage) return nil;
    
    DBReaderAdType adType = [DBReaderAdViewModel getReaderAdTypeWithModel:self.model after:after];
    if (adType == DBReaderNoAd) return nil;
    
    self.readerAdVc.readerAdType = adType;
    self.readerAdVc.after = after;
    self.model.isAdPage = YES;
    return self.readerAdVc;
}

- (DBReadCoverViewController *)readingCoverVc{
    if (!_readingCoverVc){
        _readingCoverVc = [[DBReadCoverViewController alloc] init];
        _readingCoverVc.delegate = self;
        _readingCoverVc.view.frame = self.view.bounds;
    }
    return _readingCoverVc;
}

- (DBReaderAdViewController *)readerAdVc{
    if (!_readerAdVc){
        _readerAdVc = [[DBReaderAdViewController alloc] init];
    }
    return _readerAdVc;
}
@end
