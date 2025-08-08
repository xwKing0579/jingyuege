//
//  DBMyBooksViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBMyBooksViewController.h"
#import "DBCollectBooksCollectionViewCell.h"
#import "DBCollectBooksExpandCollectionViewCell.h"
#import "DBBookAddCollectionViewCell.h"
#import "DBBookAddExpandCollectionViewCell.h"
#import "DBBooksMenuView.h"
#import "DBReadBookSetting.h"

#import "DBBookChapterModel.h"
#import "DBAdBannerCollectionViewCell.h"

#import "DBMarqueeLabel.h"
#import <SAMKeychain/SAMKeychain.h>
static NSString *identifierCollectCell = @"DBCollectBooksCollectionViewCell";
static NSString *identifier2CollectCell = @"DBCollectBooksExpandCollectionViewCell";
static NSString *identifier3CollectCell = @"DBBookAddCollectionViewCell";
static NSString *identifier4CollectCell = @"DBBookAddExpandCollectionViewCell";
static NSString *identifierAdCollectCell = @"DBAdBannerCollectionViewCell";


@interface DBMyBooksViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *myBookCollectionView;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) DBBooksMenuView *menuView;

@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;

@property (nonatomic, strong) NSDictionary *adViewListDict;
@property (nonatomic, strong) NSArray *modeList;

@property (nonatomic, assign) BOOL needShowAdView;

@property (nonatomic, strong) DBMarqueeLabel *marqueeView;
@property (nonatomic, strong) UIView *gradientColorView;
@end

@implementation DBMyBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadingBookSelfAdView:NO];
        [self loadingTopAdView:YES];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadCollectBooksList];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self secondsTimeChange];
    if (self.marqueeView) [self.marqueeView startMarquee];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.marqueeView) [self.marqueeView stopMarquee];

}

- (void)secondsTimeChange{
    DBAdPosModel *posAdReder = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceEnterBookshelfPage];
    NSInteger interval = posAdReder.extra.interval;
    NSInteger cumulativeTime = [[DBUnityAdConfig.manager.apperTimeDict valueForKey:NSStringFromClass(self.class)] intValue];
    NSInteger nowTime = DBUnityAdConfig.manager.cumulativeTime;
    if (interval && nowTime - cumulativeTime > interval*60){
        self.needShowAdView = YES;
        [self openAdSpaceEnterBookshelfPage];
    }
}

- (void)openAdSpaceEnterBookshelfPage{
    if (!self.needShowAdView) return;
    self.needShowAdView = NO;
    [DBUnityAdConfig.manager openSlotAdSpaceType:DBAdSpaceEnterBookshelfPage showAdController:self completion:^(BOOL removed) {
        if (removed) return;
        [DBUnityAdConfig.manager.apperTimeDict setValue:@(DBUnityAdConfig.manager.cumulativeTime) forKey:NSStringFromClass(self.class)];
    }];
}

- (void)reloadCollectBooksList{
    NSMutableArray *dataList = [NSMutableArray arrayWithArray:DBBookModel.getAllCollectBooks];
    [dataList enumerateObjectsUsingBlock:^(DBBookModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.lastReadTime > 0){
            obj.isLastRead = YES;
            *stop = YES;
        }
    }];
    NSArray *cultivatelist = DBBookModel.getAllCultivateBooks;
    if (cultivatelist.count) {
        DBBookModel *model = [[DBBookModel alloc] init];
        model.isLocal = YES;
        model.name = DBConstantString.ks_savingStatus;
        model.site_path = DBMyCultivateBooks;
        model.author = [NSString stringWithFormat:DBConstantString.ks_savedBooksCount,cultivatelist.count];
        [dataList insertObject:model atIndex:0];
    }
    self.modeList = dataList;
    
    [self dataListReorder];
}

- (void)setUpSubViews{
    self.title = DBConstantString.ks_shelf;
    UIView *gradientColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarHeight+64)];
    self.gradientColorView = gradientColorView;
    [self.view addSubviews:@[gradientColorView,self.navLabel,self.myBookCollectionView,self.moreButton]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.myBookCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.navLabel);
    }];
    
    self.moreButton.hidden = DBCommonConfig.allFunctionSwitchAudit;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginSuccess) name:DBUserLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadCollectBooksList) name:DBUpdateCollectBooks object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateMarqueeView) name:DBUpdateMarqueeContent object:nil];
}

- (void)updateMarqueeView{
    self.marqueeView = [[DBMarqueeLabel alloc] init];
    self.marqueeView.alpha = 0.6;
    [self.view addSubview:self.marqueeView];
    [self.marqueeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    if (self.adContainerView){
        [self.view addSubview:self.adContainerView];
        [self.adContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(self.adContainerView.size);
            make.top.mas_equalTo(self.navLabel.mas_bottom).offset(30);
        }];
        
        [self.myBookCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navLabel.mas_bottom).offset(self.adContainerView.size.height+40);
        }];
    }else{
        [self.myBookCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navLabel.mas_bottom).offset(40);
        }];
    }
    [self.marqueeView startMarquee];
}

