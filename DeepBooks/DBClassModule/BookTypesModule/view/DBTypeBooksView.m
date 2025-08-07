//
//  DBTypeBooksView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBTypeBooksView.h"

@interface DBTypeBooksView ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIScrollView *typeScrollView;

@property (nonatomic, strong) NSMutableArray *topMenuList;
@property (nonatomic, strong) NSMutableArray *centerMenuList;
@property (nonatomic, strong) NSMutableArray *bottomMenuList;
@end

@implementation DBTypeBooksView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.topMenuList = [NSMutableArray array];
    self.centerMenuList = [NSMutableArray array];
    self.bottomMenuList = [NSMutableArray array];
    self.stype = @"-1";
    self.end = @"-1";
    self.score = @"1";
    NSArray *titles = @[@"全部",@"全部",@"热门"];
    [self addSubviews:@[self.titleTextLabel]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIView *lastView = self.titleTextLabel;
    for (NSInteger index = 0; index < titles.count; index++) {
        NSString *text = titles[index];
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = index*100;
        btn.titleLabel.font = DBFontExtension.bodySixTenFont;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [btn setTitleColor:DBColorExtension.redColor forState:UIControlStateSelected];
        btn.selected = YES;
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(lastView.mas_bottom).offset(16);
            if (index == 2) make.bottom.mas_equalTo(-16);
        }];
        lastView = btn;
        
        if (index == 0){
            UIScrollView *typeScrollView = [[UIScrollView alloc] init];
            typeScrollView.showsVerticalScrollIndicator = NO;
            typeScrollView.showsHorizontalScrollIndicator = NO;
            [self addSubview:typeScrollView];
            self.typeScrollView = typeScrollView;
            [typeScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(btn.mas_right);
                make.right.mas_equalTo(0);
                make.centerY.mas_equalTo(lastView);
                make.height.mas_equalTo(30);
            }];
            [self.topMenuList addObject:btn];
        }else if (index > 0){
            NSMutableArray *list = index == 2 ? self.bottomMenuList : self.centerMenuList;
            [list addObject:btn];
            NSArray *titles = index == 2 ? @[@"评分"] : @[@"完结",@"连载"];
            UIView *leftView = btn;
            for (NSString *title in titles) {
                UIButton *button = [[UIButton alloc] init];
                button.tag = index*100+[titles indexOfObject:title]+1;
                button.titleLabel.font = DBFontExtension.bodySixTenFont;
                button.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
                [button setTitle:title forState:UIControlStateNormal];
                [button setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
                [button setTitleColor:DBColorExtension.redColor forState:UIControlStateSelected];
                [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                [list addObject:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftView.mas_right);
                    make.centerY.mas_equalTo(leftView);
                    make.height.mas_equalTo(30);
                }];
                leftView = button;
            }
        }
    }
}

- (void)clickAction:(UIButton *)sender{
    NSInteger index = sender.tag/100;

    if (index == 0){
        for (UIButton *btn in self.topMenuList) {
            btn.selected = [sender isEqual:btn];
            if (btn.selected){
                if (btn.tag == 0){
                    self.stype = @"-1";
                }else{
                    self.stype = self.typeModel.ltype_list[btn.tag-1].stype_id;
                }
            }
        }
    }else if (index == 1){
        for (UIButton *btn in self.centerMenuList) {
            btn.selected = [sender isEqual:btn];
            if (btn.selected){
                self.end = [NSString stringWithFormat:@"%ld",btn.tag%100];
            }
        }
    }else if (index == 2){
        for (UIButton *btn in self.bottomMenuList) {
            btn.selected = [sender isEqual:btn];
            if (btn.selected){
                self.score = btn.tag%100 == 0 ? @"1" :@"2";
            }
        }
    }
    if (self.filterBlock) self.filterBlock();
}

- (void)setTypeModel:(DBBookTypesGenderModel *)typeModel{
    _typeModel = typeModel;
    self.titleTextLabel.text = typeModel.ltype_desc;
    
    UIView *lastView = self.topMenuList.firstObject;
    for (DBBookTypesListModel *model in typeModel.ltype_list) {
        CGRect textRect = [model.stype_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: DBFontExtension.bodySixTenFont}
                                             context:nil];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lastView.x+lastView.width, 0, textRect.size.width+16, 30)];
        button.tag = [typeModel.ltype_list indexOfObject:model]+1;
        button.titleLabel.font = DBFontExtension.bodySixTenFont;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        [button setTitle:model.stype_name forState:UIControlStateNormal];
        [button setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [button setTitleColor:DBColorExtension.redColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeScrollView addSubview:button];
        [self.topMenuList addObject:button];
        lastView = button;
    }
    
    self.typeScrollView.contentSize = CGSizeMake(lastView.x+lastView.width+10, 30);
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumLarge;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.numberOfLines = 0;
    }
    return _titleTextLabel;
}
@end
