//
//  DBBookDetailViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBookDetailViewController.h"
#import "DBBookDetailModel.h"
#import "DBBookDetailBannerTableViewCell.h"
#import "DBBookIntroductionTableViewCell.h"
#import "DBBookDetailTableViewCell.h"
#import "DBRecommendBooksTableViewCell.h"
#import "DBBookSocreTableViewCell.h"
#import "DBAdBannerTableViewCell.h"

#import "DBBookCommentModel.h"
#import "DBCommentPanView.h"
#import "DBConventionView.h"

#import "DBReadBookSetting.h"
#import "DBAdReadSetting.h"
@interface DBBookDetailViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *books;

@property (nonatomic, strong) NSArray *commentList;

@property (nonatomic, assign) NSInteger totalComment;

@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) NSArray *modeDataList;

@property (nonatomic, strong) UIView *topGridAdView;
@property (nonatomic, strong) UIView *centerGridAdView;

@property (nonatomic, strong) UIView *topAdView;
@property (nonatomic, strong) UIView *centerAdView;
@property (nonatomic, strong) UIView *bottomAdView;

@property (nonatomic, strong) UIButton *bookselfButton;
@property (nonatomic, strong) UIButton *readButton;

@property (nonatomic, assign) BOOL haveRemoved;
@property (nonatomic, assign) BOOL needShowAdView;
@property (nonatomic, assign) NSInteger cumulativeTime;
@property (nonatomic, strong) UIView *gradientColorView;
@end

@implementation DBBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
    [self loadingTopAdView:YES];
    [self loadingBannerAdView];
    [DBUnityAdConfig.manager preloadingRewardAdPreLoadSpaceType:DBAdSpaceAddToBookshelf];
    
    [DBCommonConfig fiveStarPraise];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondsTimeChange) name:DBsecondsTimeChange object:nil];
}

- (void)slotAdShow{
    DBAdPosModel *posAdReder = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceEnterBookDetailPage];
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
    DBWeakSelf
    [DBUnityAdConfig.manager openSlotAdSpaceType:DBAdSpaceEnterBookDetailPage showAdController:self completion:^(BOOL removed) {
        if (removed) return;
        DBStrongSelfElseReturn
        [DBUnityAdConfig.manager.apperTimeDict setValue:@(DBUnityAdConfig.manager.cumulativeTime) forKey:NSStringFromClass(self.class)];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self slotAdShow];
    
    DBBookModel *book = [DBBookModel getReadingBookWithId:self.bookId];
    NSString *readString = [NSString stringWithFormat:@"%@阅读",DBCommonConfig.shieldFreeString];
    if (book.site_path){
        readString = [NSString stringWithFormat:@"续看%ld章",book.chapter_index+1];
    }
    [self.readButton setTitle:readString.textMultilingual forState:UIControlStateNormal];
}

- (void)setUpSubViews{
    UIView *gradientColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarHeight+222)];
    self.gradientColorView = gradientColorView;
    [self.view addSubviews:@[gradientColorView,self.listRollingView,self.bottomView,self.topView]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(54+(UIScreen.tabbarSafeHeight?:10));
        make.top.mas_equalTo(self.listRollingView.mas_bottom);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(UIScreen.navbarHeight);
    }];
    
    DBBookModel *book = [DBBookModel getReadingBookWithId:self.bookId];
    if (book){
        [self.readButton setTitle:[NSString stringWithFormat:@"续看%ld章",book.chapter_index+1] forState:UIControlStateNormal];
    }
}

- (void)secondsTimeChange{
    DBAdPosModel *posAdBottom = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceBookDetailBottom];
    NSInteger interval = posAdBottom.extra.interval;

    NSInteger diffSecond = DBUnityAdConfig.manager.cumulativeTime - self.cumulativeTime;
    if (interval && diffSecond && (diffSecond % interval == 0)){
        self.adContainerView = nil;
        [self loadingBannerAdView];
    }
}

