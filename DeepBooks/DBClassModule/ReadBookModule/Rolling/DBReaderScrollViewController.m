//
//  DBReaderScrollViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/19.
//

#import "DBReaderScrollViewController.h"
#import "DBReadBookSetting.h"
#import "DBReaderAdViewModel.h"
#import "DBReaderScrollModel.h"
#import "DBBookCatalogModel.h"
#import "DBBookChapterModel.h"

#import "DBReaderScrollCollectionViewCell.h"


static NSString *identifierCollectCell = @"DBReaderScrollCollectionViewCell";

@interface DBReaderScrollViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *pageScrollView;

@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, strong) NSMutableArray *chapterModelList;

@property (nonatomic, assign) BOOL isGridAdEnd;
@property (nonatomic, assign) BOOL isSlotAdEnd;
@property (nonatomic, assign) NSInteger gridAdDiff;
@property (nonatomic, assign) NSInteger slotAdDiff;

@property (nonatomic, assign) BOOL isScrolling;
@end

@implementation DBReaderScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.pageSize = DBReadBookSetting.calculateCanvaseSize;
    [self.view addSubview:self.pageScrollView];
    
    self.isGridAdEnd = [DBReaderAdViewModel gridEndReaderAd];
    self.isSlotAdEnd = [DBReaderAdViewModel slotEndReaderAd];
    self.gridAdDiff = [DBReaderAdViewModel getReaderAdGridValue];
    self.slotAdDiff = [DBReaderAdViewModel getReaderAdSlotValue];
    
    DBWeakSelf
    self.pageScrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self.pageScrollView.mj_header endRefreshing];
        if (self.model.currentChapter == 0){
            [self.view showAlertText:DBConstantString.ks_firstPageReached];
        }
    }];
    
    self.pageScrollView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self.pageScrollView.mj_footer endRefreshing];
        if (self.model.currentChapter == self.model.chapterCacheList.count-1){
            [self.view showAlertText:@"已经最后一页"];
        }
    }];
}

- (void)setModel:(DBReaderModel *)model{
    _model = model;
    [self reloadReaderScrollListData];
}

- (void)reloadReaderScrollListData{
    [self.chapterModelList removeAllObjects];
    
    [self.view showHudLoading];
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = setting.lineSpacing;
    paraStyle.alignment = NSTextAlignmentJustified;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        for (NSInteger index = 0; index < self.model.chapterCacheList.count; index++) {
            DBBookCatalogModel *catalog = self.model.chapterCacheList[index];
            DBReaderScrollModel *model = [[DBReaderScrollModel alloc] init];
            model.title = [NSString stringWithFormat:@"\n%@\n\n\n",catalog.title];
            model.adType = DBReaderNoAd;
            model.finish = NO;
            model.cellHeight = 100;
            
            if (index - self.model.currentChapter >= -1 && index - self.model.currentChapter < 10){
                DBBookChapterModel *chapterModel = [DBBookChapterModel getBookChapter:self.model.chapterForm chapterId:catalog.path];
                if (chapterModel.body.length > 0) {
                    
                    model.finish = YES;
                    NSAttributedString *attributeString = [NSAttributedString combineAttributeTexts:@[DBSafeString(model.title),chapterModel.body] colors:@[setting.textColor]  fonts:@[[UIFont fontWithName:setting.fontName size:setting.titleFontSize], [UIFont fontWithName:setting.fontName size:setting.textFontSize]] attrs:@[@{},@{NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(setting.wordSpacing)}]
                    ];
                    model.content = attributeString;
                    CGFloat cellHeight = [DBReadBookSetting coreTextHeightForWidth:DBReadBookSetting.setting.canvasSize.width attributedString:attributeString];
                    
                    NSArray *contentList = [DBReadBookSetting calculateCanvasesForAttributedString:attributeString];
                    model.cellHeight = cellHeight;
                    model.contentList = contentList;
                    model.adType = [self getReaderAdType:cellHeight];
                    [self.chapterModelList addObject:model];
                }
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view removeHudLoading];
            [self.pageScrollView reloadData];
        });
    });
}

- (DBReaderAdType)getReaderAdType:(CGFloat)cellHeight{
    if (self.isGridAdEnd) return DBReaderAdPageEndGrid;
    if (self.gridAdDiff > 0 && cellHeight > self.gridAdDiff*self.pageSize.height*0.66) return DBReaderAdPageGrid;
    if (self.isSlotAdEnd) return DBReaderAdPageGrid;
    if (self.slotAdDiff > 0 && cellHeight > self.slotAdDiff*self.pageSize.height*0.66) return DBReaderAdPageSlot;
    return DBReaderNoAd;
}

#pragma mark - UIScrollViewDelegate


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.chapterModelList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    DBReaderScrollModel *model = self.chapterModelList[section];
    return model.contentList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBReaderScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCollectCell forIndexPath:indexPath];
    DBReaderScrollModel *model = self.chapterModelList[indexPath.section];
    cell.attri = model.contentList[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBReaderScrollModel *model = self.chapterModelList[indexPath.section];
    return CGSizeMake(UIScreen.screenWidth, 5000);
}

- (UICollectionView *)pageScrollView{
    if (!_pageScrollView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.estimatedItemSize = CGSizeMake(UIScreen.screenWidth, 10000);
        _pageScrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20+UIScreen.navbarSafeHeight, UIScreen.screenWidth, self.pageSize.height) collectionViewLayout:layout];
        _pageScrollView.delegate = self;
        _pageScrollView.dataSource = self;
        
        _pageScrollView.contentInset = UIEdgeInsetsZero;
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.backgroundColor = DBColorExtension.noColor;
        [_pageScrollView registerClass:DBReaderScrollCollectionViewCell.class forCellWithReuseIdentifier:identifierCollectCell];
    }
    return _pageScrollView;
}

- (NSMutableArray *)chapterModelList{
    if (!_chapterModelList){
        _chapterModelList = [NSMutableArray array];
    }
    return _chapterModelList;
}
@end
