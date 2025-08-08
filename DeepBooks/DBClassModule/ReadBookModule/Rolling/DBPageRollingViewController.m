//
//  DBPageRollingViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/18.
//

#import "DBPageRollingViewController.h"
#import <IGListKit.h>
#import "DBReadBookSetting.h"
#import "DBReaderPageSectionController.h"
#import "DBBookCatalogModel.h"
#import "DBBookChapterModel.h"
#import "DBPageScrollCollectionViewCell.h"

@interface DBPageRollingViewController ()<IGListAdapterDataSource, IGListAdapterDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) IGListCollectionView *igCollectionView;
@property (nonatomic, strong) IGListAdapter *adapter;

@property (nonatomic, strong) NSMutableArray *chapterModelList;
@property (nonatomic, strong) NSMutableArray *updateModelList;
@property (nonatomic, assign) CGFloat rollingSpeed;
@property (nonatomic, assign) NSInteger starIndex;
@property (nonatomic, assign) NSInteger endIndex;

@property (nonatomic, assign) BOOL decelerate;
@property (nonatomic, assign) BOOL isUpdating;

@property (nonatomic, assign) CGFloat pageHeight;

@property (nonatomic, assign) DBReaderAdType readerAdType;
@property (nonatomic, strong) UIView *adContainerView;
@property (nonatomic, assign) NSInteger adShowSectionIndex;
@end

@implementation DBPageRollingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self loadRollingAd];
}

- (void)setUpSubViews{
    self.pageHeight = DBReadBookSetting.calculateCanvaseSize.height;
    [self.view addSubview:self.igCollectionView];
    
    if (DBReaderAdViewModel.gridEndReaderAd){
        self.readerAdType = DBReaderAdPageEndGrid;
    }else if (DBReaderAdViewModel.getReaderAdGridValue){
        self.readerAdType = DBReaderAdPageGrid;
    }else if (DBReaderAdViewModel.gridEndReaderAd){
        self.readerAdType = DBReaderAdPageEndSlot;
    }else if (DBReaderAdViewModel.getReaderAdSlotValue){
        self.readerAdType = DBReaderAdPageSlot;
    }

    DBWeakSelf
    self.igCollectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self.igCollectionView.mj_header endRefreshing];
        if (self.model.currentChapter == 0){
            [self.view showAlertText:DBConstantString.ks_firstPageReached];
        }
    }];
    
    self.igCollectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self.igCollectionView.mj_footer endRefreshing];
        if (self.model.currentChapter == self.model.chapterCacheList.count-1 && self.decelerate){
            [self.view showAlertText:@"已经最后一页"];
        }else{

        }
    }];
}

- (void)setModel:(DBReaderModel *)model{
    _model = model;
    [self reloadIGListData];
}

