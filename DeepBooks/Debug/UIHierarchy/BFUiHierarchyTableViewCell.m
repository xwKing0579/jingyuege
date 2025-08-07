//
//  BFUiHierarchyTableViewCell.m
//  OCProject
//
//  Created by 王祥伟 on 2024/3/14.
//

#import "BFUiHierarchyTableViewCell.h"
#import "BFUIHierarchyModel.h"

@interface BFUiHierarchyTableViewCell ()
@property (nonatomic, strong) BFUIHierarchyModel *model;
@property (nonatomic, strong) UIButton *numBtn;
@property (nonatomic, strong) DBBaseLabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation BFUiHierarchyTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView withObject:(BFUIHierarchyModel *)model{
    BFUiHierarchyTableViewCell *cell = [self initWithTableView:tableView];
    cell.model = model;
    
    [cell.numBtn setTitle:[NSString stringWithFormat:@"%d",model.deepLevel] forState:UIControlStateNormal];
    cell.titleLabel.text = model.objectClass;
    cell.arrowImageView.hidden = !model.haveSubviews;
    cell.arrowImageView.transform = CGAffineTransformMakeRotation(model.isOpen ? M_PI_2 : 0);
    cell.numBtn.backgroundColor = model.isController ? UIColor.redColor : DBColorExtension.grayColor;
    CGFloat left = 20+model.deepLevel*15;
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.width.mas_lessThanOrEqualTo(cell.contentView.bf_width-left-30);
    }];
    [cell.contentView layoutIfNeeded];
    return cell;
}

- (void)setUpSubViews{
    [self.contentView bf_addSubviews:@[self.numBtn,self.titleLabel,self.lineView,self.arrowImageView]];
    [self.numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.titleLabel);
        make.right.mas_equalTo(self.titleLabel.mas_left).offset(-5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_lessThanOrEqualTo(self.contentView.bf_width-30-30);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
    }];
}

- (void)clickNumAction{
    id obj = (__bridge id)(void *)self.model.objectPtr;
    if (obj) {
        id views = [NSObject performTarget:@"BFUIHierarchyManager".classString action:@"viewUIHierarchy:" object:obj];
        [BFRouter jumpUrl:BFString.vc_ui_hierarchy params:@{@"views":views}];
    }
}

- (void)didTapLabel:(UITapGestureRecognizer *)tapGesture{
    id obj = (__bridge id)(void *)self.model.objectPtr;
    if (obj) [BFRouter jumpUrl:BFString.vc_po_object params:@{@"object":obj}];
}

- (UIButton *)numBtn{
    if (!_numBtn){
        _numBtn = [[UIButton alloc] init];
        _numBtn.layer.cornerRadius = 10;
        _numBtn.layer.masksToBounds = YES;
        _numBtn.backgroundColor = [UIColor grayColor];
        _numBtn.titleLabel.font = UIFont.font14;
        [_numBtn setTitleColor:UIColor.bf_cFFFFFF forState:UIControlStateNormal];
        [_numBtn addTarget:self action:@selector(clickNumAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _numBtn;
}

- (DBBaseLabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[DBBaseLabel alloc] init];
        _titleLabel.font = UIFont.font14;
        _titleLabel.textColor = UIColor.bf_c333333;
        _titleLabel.numberOfLines = 0;
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabel:)];
        [_titleLabel addGestureRecognizer:tapGesture];
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.bf_cEEEEEE;
    }
    return _lineView;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow"];
    }
    return _arrowImageView;
}
@end
