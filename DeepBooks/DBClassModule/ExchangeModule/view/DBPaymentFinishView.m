//
//  DBPaymentFinishView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBPaymentFinishView.h"

@interface DBPaymentFinishView ()
@property (nonatomic, strong) UIView *containerBoxView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@end

@implementation DBPaymentFinishView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] init];
        _containerBoxView.layer.cornerRadius = 16;
        _containerBoxView.layer.masksToBounds = YES;
        _containerBoxView.backgroundColor = DBColorExtension.whiteColor;
    }
    return _containerBoxView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titleTextLabel.textColor = DBColorExtension.blackColor;
        _titleTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleTextLabel;
}

@end