- (void)reloadIGListData {
    __weak typeof(self) weakSelf = self;
    [self.view showHudLoading];
    self.isUpdating = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;
        
        NSMutableArray <DBPageIGModel *> *newChapterModelList = [NSMutableArray array];
        NSInteger newStarIndex = self.model.chapterCacheList.count-1;
        NSInteger newEndIndex = 0;
        
        DBReadBookSetting *setting = DBReadBookSetting.setting;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = setting.lineSpacing;
        paraStyle.alignment = NSTextAlignmentJustified;
        
        for (NSInteger index = 0; index < self.model.chapterCacheList.count; index++) {
            DBBookCatalogModel *catalog = self.model.chapterCacheList[index];
            DBPageIGModel *model = [[DBPageIGModel alloc] init];
            model.sectionId = catalog.path;
            model.sectionIndex = index;
            model.title = [NSString stringWithFormat:@"\n%@\n\n\n", catalog.title];
            model.cellHeight = 0;
            model.adType = self.readerAdType;
            model.finish = NO;
            
            if (index >= self.model.currentChapter - 1 && index < self.model.currentChapter + 10) {
                DBBookChapterModel *chapterModel = [DBBookChapterModel getBookChapter:self.model.chapterForm chapterId:model.sectionId];
                if (chapterModel.body.length > 0) {
                    NSAttributedString *attributeString = [NSAttributedString combineAttributeTexts:@[DBSafeString(model.title), chapterModel.body]
                                                                                           colors:@[setting.textColor]
                                                                                            fonts:@[[UIFont fontWithName:setting.fontName size:setting.titleFontSize], [UIFont fontWithName:setting.fontName size:setting.textFontSize]]
                                                                                            attrs:@[@{}, @{NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: @(setting.wordSpacing)}]];
                    
                    CGFloat cellHeight = [DBReadBookSetting coreTextHeightForWidth:DBReadBookSetting.setting.canvasSize.width attributedString:attributeString];
                    model.finish = YES;
                    model.cellHeight = cellHeight;
                    model.content = attributeString;
                    
                    newStarIndex = MIN(newStarIndex, index);
                    newEndIndex = MAX(newEndIndex, index);
                }
            }
            
            [newChapterModelList addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            if (!self) return;
            
            [self.chapterModelList removeAllObjects];
            [self.chapterModelList addObjectsFromArray:newChapterModelList];
            self.starIndex = (newStarIndex != NSIntegerMax) ? newStarIndex : 0;
            self.endIndex = newEndIndex;
            
            [self.adapter reloadDataWithCompletion:^(BOOL finished) {
                if (finished) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:self.model.currentChapter];
                    [self.adapter.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                    
                    if (self.model.offsetY != 0) {
                        CGPoint offset = self.adapter.collectionView.contentOffset;
                        offset.y += self.model.offsetY;
                        [self.adapter.collectionView setContentOffset:offset animated:NO];
                    } else if (self.model.currentPage > 0) {
                        CGPoint offset = self.adapter.collectionView.contentOffset;
                        offset.y += self.model.currentPage * self.pageHeight;
                        [self.adapter.collectionView setContentOffset:offset animated:NO];
                    }
                    
                    self.isUpdating = NO;
                    [self.view removeHudLoading];
                }
            }];
        });
    });
}

- (void)downloadPreloadData {
    if (self.isUpdating) return;
    
    if (self.rollingSpeed >= 0) {
        if (self.endIndex - self.model.currentChapter > 5) {
            return;
        }
    }else{
        if (self.model.currentChapter - self.starIndex > 0) {
            return;
        }
    }
    
    self.isUpdating = YES;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;

        BOOL pullBack = self.rollingSpeed < 0;
        NSInteger start, end;
        
        if (pullBack) {
            if (self.starIndex <= 0) {
                self.isUpdating = NO;
                return;
            }
            end = MAX(0, self.starIndex - 1);
            start = MAX(0, end - 9);
        } else {
            if (self.endIndex >= self.model.chapterCacheList.count - 1) {
                self.isUpdating = NO;
                return;
            }
            start = MIN(self.endIndex + 1, self.model.chapterCacheList.count - 1);
            end = MIN(start + 9, self.model.chapterCacheList.count - 1);
        }

        if (start > end) {
            self.isUpdating = NO;
            return;
        }
        
        DBReadBookSetting *setting = DBReadBookSetting.setting;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = setting.lineSpacing;
        paraStyle.alignment = NSTextAlignmentJustified;
        
        dispatch_group_t group = dispatch_group_create();
        NSMutableArray *newModels = [NSMutableArray array];
        __block NSInteger newStarIndex = self.starIndex;
        __block NSInteger newEndIndex = self.endIndex;
        for (NSInteger i = start; i <= end; i++) {
            DBPageIGModel *model = self.chapterModelList[i];
            if (model.finish) continue;
            
            dispatch_group_enter(group);
            
            DBBookCatalogModel *catalog = self.model.chapterCacheList[i];
            [self.readerContentViewModel getChapterContentWithChapterForm:self.model.chapterForm
                                                               chapterId:catalog.path
                                                           chapterIndex:i
                                                            completion:^(BOOL successfulRequest, NSInteger chapterIndex, NSString *message) {
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    dispatch_group_leave(group);
                    return;
                }
                
                if (successfulRequest) {
                    DBBookCatalogModel *catalog = self.model.chapterCacheList[i];
                    DBPageIGModel *model = [[DBPageIGModel alloc] init];
                    model.sectionId = catalog.path;
                    model.sectionIndex = i;
                    NSString *title = [NSString stringWithFormat:@"\n%@\n\n\n", catalog.title];
                    model.title = title;
                    model.cellHeight = 0;
                    model.adType = self.readerAdType;

                    DBBookChapterModel *chapterModel = [DBBookChapterModel getBookChapter:self.model.chapterForm chapterId:model.sectionId];
                    NSAttributedString *attributeString = [NSAttributedString combineAttributeTexts:@[DBSafeString(model.title), chapterModel.body]
                                                                                           colors:@[setting.textColor]
                                                                                            fonts:@[[UIFont fontWithName:setting.fontName size:setting.titleFontSize], [UIFont fontWithName:setting.fontName size:setting.textFontSize]]
                                                                                            attrs:@[@{}, @{NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: @(setting.wordSpacing)}]];
                    
                    CGFloat cellHeight = [DBReadBookSetting coreTextHeightForWidth:DBReadBookSetting.setting.canvasSize.width attributedString:attributeString];
                    model.finish = YES;
                    model.cellHeight = cellHeight;
                    model.content = attributeString;
                    
                    @synchronized(newModels) {
                        [newModels addObject:model];
                        newStarIndex = MIN(newStarIndex, model.sectionIndex);
                        newEndIndex = MAX(newEndIndex, model.sectionIndex);
                    }
                }
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            if (!self) return;
            
            if (newModels.count > 0) {
                self.updateModelList = [NSMutableArray arrayWithArray:self.chapterModelList];
                for (DBPageIGModel *model in newModels) {
                    [self.updateModelList replaceObjectAtIndex:model.sectionIndex withObject:model];
                }
         
                self.starIndex = newStarIndex;
                self.endIndex = newEndIndex;
                [self updateReaderModelList];
            }
        });
    });
}

