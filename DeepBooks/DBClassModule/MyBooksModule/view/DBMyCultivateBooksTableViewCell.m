//
//  DBMyCultivateBooksTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/1.
//

#import "DBMyCultivateBooksTableViewCell.h"

@interface DBMyCultivateBooksTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;

@property (nonatomic, strong) UIButton *backButton;
@end

@implementation DBMyCultivateBooksTableViewCell

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    CGFloat width = 44;
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.backButton]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5/4);
    }];
    
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.pictureImageView).offset(6);
        make.right.mas_equalTo(-10);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.pictureImageView).offset(-6);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(24);
    }];
}

- (void)clickBackAction{
    if (DBCommonConfig.isLogin){
        NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.model.book_id)};
        [UIScreen.appWindow showHudLoading];
        [DBAFNetWorking postServiceRequestType:DBLinkBookShelfBookFeedUpCancel combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
            [UIScreen.appWindow removeHudLoading];
            if (successfulRequest){
                [self bookCultivateOrCancel];
            }else{
                [UIScreen.appWindow showAlertText:message];
            }
        }];
    }else{
        [self bookCultivateOrCancel];
    }
}

- (void)bookCultivateOrCancel{
    self.model.isCultivate = NO;
    [self.model updateCollectBook];
    [NSNotificationCenter.defaultCenter postNotificationName:DBUpdateCollectBooks object:nil];
}

- (void)setModel:(DBBookModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = @"养肥中...";
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
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.redColor;
    }
    return _descTextLabel;
}

- (UIButton *)backButton{
    if (!_backButton){
        _backButton = [[UIButton alloc] init];
        _backButton.layer.cornerRadius = 4;
        _backButton.layer.masksToBounds = YES;
        _backButton.layer.borderColor = DBColorExtension.skyBlueColor.CGColor;
        _backButton.layer.borderWidth = 1;
        _backButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_backButton setTitle:@"移回" forState:UIControlStateNormal];
        [_backButton setTitleColor:DBColorExtension.skyBlueColor forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickBackAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

@end