- (void)loadingBannerAdView{
    if (self.haveRemoved) return;
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceBookDetailBottom showAdController:self reload:YES completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (self.haveRemoved) return;
        
        if ([self.adContainerView isEqual:adContainerView]){
            self.haveRemoved = YES;
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.listRollingView.mas_bottom);
            }];
            [self.adContainerView removeFromSuperview];
        }else{
            for (UIView *subview in self.view.subviews) {
                if ([subview isEqual:self.leftButton]) continue;
                if ([subview isEqual:self.topView]) continue;
                if ([subview isEqual:self.bottomView]) continue;
                if ([subview isEqual:self.listRollingView]) continue;
                [subview removeFromSuperview];
            }
            
            self.adContainerView = adContainerView;
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(self.listRollingView.mas_bottom);
                make.size.mas_equalTo(adContainerView.size);
            }];
            
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.listRollingView.mas_bottom).offset(adContainerView.size.height);
            }];
        }
    }];
}

- (void)loadingTopAdView:(BOOL)reload{
    DBWeakSelf
    [DBUnityAdConfig.manager openExpressAdsSpaceType:DBAdSpaceBookDetailPageTop showAdController:self reload:reload completion:^(NSArray<UIView *> * _Nonnull adViews) {
        DBStrongSelfElseReturn
        UIView *adContainerView = adViews.firstObject;
        if ([self.topAdView isEqual:adContainerView]){
            self.topAdView = nil;
        }else{
            
            if ([adContainerView isKindOfClass:DBAdBannerView.class])[adContainerView dynamicAllusionTomethod:@"registerAdView:" object:self];
            self.topAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];
    [DBUnityAdConfig.manager openExpressAdsSpaceType:DBAdSpaceBookDetailPageMiddle showAdController:self reload:reload completion:^(NSArray<UIView *> * _Nonnull adViews) {
        DBStrongSelfElseReturn
        UIView *adContainerView = adViews.firstObject;
        if ([self.centerAdView isEqual:adContainerView]){
            self.centerAdView = nil;
        }else{
            
            if ([adContainerView isKindOfClass:DBAdBannerView.class])[adContainerView dynamicAllusionTomethod:@"registerAdView:" object:self];
            self.centerAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];
    
    [DBUnityAdConfig.manager openExpressAdsSpaceType:DBAdSpaceBookDetailPageBottom showAdController:self reload:reload completion:^(NSArray<UIView *> * _Nonnull adViews) {
        DBStrongSelfElseReturn
        UIView *adContainerView = adViews.firstObject;
        if ([self.bottomAdView isEqual:adContainerView]){
            self.bottomAdView = nil;
        }else{
            
            if ([adContainerView isKindOfClass:DBAdBannerView.class])[adContainerView dynamicAllusionTomethod:@"registerAdView:" object:self];
            self.bottomAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];
    
    [DBUnityAdConfig.manager openGridAdSpaceType:DBAdSpaceBookDetailTopGrid reload:YES completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if ([self.topGridAdView isEqual:adContainerView]){
            self.topGridAdView = nil;
        }else{
            self.topGridAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];
    
    [DBUnityAdConfig.manager openGridAdSpaceType:DBAdSpaceBookDetailMiddleGrid reload:YES completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if ([self.centerGridAdView isEqual:adContainerView]){
            self.centerGridAdView = nil;
        }else{
            self.centerGridAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];
}

- (void)reloadModelAdData{
    NSMutableArray *data = [NSMutableArray arrayWithArray:self.modeDataList];
    
    if (data)
        if (self.centerAdView && self.modeDataList.count > 2){
            [data insertObject:self.centerAdView atIndex:2];
        }
    if (self.centerGridAdView && self.modeDataList.count > 2){
        [data insertObject:self.centerGridAdView atIndex:2];
    }
    if (self.topAdView && self.modeDataList.count){
        [data insertObject:self.topAdView atIndex:1];
    }
    if (self.topGridAdView && self.modeDataList.count){
        [data insertObject:self.topGridAdView atIndex:1];
    }
    if (self.bottomAdView && self.modeDataList.count > 2){
        [data insertObject:self.bottomAdView atIndex:data.count-1];
    }
    
    self.dataList = data;
    [self.listRollingView reloadData];
}

- (void)getDataSource{
    [self.view showHudLoading];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [DBAFNetWorking getServiceRequestType:DBLinkBookDetailData combine:self.bookId parameInterface:nil modelClass:DBBookDetailModel.class serviceData:^(BOOL successfulRequest, DBBookDetailModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            if (DBCommonConfig.appConfig.force.shield_switch &&
                ([result.shield_data containsObject:@"2"] || [result.shield_data containsObject:@2])){
                [DBRouter closePage];
                [UIScreen.appWindow showAlertText:@"该书籍已下架"];
                dispatch_group_leave(group);
                return;
            }
            
            self.navLabel.text = result.name;
            self.books = [DBBookDetailModel getAllCollectBooks];
            self.bookselfButton.selected = [self.books containIvar:@"book_id" value:result.book_id];
            
            NSMutableArray *dataList = [NSMutableArray array];
            [dataList addObject:result];
            [dataList addObject:result];
            
            self.totalComment = result.comment_number;
            
            //评分
            if (!DBCommonConfig.switchAudit){
                [dataList addObject:@[]];
            }
            
            if (result.author_book.count) {
                DBBookDetailCustomModel *model = DBBookDetailCustomModel.new;
                model.name = @"作者其他书籍";
                model.bookList = result.author_book;
                [dataList addObject:model];
            }
            if (result.relevant_book.count) {
                DBBookDetailCustomModel *model = DBBookDetailCustomModel.new;
                model.name = @"您可能感兴趣的书";
                model.bookList = result.relevant_book;
                [dataList addObject:model];
            }
            self.modeDataList = dataList;
        }else{
            [self.view showAlertText:message];
        }
        dispatch_group_leave(group);
    }];
    
    if (!DBCommonConfig.switchAudit){
        dispatch_group_enter(group);
        [DBAFNetWorking getServiceRequestType:DBLinkBookDetailCommentList combine:self.bookId parameInterface:nil modelClass:DBBookCommentModel.class serviceData:^(BOOL successfulRequest, NSArray *result, NSString * _Nullable message) {
            if (successfulRequest){
                self.commentList = result?:@[];
            }else{
                [self.view showAlertText:message];
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.commentList.count > 2){
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.modeDataList];
            [dataList replaceObjectAtIndex:2 withObject:self.commentList];
            self.modeDataList = dataList;
        }
        [self.view removeHudLoading];
        [self reloadModelAdData];
    });
}

- (void)clickCollectAction{
    if (self.bookselfButton.selected){
        if (DBCommonConfig.isLogin){
            [self.view showHudLoading];
            NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.bookId),@"form":@"1"};
            [DBAFNetWorking postServiceRequestType:DBLinkBookShelfBookDelete combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
                [self.view removeHudLoading];
                if (successfulRequest){
                    [self removeBook];
                }else{
                    [self.view showAlertText:message];
                }
            }];
        }else{
            [self removeBook];
        }
    }else{
        [self canCollectBookSelf];
    }
}

- (void)canCollectBookSelf{
    DBAdReadSetting *adSetting = DBAdReadSetting.setting;
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceAddToBookshelf];
    if (DBUnityAdConfig.openAd && posAd.ads.count && adSetting.addBookshelfCount >= posAd.extra.free_count){
        DBWeakSelf
        
        self.bookselfButton.userInteractionEnabled = NO;
        [DBUnityAdConfig.manager openRewardAdSpaceType:DBAdSpaceAddToBookshelf completion:^(BOOL removed) {
            DBStrongSelfElseReturn
            self.bookselfButton.userInteractionEnabled = YES;
            
            if (removed) {
                adSetting.addBookshelfCount -= MAX(1, posAd.extra.limit);
                [adSetting reloadSetting];
                DBCommonConfig.isLogin ? [self collectBookServer] : [self collectBook];
            }
        }];
    }else{
        DBCommonConfig.isLogin ? [self collectBookServer] : [self collectBook];
    }
}

- (void)collectBookServer{
    [self.view showHudLoading];
    NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.bookId),@"form":@"1"};
    [DBAFNetWorking postServiceRequestType:DBLinkBookShelfBookAdd combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            [self collectBook];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)collectBook{
    DBBookDetailModel *bookModel = self.dataList.firstObject;
    
    bookModel.collectDate = NSDate.currentInterval;
    bookModel.updateTime = NSDate.currentInterval;
    BOOL successfulRequest = [bookModel insertCollectBook];
    
    if (successfulRequest){
        [self.view showAlertText:@"已加入书架"];
        self.bookselfButton.selected = YES;
        DBAdReadSetting *adSetting = DBAdReadSetting.setting;
        adSetting.addBookshelfCount += 1;
        [adSetting reloadSetting];
    }else{
        [self.view showAlertText:@"加入书架失败"];
    }
}

- (void)removeBook{
    DBBookDetailModel *bookModel = self.dataList.firstObject;
    BOOL successfulRequest = [bookModel removeCollectBook];
    if (successfulRequest){
        [self.view showAlertText:@"已从书架移除"];
        self.bookselfButton.selected = NO;
    }else{
        [self.view showAlertText:@"从书架移除失败"];
    }
}

- (void)clickReadAction{
    DBBookModel *book = [DBBookModel getReadingBookWithId:self.bookId];
    if (book.site_path){
        [DBRouter openPageUrl:DBReadBookPage params:@{@"book":book}];
    }else{
        DBBookDetailModel *bookModel = self.dataList.firstObject;
        if (bookModel) [DBRouter openPageUrl:DBBookSource params:@{@"book":bookModel,kDBRouterDrawerSideslip:@1}];
    }
    

    DBBookDetailModel *bookModel = self.dataList.firstObject;
    [DBAFNetWorking postServiceRequestType:DBUserClickReport combine:nil parameInterface:@{@"action":@"click",@"userID":DBCommonConfig.userId,@"bookID":DBSafeString(bookModel.book_id),@"bookName":DBSafeString(bookModel.name),@"bookAuthor":DBSafeString(bookModel.author)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        
    }];
}

- (void)clickShareAction{
    [DBCommonConfig showShareView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row){
        id model = self.dataList[indexPath.row];
        if ([model isKindOfClass:[UIView class]]) {
            DBAdBannerTableViewCell *cell = [DBAdBannerTableViewCell initWithTableView:tableView];
            cell.objView = (UIView *)model;
            return cell;
        }
        
        if ([model isKindOfClass:[DBBookDetailCustomModel class]]){
            DBRecommendBooksTableViewCell *cell = [DBRecommendBooksTableViewCell initWithTableView:tableView];
            cell.model = model;
            return cell;
        }else if ([model isKindOfClass:[DBBookDetailModel class]]){
            DBBookDetailTableViewCell *cell = [DBBookDetailTableViewCell initWithTableView:tableView];
            cell.model = self.dataList[indexPath.row];
            
            DBWeakSelf
            cell.remarkBlock = ^{
                DBStrongSelfElseReturn
                [self.listRollingView reloadData];
            };
            return cell;
        }else {
            DBBookSocreTableViewCell *cell = [DBBookSocreTableViewCell initWithTableView:tableView];
            cell.total = self.totalComment;
            cell.commentList = self.commentList;
            cell.bookName = DBSafeString(self.navLabel.text);
            DBWeakSelf
            cell.commentListBlock = ^{
                DBStrongSelfElseReturn
                [DBRouter openPageUrl:DEBookComment params:@{@"book":self.dataList.firstObject}];
            };
            
            cell.commentInputBlock = ^(CGFloat score) {
                DBStrongSelfElseReturn
                
                [DBConventionView conventionViewCompletion:^(BOOL finished) {
                    DBCommentPanView *commentView = [[DBCommentPanView alloc] init];
                    commentView.book_id = self.bookId;
                    commentView.score = score;
                    [commentView presentInView:UIScreen.appWindow];
                    DBWeakSelf
                    commentView.commentCompletedBlock = ^(BOOL commentCompleted) {
                        DBStrongSelfElseReturn
                        [self getDataSource];
                    };
                }];
            };
            return cell;
        }
    }else{
        DBBookIntroductionTableViewCell *cell = [DBBookIntroductionTableViewCell initWithTableView:tableView];
        cell.model = self.dataList[indexPath.row];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alpha = MIN(1, scrollView.contentOffset.y/120)*0.8;
    if (DBColorExtension.userInterfaceStyle) {
        self.topView.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    }else{
        self.topView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    }
    self.navLabel.alpha = alpha;
}

- (UIView *)topView{
    if (!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        [_topView addSubview:self.navLabel];
        self.navLabel.alpha = 0;
        [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(UIScreen.navbarSafeHeight);
            make.height.mas_equalTo(UIScreen.navbarNetHeight);
        }];
        
        if (!DBCommonConfig.switchAudit){
            UIButton *shareButton = [[UIButton alloc] init];
            self.shareButton = shareButton;
            [shareButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
            [shareButton addTarget:self action:@selector(clickShareAction) forControlEvents:UIControlEventTouchUpInside];
            [_topView addSubview:shareButton];
            [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-16);
                make.centerY.mas_equalTo(self.navLabel);
            }];
        }
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        NSArray *bottomButtons = @[self.bookselfButton,self.readButton];
        [_bottomView addSubviews:bottomButtons];
        [bottomButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:16 leadSpacing:16 tailSpacing:16];
        [bottomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(44);
        }];
    }
    return _bottomView;
}