- (void)loadingTopAdView:(BOOL)reload{
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceBookshelfTop showAdController:self reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (!adContainerView) return;
        if (self.adContainerView && ![self.adContainerView isEqual:adContainerView]) return;
        BOOL haveMarqueeView = DBAppSetting.setting.marqueeContent.length > 0;
        if ([self.adContainerView isEqual:adContainerView]){
            [self.myBookCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (haveMarqueeView){
                    make.top.mas_equalTo(self.navLabel.mas_bottom).offset(40);
                }else{
                    make.top.mas_equalTo(self.navLabel.mas_bottom);
                }
            }];
            [self.adContainerView removeFromSuperview];
            self.adContainerView = nil;
        }else{
            self.adContainerView = adContainerView;
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(adContainerView.size);
                if (haveMarqueeView){
                    make.top.mas_equalTo(self.navLabel.mas_bottom).offset(30);
                }else{
                    make.top.mas_equalTo(self.navLabel.mas_bottom);
                }
            }];
            [self.myBookCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (haveMarqueeView){
                    make.top.mas_equalTo(self.navLabel.mas_bottom).offset(adContainerView.size.height+40);
                }else{
                    make.top.mas_equalTo(self.navLabel.mas_bottom).offset(adContainerView.size.height+10);
                }
            }];
        }
    }];
}

- (void)loadingBookSelfAdView:(BOOL)reload{
    DBAdSpaceType spaceTyoe = DBAdSpaceBookshelfListModeMiddle;
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceTyoe];
    NSInteger interval = posAd.extra.interval;

    if (interval > 1){
        NSInteger compart = self.modeList.count/interval-self.adViewListDict.allKeys.count;
        if (compart) [self loadingBookSelfAdView:reload compart:compart-1];
    }
}

- (void)loadingBookSelfAdView:(BOOL)reload compart:(NSInteger)compart{
    DBWeakSelf
    DBAdSpaceType spaceTyoe = DBAdSpaceBookshelfListModeMiddle;
    [DBUnityAdConfig.manager openBannerAdSpaceType:spaceTyoe showAdController:self reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
       
        NSMutableDictionary *adViewListDict = [NSMutableDictionary dictionaryWithDictionary:self.adViewListDict];
        if ([adViewListDict.allValues containsObject:adContainerView]){
            __block NSString *foundKey = nil;
            [adViewListDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                if ([obj isEqual:adContainerView]) {
                    foundKey = key;
                    *stop = YES;
                }
            }];
            if (foundKey) [adViewListDict removeObjectForKey:foundKey];
        }else{
            NSInteger count = adViewListDict.allKeys.count+1;
            [adViewListDict setObject:adContainerView forKey:@(count)];
        }
        
        self.adViewListDict = adViewListDict;
        [self dataListReorder];
        if (compart > 0) [self loadingBookSelfAdView:YES compart:compart-1];
    }];
}

- (void)dataListReorder{
    self.isExpand = [NSUserDefaults boolValueForKey:DBBooksExpandValue];
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceBookshelfListModeMiddle];
    NSInteger interval = posAd.extra.interval;

    if (self.isExpand && self.modeList.count > 0) {
        NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.modeList];
        NSInteger k = 1;
        while (k * interval + (k - 1) <= dataList.count) {
            NSInteger insertPos = k * interval + (k - 1);
            UIView *insertView = [self.adViewListDict objectForKey:@(k)];
            if (insertView) [dataList insertObject:insertView atIndex:insertPos];
            k++;
        }
        self.dataList = dataList;
    }else{
        self.dataList = self.modeList;
    }
    
    [self.myBookCollectionView reloadData];
}

