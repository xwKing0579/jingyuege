//
//  DBEmptyView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBEmptyView.h"
#import <Reachability/Reachability.h>
@interface DBEmptyView ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;

@end

@implementation DBEmptyView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubviews:@[self.pictureImageView,self.contentTextLabel,self.reloadButton]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-100);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(10);
    }];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(20);
    }];
}

- (void)setImageObj:(id)imageObj{
    _imageObj = imageObj;
    self.pictureImageView.image = imageObj;
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentTextLabel.text = content;
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    if (dataList == nil){
        self.contentTextLabel.hidden = YES;
        self.reloadButton.hidden = NO;
    }else{
        self.contentTextLabel.hidden = NO;
        self.reloadButton.hidden = YES;
    }
}

- (void)setAction:(NSString *)action{
    _action = action;
    [self.reloadButton setTitle:action forState:UIControlStateNormal];
}

- (void)clickReloadAction{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable){
        [DBCommonConfig openAppSetting];
    }else{
        if (self.reloadBlock) self.reloadBlock();
    }
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.inkWashColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
        _contentTextLabel.numberOfLines = 0;
    }
    return _contentTextLabel;
}

- (UIButton *)reloadButton{
    if (!_reloadButton){
        _reloadButton = [[UIButton alloc] init];
        _reloadButton.hidden = YES;
        _reloadButton.titleLabel.font = DBFontExtension.pingFangSemiboldRegular;
        _reloadButton.layer.cornerRadius = 18;
        _reloadButton.layer.masksToBounds = YES;
        _reloadButton.layer.borderWidth = 1;
        _reloadButton.contentEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15);
        _reloadButton.layer.borderColor = DBColorExtension.sunsetOrangeColor.CGColor;
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:DBColorExtension.sunsetOrangeColor forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(clickReloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

@end
