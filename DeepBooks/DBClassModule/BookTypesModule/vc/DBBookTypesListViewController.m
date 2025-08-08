//
//  DBBookTypesListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBBookTypesListViewController.h"
#import "DBBookTypesModel.h"
#import "DBBookTypesCollectionViewCell.h"

static NSString *identifierCollectCell = @"DBBookTypesCollectionViewCell";
@interface DBBookTypesListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *bookTypecollectionView;
@end

@implementation DBBookTypesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
}

- (void)setUpSubViews{
    self.view.backgroundColor = DBColorExtension.noColor;
    [self.view addSubview:self.bookTypecollectionView];
    [self.bookTypecollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    id value = [NSUserDefaults takeValueForKey:self.getClassifyCatalogUrl];
    if (value){
        DBBookTypesModel *result = [DBBookTypesModel yy_modelWithJSON:value];
        switch (self.index) {
            case 0:
                self.dataList = result.male;
                break;
            case 1:
                self.dataList = result.female;
                break;
            case 2:
                self.dataList = result.comics;
                break;
            default:
                break;
        }
        [self.bookTypecollectionView reloadData];
    }
}

- (NSString *)getClassifyCatalogUrl{
    NSString *url = [DBLinkManager combineLinkWithType:DBLinkBookClassifyCatalog combine:nil];
    return url;
}

- (void)getDataSource{
    [DBAFNetWorking getServiceRequestType:DBLinkBookClassifyCatalog combine:nil parameInterface:nil modelClass:DBBookTypesModel.class serviceData:^(BOOL successfulRequest, DBBookTypesModel *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            switch (self.index) {
                case 0:
                    self.dataList = result.male;
                    break;
                case 1:
                    self.dataList = result.female;
                    break;
                case 2:
                    self.dataList = result.comics;
                    break;
                default:
                    break;
            }
            [NSUserDefaults saveValue:result.yy_modelToJSONString forKey:self.getClassifyCatalogUrl];
        }else{
            [self.view showAlertText:message];
        }
        self.bookTypecollectionView.emptyDataSetSource = self;
        self.bookTypecollectionView.emptyDataSetDelegate = self;
        [self.bookTypecollectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBBookTypesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCollectCell forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DBBookTypesGenderModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBTypeBooksList params:@{@"typeModel":model,@"sex":[NSString stringWithFormat:@"%ld",self.index+1]}];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = DBConstantString.ks_noCategories;
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    
    DBWeakSelf
    emptyView.reloadBlock = ^{
        DBStrongSelfElseReturn
        [self.view showHudLoading];
        [self getDataSource];
    };
    return emptyView;
}

- (UICollectionView *)bookTypecollectionView{
    if (!_bookTypecollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 6, 8, 6);
        layout.itemSize = CGSizeMake(UIScreen.screenWidth*0.5-6, 86+16);
        _bookTypecollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _bookTypecollectionView.delegate = self;
        _bookTypecollectionView.dataSource = self;
        _bookTypecollectionView.showsVerticalScrollIndicator = NO;
        _bookTypecollectionView.showsHorizontalScrollIndicator = NO;
        _bookTypecollectionView.backgroundColor = DBColorExtension.noColor;
        [_bookTypecollectionView registerClass:NSClassFromString(identifierCollectCell) forCellWithReuseIdentifier:identifierCollectCell];
    }
    return _bookTypecollectionView;
}

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.view.backgroundColor = DBColorExtension.blackAltColor;
    }else{
        self.view.backgroundColor = DBColorExtension.noColor;
    }
}
@end
