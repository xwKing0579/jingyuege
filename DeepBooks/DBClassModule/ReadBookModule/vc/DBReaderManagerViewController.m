//
//  DBReaderManagerViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import "DBReaderManagerViewController.h"
#import "DBReaderModel.h"

#import "DBPageLinearViewController.h"
#import "DBPageCoverViewController.h"
#import "DBAutoScanViewController.h"
#import "DBAudiobookViewController.h"
#import "DBPageRollingViewController.h"

#import "DBReadBookSetting.h"
#import "DBBookCatalogModel.h"

#import "DBReaderContentViewModel.h"
#import "DBReaderAdViewModel.h"
#import "DBFreeVipConsumeModel.h"
@interface DBReaderManagerViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIViewController *readerVc;
@property (nonatomic, strong) DBEmptyView *errorDataView;
@property (nonatomic, strong) DBReaderModel *model;

@property (nonatomic, strong) DBReaderContentViewModel *readerContentViewModel;
@property (nonatomic, strong) DBReaderAdViewModel *readerAdViewModel;

@property (nonatomic, strong) NSDate *begainTime;
@property (nonatomic, strong) NSMutableSet *loadingSet;

@property (nonatomic, assign) NSInteger freeCount;
@property (nonatomic, assign) NSInteger freeSeconds;
@end

@implementation DBReaderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *vcList = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.childViewControllers){
        if ([vc isKindOfClass:DBReaderManagerViewController.class] && ![vc isEqual:self]){
            
        }else{
            [vcList addObject:vc];
        }
    }
    self.navigationController.viewControllers = vcList;
    
    [self setUpSubViews];
    [self getDataSource];
    [self freeVipConfig];
    [self addObserver];
    
}

- (void)setUpSubViews{
    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = DBReadBookSetting.setting.backgroundColor;
    
    [self switchReaderTransitionStyleSwitch:NO];
    [self.view addSubviews:@[self.readerContentViewModel.chapterNameView,self.readerContentViewModel.batteryDateView]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondsTimeChange) name:DBsecondsTimeChange object:nil];
    

    NSArray *keyPaths = @[@"isEnd",@"currentPage",@"currentChapter",@"isAdPage"];
    [keyPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.model addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (touchPoint.x > UIScreen.screenWidth/3+10 && touchPoint.x < UIScreen.screenWidth*2/3-10){
        if (self.model.isEnd) return;
        self.fd_interactivePopDisabled = NO;
        [self.readerContentViewModel addReaderPanelView];
        self.readerContentViewModel.readerPanelView.sliderValue = ((CGFloat)(self.model.currentChapter+1))/((CGFloat)self.model.chapterCacheList.count);
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self.view];
    if (touchPoint.x > UIScreen.screenWidth/3 || touchPoint.x < UIScreen.screenWidth*2/3){
        return YES;
    }
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentChapter"]) {
        self.readerContentViewModel.chapterNameView.nameStr = self.model.title;
        [self getMoreBookContentDataSource];
        [self reportBookChapterInfo];
        self.book.chapter_index = self.model.currentChapter;
    }
    
    if ([keyPath isEqualToString:@"currentPage"]) {
        if ([self.readerVc isKindOfClass:DBPageRollingViewController.class]) {
            self.readerContentViewModel.batteryDateView.pageStr = @"";
        }else{
            self.readerContentViewModel.batteryDateView.pageStr = [NSString stringWithFormat:@"第%ld/%ld页",MIN(self.model.currentPage+1, self.model.contentList.count),self.model.contentList.count];
        }
        self.book.page_index = self.model.currentPage;
    }
    
    BOOL isHidden = self.model.isEnd || self.model.isAdPage;
    self.readerContentViewModel.chapterNameView.hidden = isHidden;
    self.readerContentViewModel.batteryDateView.hidden = isHidden;
}

