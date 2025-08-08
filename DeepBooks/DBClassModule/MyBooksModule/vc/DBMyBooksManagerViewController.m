//
//  DBMyBooksManagerViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBMyBooksManagerViewController.h"
#import "DBMyBooksManagerTableViewCell.h"
#import "DBMyBooksManagerModel.h"
@interface DBMyBooksManagerViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *allSelectButton;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation DBMyBooksManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.navLabel.text = DBConstantString.ks_management;
    [self.view addSubviews:@[self.navLabel,self.listRollingView,self.bottomView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(UIScreen.tabbarSafeHeight+50);
        make.top.mas_equalTo(self.listRollingView.mas_bottom);
    }];
    self.dataList = self.myBooksList;
    self.listRollingView.emptyDataSetSource = self;
    self.listRollingView.emptyDataSetDelegate = self;
    [self.listRollingView reloadData];
}

- (NSArray *)myBooksList{
    NSMutableArray *list = [NSMutableArray array];
    for (DBBookModel *model in DBBookModel.getAllCollectBooks) {
        DBMyBooksManagerModel *newModel = [[DBMyBooksManagerModel alloc] init];
        newModel.book_id = model.book_id;
        newModel.image = model.image;
        newModel.name = model.name;
        newModel.last_chapter_name = model.last_chapter_name;
        newModel.readChapterName = model.readChapterName;
        [list addObject:newModel];
    }
    return list;
}

- (void)clickAllSelectAction{
    self.allSelectButton.selected = !self.allSelectButton.selected;
    for (DBMyBooksManagerModel *model in self.dataList) {
        model.isSelect = self.allSelectButton.selected;
    }
    [self.listRollingView reloadData];
    
    NSInteger count = 0;
    for (DBMyBooksManagerModel *model in self.dataList) {
        if (model.isSelect) count++;
    }
    self.contentTextLabel.text = [NSString stringWithFormat:DBConstantString.ks_selectedCount,count];
}

- (void)clickDeleteAction{
    DBWeakSelf
    LEEAlert.alert.config.LeeTitle(@"是否彻底删除已选中的书籍？").
    LeeCancelAction(DBConstantString.ks_cancel, ^{
        
    }).LeeAction(DBConstantString.ks_confirm, ^{
        DBStrongSelfElseReturn
        [self confirmDeleteAction];
    }).LeeShow();
}

- (void)confirmDeleteAction{
    NSMutableArray *bookIds = [NSMutableArray array];
    for (DBMyBooksManagerModel *model in self.dataList) {
        if (model.isSelect) [bookIds addObject:model.book_id];
    }
    if (bookIds.count){
        if (DBCommonConfig.isLogin && !DBCommonConfig.switchAudit){
            NSString *book_id = [bookIds.yy_modelToJSONString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSDictionary *parameInterface = @{@"book_id":book_id,@"form":@"1"};
            [self.view showHudLoading];
            [DBAFNetWorking postServiceRequestType:DBLinkBookShelfMultiBookDelete combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
                [self.view removeHudLoading];
                if (successfulRequest){
                    [self deleteMyBooks:bookIds];
                }else{
                    [self.view showAlertText:message];
                }
            }];
        }else{
            [self deleteMyBooks:bookIds];
        }
    }else{
        [self.view showAlertText:DBConstantString.ks_selectBook];
    }
}

- (void)deleteMyBooks:(NSArray *)bookIds{
    if ([DBBookModel removeCollectBooksInIds:bookIds]){
        [self.view showAlertText:DBConstantString.ks_deletedSuccess];
        self.dataList = self.myBooksList;
        [self.listRollingView reloadData];
        self.contentTextLabel.text = DBConstantString.ks_noneSelected;
    }else{
        [self.view showAlertText:DBConstantString.ks_deleteFailed];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyBooksManagerTableViewCell *cell = [DBMyBooksManagerTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyBooksManagerModel *model = self.dataList[indexPath.row];
    model.isSelect = !model.isSelect;
    [tableView reloadData];
    
    NSInteger count = 0;
    for (DBMyBooksManagerModel *model in self.dataList) {
        if (model.isSelect) count++;
    }
    self.contentTextLabel.text = [NSString stringWithFormat:DBConstantString.ks_selectedCount,count];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = DBConstantString.ks_noBooks;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = DBColorExtension.paleGrayColor;
        
        [_bottomView addSubviews:@[self.allSelectButton,self.contentTextLabel,self.deleteButton]];
        [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
        }];
        [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.allSelectButton);
            make.centerX.mas_equalTo(0);
        }];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
        }];
    }
    return _bottomView;
}

- (UIButton *)allSelectButton{
    if (!_allSelectButton){
        _allSelectButton = [[UIButton alloc] init];
        _allSelectButton.titleLabel.font = DBFontExtension.pingFangMediumXLarge;
        _allSelectButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_allSelectButton setTitle:DBConstantString.ks_selectAll forState:UIControlStateNormal];
        [_allSelectButton setTitle:DBConstantString.ks_deselect forState:UIControlStateSelected];
        [_allSelectButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
        [_allSelectButton addTarget:self action:@selector(clickAllSelectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectButton;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySixTenFont;
        _contentTextLabel.textColor = DBColorExtension.charcoalColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
        _contentTextLabel.text = DBConstantString.ks_noneSelected;
    }
    return _contentTextLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton){
        _deleteButton = [[UIButton alloc] init];
        _deleteButton.titleLabel.font = DBFontExtension.pingFangMediumXLarge;
        _deleteButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_deleteButton setTitle:DBConstantString.ks_delete forState:UIControlStateNormal];
        [_deleteButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
