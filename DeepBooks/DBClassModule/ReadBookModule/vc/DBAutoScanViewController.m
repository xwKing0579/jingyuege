//
//  DBAutoScanViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/9.
//

#import "DBAutoScanViewController.h"
#import "DBReaderPageViewController.h"
#import "DBReaderAdViewController.h"
#import "DBScanningView.h"

@interface DBAutoScanViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) DBReaderPageViewController *readerPageVc;
@property (nonatomic, strong) DBReaderPageViewController *nextReaderPageVc;
@property (nonatomic, strong) DBReaderAdViewController *readerAdVc;
@property (nonatomic, strong) DBScanningView *scanningView;
@end

@implementation DBAutoScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self addChildViewController:self.readerPageVc];
    [self.view addSubview:self.readerPageVc.view];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    DBWeakSelf
    self.scanningView.scanCompletionBlock = ^{
        DBStrongSelfElseReturn
        [self.scanningView stopAutoScan];
        
        if (self.model.currentChapter == self.model.chapterCacheList.count-1 && self.model.currentPage == self.model.contentList.count-1){
            [self endPageScanStyle];
        }else{
            [self nextScanPageContent];
        }
    };
    
    self.scanningView.scanFinishBlock = ^{
        DBStrongSelfElseReturn
        [self endPageScanStyle];
    };
}

- (void)setModel:(DBReaderModel *)model{
    _model = model;
    
    [self scanPageContent];
}

- (void)scanPageContent{
    self.readerPageVc.model = self.model;
    self.scanningView.targetView = self.readerPageVc.view;
    [self.readerPageVc.view setNeedsDisplay];
    

    DBReaderAdViewController *readerAdVc = [self getReaderAdViewControllerWithModel:self.model];
    if (readerAdVc){
        UIImageView *shotImage = [[UIImageView alloc] initWithFrame:self.readerAdVc.view.bounds];
        shotImage.image = readerAdVc.view.imageShot;
        self.scanningView.nextPageContentView = shotImage;
    }else{
        DBReaderModel *nextModel = [self nextReaderModelWithCurrentModel:self.model];
        if (nextModel){
            self.nextReaderPageVc.model = nextModel;
            self.scanningView.nextPageContentView = self.nextReaderPageVc.view;
        }
    }
  
    [self.view addSubview:self.scanningView];
    [self.scanningView startAutoScan];
}

- (void)nextScanPageContent{

    if (self.readerAdVc.readerAdType != DBReaderNoAd) {
        [self.readerAdVc.view removeFromSuperview];
        
        self.readerAdVc.view.backgroundColor = UIColor.redColor;
        [self addChildViewController:self.readerAdVc];
        [self.view addSubview:self.readerAdVc.view];
        self.readerAdVc.view.frame = self.view.bounds;
        [self.view addSubview:self.scanningView];
        self.scanningView.targetView = self.readerAdVc.view;
  
        DBReaderModel *nextModel = [self nextReaderModelWithCurrentModel:self.model];
        if (nextModel){
            self.nextReaderPageVc.model = nextModel;
            self.scanningView.nextPageContentView = self.nextReaderPageVc.view;
        }
        [self.scanningView startAutoScan];
        self.readerAdVc.readerAdType = DBReaderNoAd;
    }else{
        [self.model getNextPageChapterModelWithDiff:1];
        [self.readerAdVc removeFromParentViewController];
        [self.readerAdVc.view removeFromSuperview];
        [self scanPageContent];
    }
}

- (void)endPageScanStyle{
    if (self.finishAutoScanBlock) self.finishAutoScanBlock();
}

- (DBReaderModel *)nextReaderModelWithCurrentModel:(DBReaderModel *)model{
    DBReaderModel *nextModel = [[DBReaderModel alloc] init];
    nextModel.chapterForm = self.model.chapterForm;
    nextModel.chapterCacheList = self.model.chapterCacheList;
    nextModel.readPageNum = self.model.readPageNum+1;
    nextModel.slotEndAd = self.model.slotEndAd;
    nextModel.gridEndAd = self.model.gridEndAd;
    nextModel.slotAdDiff = self.model.slotAdDiff;
    nextModel.gridAdDiff = self.model.gridAdDiff;
   
    NSInteger nextPage = model.currentPage+1;
    if (nextPage >= model.contentList.count){
        if (model.currentChapter+1 >= model.chapterCacheList.count) return nil;
        nextModel.currentChapter = model.currentChapter+1;
        nextModel.currentPage = 0;
    }else{
        nextModel.currentPage = nextPage;
        nextModel.currentChapter = model.currentChapter;
    }
    return nextModel;
}

- (DBReaderAdViewController *)getReaderAdViewControllerWithModel:(DBReaderModel *)model{
    if (model.isAdPage) return nil;
    
    DBReaderAdType adType = [DBReaderAdViewModel getReaderAdTypeWithModel:model after:YES];
    if (adType == DBReaderNoAd) return nil;
    
    self.readerAdVc.readerAdType = adType;
    return self.readerAdVc;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture{}
    
- (DBReaderPageViewController *)readerPageVc{
    if (!_readerPageVc){
        _readerPageVc = [[DBReaderPageViewController alloc] init];
        _readerPageVc.view.frame = self.view.bounds;
    }
    return _readerPageVc;
}

- (DBReaderPageViewController *)nextReaderPageVc{
    if (!_nextReaderPageVc){
        _nextReaderPageVc = [[DBReaderPageViewController alloc] init];
        _nextReaderPageVc.view.frame = self.view.bounds;
    }
    return _nextReaderPageVc;
}

- (DBScanningView *)scanningView{
    if (!_scanningView){
        _scanningView = [[DBScanningView alloc] initWithFrame:self.view.bounds];
    }
    return _scanningView;
}

- (DBReaderAdViewController *)readerAdVc{
    if (!_readerAdVc){
        _readerAdVc = [[DBReaderAdViewController alloc] init];
    }
    return _readerAdVc;
}
@end