- (void)secondsTimeChange{
    if (self.isViewLoaded && self.view.window != nil) {
        self.readerContentViewModel.batteryDateView.timeStr = NSDate.hourMinuteString;
        NSInteger diffTime = DBUnityAdConfig.manager.cumulativeTime - self.model.cumulativeTime;
        [self.readerAdViewModel loadReaderBottomBannerAdInDiffTime:diffTime];
        [self.readerAdViewModel loadReaderSlotAdInDiffTime:diffTime];
    }
    
    if (self.freeSeconds > 0){
        self.freeSeconds--;
        if (self.freeSeconds%60 == 0 || self.freeSeconds < 0){
            DBWeakSelf
            [DBAFNetWorking postServiceRequestType:DBLinkFreeVipConsume combine:nil parameInterface:@{@"seconds":@"60"} modelClass:DBFreeVipConsumeModel.class serviceData:^(BOOL successfulRequest, DBFreeVipConsumeModel *result, NSString * _Nullable message) {
                DBStrongSelfElseReturn
                if (successfulRequest){
                    if (result.remaining_seconds > 0) {
                        self.freeSeconds = result.remaining_seconds;
                    }else{
                        self.freeSeconds = 0;
                        id obj = [NSUserDefaults takeValueForKey:DBUserVipInfoValue];
                        DBUserVipModel *vipModel = [DBUserVipModel modelWithJSON:obj];
                        if (vipModel) {
                            vipModel.free_vip_seconds = 0;
                            [NSUserDefaults saveValue:vipModel.modelToJSONString forKey:DBUserVipInfoValue];
                        }
                        [self switchReaderTransitionStyleSwitch:YES];
                        [self freeVipConfig];
                    }
                }
            }];
        }
    }
}



- (void)getDataSource{
    NSArray <DBBookCatalogModel *>*chapterList = [DBBookCatalogModel getBookCatalogs:self.book.catalogForm];
    self.model.catalogForm = self.book.catalogForm;
    self.model.chapterForm = self.book.chapterForm;
    self.model.chapterCacheList = chapterList;
    self.model.currentPage = self.book.page_index;
    self.model.currentChapter = self.book.chapter_index;
    self.model.offsetY = self.book.pageOffsetY;
    self.model.bookId = self.book.book_id;
    self.model.bookName = self.book.name;
    self.model.site_path_reload = self.book.site_path_reload;
    self.model.updated_at = self.book.updated_at;
    self.model.slotEndAd = [DBReaderAdViewModel slotEndReaderAd];
    self.model.gridEndAd = [DBReaderAdViewModel gridEndReaderAd];
    self.model.slotAdDiff = [DBReaderAdViewModel getReaderAdSlotValue];
    self.model.gridAdDiff = [DBReaderAdViewModel getReaderAdGridValue];
    self.model.cumulativeTime = DBUnityAdConfig.manager.cumulativeTime;
    if (chapterList.count > self.model.currentChapter) {
        self.model.chapterCacheList = chapterList;
        [self updateReaderData];
    }
    
    NSString *content = self.model.attributeString.string;
    if (content.length == 0 || [content isEqualToString:@"获取本章失败"]) [self.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkBookCatalog combine:self.book.site_path parameInterface:nil modelClass:DBBookCatalogModel.class serviceData:^(BOOL successfulRequest, NSArray <DBBookCatalogModel *>*result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        
        if (successfulRequest){
            //移除问题章节
            NSMutableArray *tempChapterList = [NSMutableArray array];
            for (DBBookCatalogModel *catalogModel in result) {
                if (catalogModel.path.length) {
                    catalogModel.title = DBSafeString(catalogModel.name.aesDecryptText);
                    [tempChapterList addObject:catalogModel];
                }
            }
            
            self.model.chapterCacheList = tempChapterList;
            [DBBookCatalogModel deleteCatalogsForm:self.book.catalogForm];
            [DBBookCatalogModel updateCatalogs:tempChapterList catalogForm:self.book.catalogForm];
            if (self.model.content.length == 0 || [self.model.content isEqualToString:@"获取本章失败".textMultilingual]){
                [self getBookContentDataSource];
            }
        }else{
            if (self.model.chapterCacheList.count == 0) {
                self.errorDataView.hidden = NO;
                return;
            }
        }
        self.errorDataView.hidden = YES;
    }];
}

