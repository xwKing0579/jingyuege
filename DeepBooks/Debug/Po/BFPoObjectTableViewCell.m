//
//  BFPoObjectTableViewCell.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/26.
//

#import "BFPoObjectTableViewCell.h"

@interface BFPoObjectTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleLabel;
@property (nonatomic, strong) DBBaseLabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *copyBtn;
@end

@implementation BFPoObjectTableViewCell
+ (instancetype)initWithTableView:(UITableView *)tableView withObject:(NSDictionary *)dic{
    BFPoObjectTableViewCell *cell = [self initWithTableView:tableView];
    cell.titleLabel.text = dic.allKeys.firstObject;
    
    id value = dic.allValues.firstObject;
    NSMutableString *text = [NSMutableString string];
    if ([value isKindOfClass:[NSString class]]) {
        text = value;
    }else if ([value isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = (NSDictionary *)value;
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:dic.allKeys.lastObject]){
                [text appendString:[NSString stringWithFormat:@"%@ = %@",key,obj]];
            }else{
                [text appendString:[NSString stringWithFormat:@"%@ = %@\n",key,obj]];
            }
        }];
    }else if ([value isKindOfClass:[NSArray class]]){
        NSArray *array = (NSArray *)value;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [text appendString:[NSString stringWithFormat:@"%@\n",obj]];
        }];
    }else if ([value isKindOfClass:[NSObject class]]){
        [text appendString:[value description]];
    }else {
        [text appendString:[NSString stringWithFormat:@"%@",value]];
    }
    cell.contentLabel.text = text;
    
    return cell;
}

- (void)setUpSubViews{
    [self.contentView bf_addSubviews:@[self.titleLabel,self.contentLabel,self.lineView,self.copyBtn]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-45);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        make.right.equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)clickCopyAction{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.contentLabel.text];

//    [BFToastManager showText:@"复制成功"];
}

- (DBBaseLabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[DBBaseLabel alloc] init];
        _titleLabel.font = UIFont.fontBold16;
        _titleLabel.textColor = UIColor.bf_c000000;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (DBBaseLabel *)contentLabel{
    if (!_contentLabel){
        _contentLabel = [[DBBaseLabel alloc] init];
        _contentLabel.font = UIFont.font14;
        _contentLabel.textColor = UIColor.bf_c000000;
        _contentLabel.numberOfLines = 100;
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.bf_cEEEEEE;
    }
    return _lineView;
}

- (UIButton *)copyBtn{
    if (!_copyBtn){
        _copyBtn = [[UIButton alloc] init];
        [_copyBtn setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [_copyBtn addTarget:self action:@selector(clickCopyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyBtn;
}
@end