- (UIButton *)bookselfButton{
    if (!_bookselfButton){
        _bookselfButton = [[UIButton alloc] init];
        _bookselfButton.titleLabel.font = DBFontExtension.titleSmallFont;
        _bookselfButton.backgroundColor = DBColorExtension.whiteColor;
        _bookselfButton.layer.cornerRadius = 10;
        _bookselfButton.layer.masksToBounds = YES;
        [_bookselfButton setTitle:@"加入书架" forState:UIControlStateNormal];
        [_bookselfButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_bookselfButton setTitle:@"移除书架" forState:UIControlStateSelected];
        [_bookselfButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateSelected];
        
        [_bookselfButton addTarget:self action:@selector(clickCollectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookselfButton;
}

- (UIButton *)readButton{
    if (!_readButton){
        _readButton = [[UIButton alloc] init];
        NSString *readString = [NSString stringWithFormat:@"%@阅读",DBCommonConfig.shieldFreeString];
        _readButton.titleLabel.font = DBFontExtension.titleSmallFont;
        _readButton.backgroundColor = DBColorExtension.redColor;
        _readButton.layer.cornerRadius = 10;
        _readButton.layer.masksToBounds = YES;
        [_readButton setTitle:readString forState:UIControlStateNormal];
        [_readButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_readButton addTarget:self action:@selector(clickReadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readButton;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.espressoColor endColor:DBColorExtension.blackColor];
        [self.shareButton setImage:[[UIImage imageNamed:@"share_icon"] imageWithTintColor:DBColorExtension.whiteColor] forState:UIControlStateNormal];
    }else{
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.shellPinkColor endColor:DBColorExtension.whiteColor];
        [self.shareButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    }
}

@end