- (void)getBookContentDataSource{
    [self.view showHudLoading];
    self.readerVc.view.userInteractionEnabled = NO;
    
    
    NSInteger starIndex = MAX(self.model.currentChapter-3, 0);
    NSInteger endIndex = MIN(self.model.currentChapter+3,self.model.chapterCacheList.count-1);
    __block BOOL allSuccess = YES;
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger index = starIndex; index <= endIndex;index++) {
        dispatch_group_enter(group);
        DBBookCatalogModel *catalog = self.model.chapterCacheList[index];
        __block NSString *loadIdentifier = catalog.path;
        if (![self.loadingSet containsObject:loadIdentifier]) {
            [self.loadingSet addObject:loadIdentifier];
            [self.readerContentViewModel getChapterContentWithChapterForm:self.model.chapterForm chapterId:catalog.path chapterIndex:index completion:^(BOOL successfulRequest, NSInteger chapterIndex, NSString * _Nullable message) {
                [self.loadingSet removeObject:loadIdentifier];
                if (successfulRequest){
                    
                }else{
                    allSuccess = NO;
                }
               
                dispatch_group_leave(group);
            }];
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.view removeHudLoading];
        self.readerVc.view.userInteractionEnabled = YES;
        if (allSuccess){
            self.readerVc.view.hidden = NO;
            self.readerContentViewModel.chapterNameView.hidden = NO;
            self.readerContentViewModel.batteryDateView.hidden = NO;
            [self updateReaderController];
            [self getMoreBookContentDataSource];
            [self reportBookChapterInfo];
            self.errorDataView.hidden = YES;
        }else{
            self.errorDataView.hidden = NO;
        }
    });
}

- (void)getMoreBookContentDataSource{
    NSInteger index = self.model.currentChapter;
    NSInteger start = MAX(index-4, 0);
    NSInteger end = MIN(index+4, self.model.chapterCacheList.count-1);
    
    for (NSInteger i = start; i <= end; i++) {
        DBBookCatalogModel *catalog = self.model.chapterCacheList[i];
        __block NSString *loadIdentifier = catalog.path;
        if (![self.loadingSet containsObject:loadIdentifier]) {
            [self.loadingSet addObject:loadIdentifier];
            [self.readerContentViewModel getChapterContentWithChapterForm:self.model.chapterForm chapterId:catalog.path chapterIndex:index completion:^(BOOL successfulRequest, NSInteger chapterIndex, NSString * _Nullable message) {
                [self.loadingSet removeObject:loadIdentifier];
            }];
        }
    }
}

- (void)freeVipConfig{
    DBWeakSelf
    [DBReaderAdViewModel checkFreeAdActivityCompletion:^(DBUserVipModel * _Nonnull vipModel, DBUserActivityModel * _Nonnull activityModel) {
        DBStrongSelfElseReturn
        if (vipModel.level == 1 && activityModel.rules.free_vip_rules.seconds > 0){
            if (vipModel.free_vip_seconds == 0){
                self.readerAdViewModel.activityView.activityModel = activityModel;
                [self.view addSubview:self.readerAdViewModel.activityView];
                
                DBWeakSelf
                self.readerAdViewModel.activityView.didRewardBlock = ^(NSInteger freeSeconds) {
                    DBStrongSelfElseReturn
                    if (freeSeconds > 0){
                        self.freeSeconds = freeSeconds;
                        [self.readerAdViewModel clearAllReaderAdView];
                        vipModel.free_vip_seconds = freeSeconds;
                        [NSUserDefaults saveValue:vipModel.modelToJSONString forKey:DBUserVipInfoValue];
                        [self switchReaderTransitionStyleSwitch:YES];
                    }
                };
            }else{
                self.freeSeconds = vipModel.free_vip_seconds;
            }
        }
    }];
}

#pragma readerContentViewModel action
- (void)switchBookChaptrInIndex:(NSInteger)index{
    if (self.model.currentChapter == index) return;
    self.model.isEnd = NO;
    self.model.isAdPage = NO;
    self.model.currentPage = 0;
    self.model.offsetY = 0;
    self.model.readPageNum = 0;
    [self.model onlySetChapterIndex:index];
    
    self.readerVc.view.hidden = YES;
    self.readerContentViewModel.chapterNameView.hidden = YES;
    self.readerContentViewModel.batteryDateView.hidden = YES;
    [self getBookContentDataSource];
}