- (void)updateReaderModelList{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chapterModelList = self.updateModelList;
        if (self.rollingSpeed < 0){
            CGFloat oldHeight = self.igCollectionView.contentSize.height;
            CGPoint oldOffset = self.igCollectionView.contentOffset;
            [self.adapter performUpdatesAnimated:NO completion:^(BOOL finished) {
                [self.igCollectionView layoutIfNeeded];
                CGFloat heightDiff = self.igCollectionView.contentSize.height - oldHeight;
                CGPoint newOffset = CGPointMake(oldOffset.x, oldOffset.y + heightDiff);
                self.igCollectionView.contentOffset = newOffset;
                
                [self downloadPreloadData];
                self.isUpdating = NO;
                self.updateModelList = nil;
            }];
        }else{
            [self.adapter performUpdatesAnimated:NO completion:^(BOOL finished) {
                [self downloadPreloadData];
                self.isUpdating = NO;
                self.updateModelList = nil;
            }];
        }
    });
}

- (void)getCurrentModelChapterAndPage{
    if (self.isUpdating) return;
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.adapter.collectionView.bounds),CGRectGetMidY(self.adapter.collectionView.bounds));
    NSIndexPath *centerIndexPath = [self.adapter.collectionView indexPathForItemAtPoint:centerPoint];
    UICollectionViewCell *cell = (DBPageScrollCollectionViewCell *)[self.adapter.collectionView cellForItemAtIndexPath:centerIndexPath];

    if ([cell isKindOfClass:DBPageScrollCollectionViewCell.class]){
        DBPageScrollCollectionViewCell *cell = (DBPageScrollCollectionViewCell *)cell;
        UICollectionViewLayoutAttributes *attributes = [self.igCollectionView layoutAttributesForItemAtIndexPath:centerIndexPath];
        CGFloat verticalOffset = self.igCollectionView.contentOffset.y-attributes.frame.origin.y;
        self.model.offsetY = verticalOffset;
        NSInteger pageIndex = abs((int)verticalOffset/(int)self.pageHeight);
        
        if (self.model.currentPage != pageIndex){
            [self.model onlySetPageIndex:MIN(pageIndex, self.model.contentList.count-1)];
        }
        
        NSInteger chapterCount = centerIndexPath.section;
        if (self.model.currentChapter != chapterCount) {
            [self.model onlySetChapterIndex:MIN(chapterCount, self.model.chapterCacheList.count-1)];
        }
    }else{
        if (self.adContainerView && ![cell.contentView.subviews containsObject:self.adContainerView]){
            [cell.contentView addSubview:self.adContainerView];
            self.adShowSectionIndex = centerIndexPath.section;
        }
    }
}

