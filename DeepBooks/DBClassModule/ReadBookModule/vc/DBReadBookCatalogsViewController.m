//
//  DBReadBookCatalogsViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import "DBReadBookCatalogsViewController.h"
#import "DBReadBookCatalogsTableViewCell.h"
#import "DBBookChapterModel.h"
#import "DBBookDetailViewController.h"
#import "UIViewController+CWLateralSlide.h"

@interface DBReadBookCatalogsViewController ()
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) UIButton *orderButton;
@end

@implementation DBReadBookCatalogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    CGFloat width = 50;
    self.listRollingView.rowHeight = 44;
    [self.view addSubviews:@[self.bottomButton,self.listRollingView]];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(width*5.0/4.0+60.0+UIScreen.navbarSafeHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bottomButton);
        make.top.mas_equalTo(self.bottomButton.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.bottomButton addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.arrowImageView,self.descTextLabel,self.orderButton]];
    
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+20);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.pictureImageView);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.pictureImageView);
        make.right.mas_equalTo(-16);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(10);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.descTextLabel);
    }];
    
    self.pictureImageView.imageObj = self.book.image;
    self.titleTextLabel.text = self.book.name;
    self.contentTextLabel.text = self.book.author;
    NSString *chapters = [NSString stringWithFormat:@"共%ld章",self.dataList.count];
    NSArray *result = @[[DBCommonConfig bookStausDesc:self.book.status],chapters];
    self.descTextLabel.text = [result componentsJoinedByString:@" · "];
    if (self.dataList.count == 0) return;
    
    NSInteger chapterIndex = MIN(self.book.chapter_index, self.dataList.count-1);
    NSInteger start = MAX(chapterIndex-50, 0);
    NSInteger end = MIN(chapterIndex+50, self.dataList.count-1);
    for (NSInteger index = start; index <= end; index++) {
        DBBookCatalogModel *model = self.dataList[index];
        model.isCache = [DBBookChapterModel getBookChapter:self.book.chapterForm chapterId:model.path];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        for (NSInteger i = 0; i < start; i++) {
            DBBookCatalogModel *model = self.dataList[i];
            model.isCache = [DBBookChapterModel getBookChapter:self.book.chapterForm chapterId:model.path];
        }
        
        for (NSInteger i = end+1; i < self.dataList.count; i++) {
            DBBookCatalogModel *model = self.dataList[i];
            model.isCache = [DBBookChapterModel getBookChapter:self.book.chapterForm chapterId:model.path];
        }
    });
    
    [self.listRollingView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (chapterIndex < self.dataList.count) {
            [self.listRollingView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chapterIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    });
}

- (void)clickOrderAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.dataList = self.dataList.reverseObjectEnumerator.allObjects;
    [self.listRollingView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBReadBookCatalogsTableViewCell *cell = [DBReadBookCatalogsTableViewCell initWithTableView:tableView];
    DBBookCatalogModel *mode = self.dataList[indexPath.row];
    cell.model = mode;
    NSInteger index = self.orderButton.selected ? (self.dataList.count-indexPath.row-1) : indexPath.row;
    cell.isSelected = (self.book.chapter_index == index);
    cell.isLoaded = mode.isCache;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickChapterIndex) self.clickChapterIndex(self.orderButton.selected ? (self.dataList.count-indexPath.row-1) : indexPath.row);
    [DBRouter closePage];
}

- (UIButton *)bottomButton{
    if (!_bottomButton){
        _bottomButton = [[UIButton alloc] init];
        _bottomButton.backgroundColor = DBColorExtension.paleGrayColor;
        
        DBWeakSelf
        [_bottomButton addTagetHandler:^(id  _Nonnull sender) {
            DBStrongSelfElseReturn
            [DBRouter closePage];
//            if (DBCommonConfig.switchAudit){
//                [DBRouter closePage];
//            }else{
//                DBBookDetailViewController *detailVc = [[DBBookDetailViewController alloc] init];
//                detailVc.bookId = self.book.book_id;
//                detailVc.hidesBottomBarWhenPushed = YES;
//                [self cw_pushViewController:detailVc];
//            }
         
        } controlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangSemiboldRegular;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.inkWashColor;
    }
    return _contentTextLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.clipsToBounds = YES;
        _arrowImageView.image = [UIImage imageNamed:@"arrowIcon"];
    }
    return _arrowImageView;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.inkWashColor;
    }
    return _descTextLabel;
}

- (UIButton *)orderButton{
    if (!_orderButton){
        _orderButton = [[UIButton alloc] init];
        _orderButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _orderButton.titleLabel.font = DBFontExtension.bodySmallFont;
        [_orderButton setTitle:@"升序" forState:UIControlStateNormal];
        [_orderButton setTitle:@"降序" forState:UIControlStateSelected];
        [_orderButton setTitleColor:DBColorExtension.blackAltColor forState:UIControlStateNormal];
        [_orderButton addTarget:self action:@selector(clickOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

- (BOOL)hiddenLeft{
    return YES;
}



@end