- (void)switchReaderTransitionStyleSwitch:(BOOL)isSwitch{
    UIApplication.sharedApplication.idleTimerDisabled = NO;
    for (UIViewController *childVc in self.childViewControllers) {
        [childVc removeFromParentViewController];
        [childVc.view removeFromSuperview];
    }
    
    NSInteger turnStyle = DBReadBookSetting.setting.turnStyle;
    switch (turnStyle) {
        case 0:
        {
            self.readerVc = [[DBPageCoverViewController alloc] init];
            self.model.offsetY = 0;
        }
            break;
        case 1:
        {
            self.readerVc = [[DBPageLinearViewController alloc] init];
            self.model.offsetY = 0;
        }
            break;
        case 2:
        {
            DBPageRollingViewController *readerVc = [[DBPageRollingViewController alloc] init];
            readerVc.readerContentViewModel = self.readerContentViewModel;
            self.readerVc = readerVc;
        }
            break;
        default:
            break;
    }
    
    [self addChildViewController:self.readerVc];
    [self.view insertSubview:self.readerVc.view atIndex:0];
    self.readerVc.view.frame = self.view.bounds;
    
    if (isSwitch) [self updateReaderController];
}

- (void)switchReaderAutoScanStyle{
    UIApplication.sharedApplication.idleTimerDisabled = YES;
    [self.readerContentViewModel removeReaderPanelView];
    for (UIViewController *childVc in self.childViewControllers) {
        [childVc removeFromParentViewController];
        [childVc.view removeFromSuperview];
    }
    
    DBAutoScanViewController *autoScanVc = [[DBAutoScanViewController alloc] init];
    self.readerVc = autoScanVc;
    [self addChildViewController:self.readerVc];
    [self.view insertSubview:self.readerVc.view atIndex:0];
    self.readerVc.view.frame = self.view.bounds;
    self.model.isEnd = NO;
    self.model.isAdPage = NO;
    self.model.readPageNum = 0;
    [self updateReaderController];
    
    DBWeakSelf
    autoScanVc.finishAutoScanBlock = ^{
        DBStrongSelfElseReturn
        [self switchReaderTransitionStyleSwitch:YES];
    };
}

- (void)switchReaderAudiobookStyle{
    UIApplication.sharedApplication.idleTimerDisabled = NO;
    [self.readerContentViewModel removeReaderPanelView];
    for (UIViewController *childVc in self.childViewControllers) {
        [childVc removeFromParentViewController];
        [childVc.view removeFromSuperview];
    }
    
    DBAudiobookViewController *audiobookVc = [[DBAudiobookViewController alloc] init];
    self.readerVc = audiobookVc;
    [self addChildViewController:self.readerVc];
    [self.view insertSubview:self.readerVc.view atIndex:0];
    self.readerVc.view.frame = self.view.bounds;
    self.model.isEnd = NO;
    self.model.isAdPage = NO;
    self.model.readPageNum = 0;
    [self updateReaderController];
    
    DBWeakSelf
    audiobookVc.finishAudiobookBlock = ^{
        DBStrongSelfElseReturn
        [self switchReaderTransitionStyleSwitch:YES];
    };
}

- (void)updateReaderController{
    [self.model updateReaderModelData];
    [self updateReaderData];
}

- (void)updateReaderData{
    self.readerContentViewModel.chapterNameView.nameStr = self.model.title;
    if ([self.readerVc isKindOfClass:DBPageRollingViewController.class]) {
        self.readerContentViewModel.batteryDateView.pageStr = @"";
    }else{
        self.readerContentViewModel.batteryDateView.pageStr = [NSString stringWithFormat:@"第%ld/%ld页",MIN(self.model.currentPage+1, self.model.contentList.count),self.model.contentList.count];
    }
    
    ((DBPageLinearViewController *)self.readerVc).model = self.model;
}

#pragma mark - cache reader data
- (void)appDidEnterBackgroundNotification:(NSNotification *)noti{
    [self cacheReaderBookData];
}

- (void)applicationWillEnterForeground:(NSNotification *)noti{
    self.begainTime = NSDate.new;
}