- (void)loadRollingAd{
    if (self.readerAdType == DBReaderNoAd || self.adContainerView) return;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (self.readerAdType & DBReaderAdPageGrid){
            [DBUnityAdConfig.manager openGridAdSpaceType:DBAdSpaceReaderPageGrid reload:YES completion:^(UIView * _Nonnull adContainerView) {
                [self layoutAdSubview:adContainerView];
            }];
        }
        
        if (self.readerAdType & DBReaderAdPageEndGrid){
            [DBUnityAdConfig.manager openGridAdSpaceType:DBAdSpaceReaderChapterEndGrid reload:YES completion:^(UIView * _Nonnull adContainerView) {
                [self layoutAdSubview:adContainerView];
            }];
        }
        
        if (self.readerAdType & DBReaderAdPageSlot){
            [DBUnityAdConfig.manager openExpressAdsSpaceType:DBAdSpaceReaderPage showAdController:self reload:YES completion:^(NSArray<UIView *> * _Nonnull adViews) {
                [self layoutAdSubview:adViews.firstObject];
            }];
        }
       
        if (self.readerAdType & DBReaderAdPageEndSlot){
            [DBUnityAdConfig.manager openExpressAdsSpaceType:DBAdSpaceReaderChapterEnd showAdController:self reload:YES completion:^(NSArray<UIView *> * _Nonnull adViews) {
                [self layoutAdSubview:adViews.firstObject];
            }];
        }
    });
}

- (void)layoutAdSubview:(UIView *)adContainerView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!adContainerView) return;
        
        if ([self.adContainerView isEqual:adContainerView]) {
            [self.adContainerView removeFromSuperview];
            self.adContainerView = nil;
        }else{
            self.adContainerView = adContainerView;
            CGSize adSize = CGSizeMake(UIScreen.screenWidth, self.adContainerView.height/self.adContainerView.width*UIScreen.screenWidth);
            self.adContainerView.frame = CGRectMake(0, (self.pageHeight-100-adSize.height)*0.5, adSize.width, adSize.height);
        }
    });
}

#pragma mark -- UIScrollViewDelegate --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self getCurrentModelChapterAndPage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.decelerate = NO;
    [self downloadPreloadData];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    self.rollingSpeed = velocity.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.decelerate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self downloadPreloadData];
    self.model.currentChapter = self.model.currentChapter;
   
    if (self.model.currentChapter != self.adShowSectionIndex) {
        self.adContainerView = nil;
        [self loadRollingAd];
    }
}

#pragma mark -- IGListAdapterDataSource, IGListAdapterDelegate --
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter{
    return self.chapterModelList;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object{
    DBReaderPageSectionController *sectionController = [[DBReaderPageSectionController alloc] init];
    return sectionController;
}

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplayObject:(id)object atIndex:(NSInteger)index{

}

- (void)listAdapter:(nonnull IGListAdapter *)listAdapter didEndDisplayingObject:(nonnull id)object atIndex:(NSInteger)index {
    
}

- (nullable UIView *)emptyViewForListAdapter:(nonnull IGListAdapter *)listAdapter {
    return nil;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:0];
        _adapter.delegate = self;
        _adapter.dataSource = self;
        _adapter.scrollViewDelegate = self;
        _adapter.collectionView = self.igCollectionView;
    }
    return _adapter;
}

- (IGListCollectionView *)igCollectionView {
    if (!_igCollectionView) {
        _igCollectionView = [[IGListCollectionView alloc] initWithFrame:CGRectMake(0, UIScreen.navbarSafeHeight+20, UIScreen.screenWidth, self.pageHeight) listCollectionViewLayout:[[IGListCollectionViewLayout alloc] initWithStickyHeaders:NO topContentInset:0 stretchToEdge:NO]];
        _igCollectionView.backgroundColor = DBColorExtension.noColor;
        _igCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _igCollectionView;
}

- (NSMutableArray *)chapterModelList{
    if (!_chapterModelList){
        _chapterModelList = [NSMutableArray array];
    }
    return _chapterModelList;
}

- (NSMutableArray *)updateModelList{
    if (!_updateModelList){
        _updateModelList = [NSMutableArray array];
    }
    return _updateModelList;
}


@end
