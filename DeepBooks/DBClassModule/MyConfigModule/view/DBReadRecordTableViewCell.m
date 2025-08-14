//
//  DBReadRecordTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBReadRecordTableViewCell.h"
#import "DBAdReadSetting.h"
@interface DBReadRecordTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) UIButton *bookselfButton;
@end

@implementation DBReadRecordTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel,self.bookselfButton]];
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
        make.top.mas_equalTo(6);
        make.bottom.mas_equalTo(-6);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureImageView);
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.centerY.mas_equalTo(0);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
        make.right.mas_equalTo(-100);
    }];
    [self.bookselfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.descTextLabel);
    }];
}

- (void)setModel:(DBBookModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.last_chapter_name;
    self.descTextLabel.text = [DBCommonConfig bookReadingProgress:model.readChapterName];
    
    NSArray *collectBooks = [DBBookModel getAllCollectBooks];
    BOOL isCollected = [collectBooks containIvar:@"book_id" value:model.book_id];
    self.bookselfButton.selected = isCollected;
    self.bookselfButton.userInteractionEnabled = !isCollected;
}

- (void)clickBookselfAction{
    if (self.bookselfButton.selected) return;
    
    [self canCollectBookSelf];
}

- (void)canCollectBookSelf{
    DBAdReadSetting *adSetting = DBAdReadSetting.setting;
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceAddToBookshelf];
    if (DBUnityAdConfig.openAd && posAd.ads.count && adSetting.addBookshelfCount >= posAd.extra.free_count){
        DBWeakSelf
 
        self.bookselfButton.userInteractionEnabled = NO;
        [DBUnityAdConfig.manager openRewardAdSpaceType:DBAdSpaceAddToBookshelf completion:^(BOOL removed,BOOL reward) {
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
    [UIScreen.currentViewController.view showHudLoading];
    NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.model.book_id),@"form":@"1"};
    [DBAFNetWorking postServiceRequestType:DBLinkBookShelfBookAdd combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [UIScreen.currentViewController.view removeHudLoading];
        if (successfulRequest){
            [self collectBook];
        }else{
            [UIScreen.currentViewController.view showAlertText:message];
        }
    }];
}

- (void)collectBook{
    DBBookModel *bookModel = self.model;
    
    bookModel.collectDate = NSDate.currentInterval;
    bookModel.updateTime = NSDate.currentInterval;
    BOOL successfulRequest = [bookModel insertCollectBook];
    
    if (successfulRequest){
        self.bookselfButton.selected = YES;
        self.bookselfButton.userInteractionEnabled = NO;
        DBAdReadSetting *adSetting = DBAdReadSetting.setting;
        adSetting.addBookshelfCount += 1;
        [adSetting reloadSetting];
    }else{
        self.bookselfButton.userInteractionEnabled = YES;
        [UIScreen.currentViewController.view showAlertText:DBConstantString.ks_addToShelfFailed];
    }
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
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.numberOfLines = 2;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _descTextLabel;
}

- (UIButton *)bookselfButton{
    if (!_bookselfButton){
        _bookselfButton = [[UIButton alloc] init];
        _bookselfButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_bookselfButton setTitle:DBConstantString.ks_addToShelf forState:UIControlStateNormal];
        [_bookselfButton setTitle:DBConstantString.ks_addedToShelf forState:UIControlStateSelected];
        [_bookselfButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
        [_bookselfButton setTitleColor:DBColorExtension.lightSilverColor forState:UIControlStateSelected];
        [_bookselfButton addTarget:self action:@selector(clickBookselfAction) forControlEvents:UIControlEventTouchUpInside];
        _bookselfButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _bookselfButton;
}

@end