- (void)applicationWillTerminate:(NSNotification *)noti{
    [self cacheReaderBookData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.begainTime = NSDate.new;
    [self cacheReaderBookData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self cacheReaderBookData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self cacheReaderBookPartData];
}

- (void)cacheReaderBookData{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    NSDate *endTime = NSDate.new;
    NSInteger timeInterval = [endTime timeIntervalSinceDate:self.begainTime];

    setting.readTotalTime += timeInterval;
    [setting reloadSetting];
    
    self.book.read_time = self.book.read_time+timeInterval;
    self.book.updateTime = endTime.timeStampInterval;
    self.book.lastReadTime = endTime.timeStampInterval;
    
    [self cacheReaderBookPartData];
}

- (void)cacheReaderBookPartData{
    self.book.page_index = self.model.currentPage;
    self.book.chapter_index = self.model.currentChapter;
    self.book.readChapterName = self.model.title;
    self.book.pageOffsetY = self.model.offsetY;
    [self.book updateCollectBook];
    [self.book updateReadingBook];
}

- (DBReaderModel *)model{
    if (!_model){
        _model = [[DBReaderModel alloc] init];
    }
    return _model;
}

- (DBEmptyView *)errorDataView{
    if (!_errorDataView){
        _errorDataView = [[DBEmptyView alloc] init];
        _errorDataView.imageObj = [UIImage imageNamed:@"empty_icon"];
        _errorDataView.content = [NSString stringWithFormat:@"加载第%ld章节失败",self.model.currentChapter+1];
        _errorDataView.reloadButton.hidden = NO;
        [self.view addSubview:_errorDataView];
        [_errorDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        DBWeakSelf
        _errorDataView.reloadBlock = ^{
            DBStrongSelfElseReturn
            [self getDataSource];
        };
    }
    return _errorDataView;
}

- (DBReaderContentViewModel *)readerContentViewModel{
    if (!_readerContentViewModel){
        _readerContentViewModel = [[DBReaderContentViewModel alloc] init];
        _readerContentViewModel.readerVc = self;
        
        DBWeakSelf
        _readerContentViewModel.menuBlock = ^(DBMenuType type, NSInteger index) {
            DBStrongSelfElseReturn
            
            switch (type) {
                case DBMenuChangeChapter:
                    [self switchBookChaptrInIndex:index];
                    break;
                case DBMenuChangeTransition:
                    [self switchReaderTransitionStyleSwitch:YES];
                    break;
                case DBMenuReaderAutomatic:
                    [self switchReaderAutoScanStyle];
                    break;
                case DBMenuReaderAudiobook:
                    [self switchReaderAudiobookStyle];
                    break;
                case DBMenuChangeFont:
                case DBMenuChangeBackgroundColor:
                    [self updateReaderController];
                    break;
                default:
                    break;
            }
        };
    }
    return _readerContentViewModel;
}

- (DBReaderAdViewModel *)readerAdViewModel{
    if (!_readerAdViewModel){
        _readerAdViewModel = [[DBReaderAdViewModel alloc] init];
        _readerAdViewModel.readerVc = self;
    }
    return _readerAdViewModel;
}



- (NSMutableSet *)loadingSet{
    if (!_loadingSet){
        _loadingSet = [NSMutableSet set];
    }
    return _loadingSet;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    NSArray *keyPaths = @[@"isEnd",@"currentPage",@"currentChapter",@"isAdPage"];
    [keyPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.model removeObserver:self forKeyPath:obj];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSString *duration = [NSString stringWithFormat:@"%ld",DBUnityAdConfig.manager.cumulativeTime - self.model.cumulativeTime];
    [DBAFNetWorking postServiceRequestType:DBUserClickReport combine:nil parameInterface:@{@"action":@"readDuration",@"userID":DBCommonConfig.userId,@"bookID":DBSafeString(self.book.book_id),@"duration":duration} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
    }];
}


- (void)reportBookChapterInfo{
    [DBAFNetWorking postServiceRequestType:DBUserClickReport combine:nil parameInterface:@{@"action":@"readChapter",@"userID":DBCommonConfig.userId,@"bookID":DBSafeString(self.model.bookId),@"bookName":DBSafeString(self.model.bookName),@"chapter":DBSafeString(self.model.title)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
    }];
}

@end