- (void)userLoginSuccess{
    [DBAFNetWorking getServiceRequestType:DBLinkBookShelfList combine:nil parameInterface:nil modelClass:DBBookModel.class serviceData:^(BOOL successfulRequest,NSArray *result, NSString * _Nullable message) {
        if (successfulRequest){
            [DBBookModel insertCollectBooks:result];
            [self reloadCollectBooksList];

            NSMutableArray *bookIds = [NSMutableArray array];
            for (DBBookModel *model in result) {
                if (model.book_id) [bookIds addObject:model.book_id];
            }
            [self uploadCacheBooks:bookIds];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)uploadCacheBooks:(NSArray *)books{
    NSArray *bookList = DBBookModel.getAllCollectBooks;
    for (DBBookModel *model in bookList) {
        if (![books containsObject:model.book_id]){
            NSDictionary *parameInterface = @{@"book_id":DBSafeString(model.book_id),@"form":@"1"};
            [DBAFNetWorking postServiceRequestType:DBLinkBookShelfBookAdd combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
            }];
        }
    }
}


- (void)menuViewPop{
    DBBooksMenuView *menuView = [[DBBooksMenuView alloc] init];
    [UIScreen.appWindow addSubview:menuView];
    self.menuView = menuView;
    
    DBWeakSelf
    menuView.menuBlock = ^(NSInteger action) {
        DBStrongSelfElseReturn
        if (action == 0){
            [self dataListReorder];
        }else if (action == 1){
            DBWeakSelf
            LEEAlert.actionsheet.config.LeeTitle(DBConstantString.ks_sortBy).
            LeeAction(DBConstantString.ks_recentReads, ^{
                DBStrongSelfElseReturn
                DBReadBookSetting *setting = DBReadBookSetting.setting;
                setting.orderType = 0;
                [setting reloadSetting];
                [self reloadCollectBooksList];
            }).LeeAction(DBConstantString.ks_updatedTime, ^{
                DBStrongSelfElseReturn
                DBReadBookSetting *setting = DBReadBookSetting.setting;
                setting.orderType = 1;
                [setting reloadSetting];
                [self reloadCollectBooksList];
            }).LeeCancelAction(DBConstantString.ks_cancel, ^{
                
            }).LeeShow();
        }else if (action == 2){
            [DBRouter openPageUrl:DBReadRecord];
        }else if (action == 3){
            [DBRouter openPageUrl:DBMyBooksManager];
        }
    };
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isExpand){
        if (indexPath.row == self.dataList.count){
            DBBookAddExpandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier4CollectCell forIndexPath:indexPath];
            return cell;
        }else{
            NSObject *obj = self.dataList[indexPath.row];
            if ([obj isKindOfClass:[UIView class]]){
                DBAdBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierAdCollectCell forIndexPath:indexPath];
                cell.objView = (UIView *)obj;
                return cell;
            }else{
                DBCollectBooksExpandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2CollectCell forIndexPath:indexPath];
                cell.model = self.dataList[indexPath.row];
                return cell;
            }
        }
    }else{
        if (indexPath.row == self.dataList.count){
            DBBookAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier3CollectCell forIndexPath:indexPath];
            return cell;
        }else{
            DBCollectBooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCollectCell forIndexPath:indexPath];
            cell.model = self.dataList[indexPath.row];
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataList.count){
        self.tabBarController.selectedIndex = 1;
        return;
    }
    NSObject *obj = self.dataList[indexPath.row];
    if ([obj isKindOfClass:[UIView class]]) return;
    
    
    DBBookModel *model = self.dataList[indexPath.row];
    if (model.site_path){
        if ([model.site_path isEqualToString:DBMyCultivateBooks]){
            [DBRouter openPageUrl:DBMyCultivateBooks];
        }else{
            [DBRouter openPageUrl:DBReadBookPage params:@{@"book":model}];
        }
    }else{
        model.updateTime = NSDate.currentInterval;
        [model updateCollectBook];
        [DBRouter openPageUrl:DBBookSource params:@{@"book":model,kDBRouterDrawerSideslip:@1}];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isExpand && indexPath.row > self.dataList.count) {
        NSObject *obj = self.dataList[indexPath.row];
        if ([obj isKindOfClass:[UIView class]]){
            return ((UIView *)obj).size;
        }
    }
  
    CGFloat width = (UIScreen.screenWidth-60)/4;
    CGFloat height = width*5.0/4.0+50;
    return self.isExpand ? CGSizeMake(collectionView.width, width*5.0/4.0+20) : CGSizeMake(width, height);
}

- (UIButton *)moreButton{
    if (!_moreButton){
        _moreButton = [[UIButton alloc] init];
        _moreButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_moreButton setImage:[UIImage imageNamed:@"jjInfinityJuncture"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(menuViewPop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UICollectionView *)myBookCollectionView{
    if (!_myBookCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
        _myBookCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _myBookCollectionView.delegate = self;
        _myBookCollectionView.dataSource = self;
        _myBookCollectionView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _myBookCollectionView.showsVerticalScrollIndicator = NO;
        _myBookCollectionView.showsHorizontalScrollIndicator = NO;
        _myBookCollectionView.backgroundColor = DBColorExtension.noColor;
        [_myBookCollectionView registerClass:NSClassFromString(identifierCollectCell) forCellWithReuseIdentifier:identifierCollectCell];
        [_myBookCollectionView registerClass:NSClassFromString(identifier2CollectCell) forCellWithReuseIdentifier:identifier2CollectCell];
        [_myBookCollectionView registerClass:NSClassFromString(identifier3CollectCell) forCellWithReuseIdentifier:identifier3CollectCell];
        [_myBookCollectionView registerClass:NSClassFromString(identifier4CollectCell) forCellWithReuseIdentifier:identifier4CollectCell];
        [_myBookCollectionView registerClass:NSClassFromString(identifierAdCollectCell) forCellWithReuseIdentifier:identifierAdCollectCell];
    }
    return _myBookCollectionView;
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.espressoColor endColor:DBColorExtension.blackColor];
    }else{
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.shellPinkColor endColor:DBColorExtension.whiteColor];
    }
}

@end
