//
//  BFAppInfoTableViewCell.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/12.
//

#import "BFAppInfoTableViewCell.h"
#import "BFAppInfoModel.h"

@interface BFAppInfoTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleLabel;
@property (nonatomic, strong) DBBaseLabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation BFAppInfoTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView withObject:(BFAppInfoListModel *)model{
    BFAppInfoTableViewCell *cell = [self initWithTableView:tableView];
    cell.titleLabel.text = model.name;
    cell.contentLabel.text = model.content;
    return cell;
}

- (void)setUpSubViews{
    [self.contentView bf_addSubviews:@[self.titleLabel,self.contentLabel,self.lineView]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (DBBaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[DBBaseLabel alloc] init];
        _titleLabel.font = UIFont.font16;
        _titleLabel.textColor = UIColor.bf_c000000;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (DBBaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[DBBaseLabel alloc] init];
        _contentLabel.font = UIFont.font16;
        _contentLabel.textColor = UIColor.bf_c000000;
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.bf_cEEEEEE;
    }
    return _lineView;
}

@end
