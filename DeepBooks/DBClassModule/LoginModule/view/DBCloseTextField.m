//
//  DBCloseTextField.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/24.
//

#import "DBCloseTextField.h"

@interface DBCloseTextField ()
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation DBCloseTextField

- (instancetype)init{
    if (self == [super init]){
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
        
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.hidden = YES;
        [closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(clickCloseAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        self.closeButton = closeButton;
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.height.mas_equalTo(40);
            make.centerY.mas_equalTo(0);
        }];
        
        self.inputAssistantItem.leadingBarButtonGroups = @[];
        self.inputAssistantItem.trailingBarButtonGroups = @[];
        
        [self addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return self;
}

- (void)clickCloseAction{
    self.text = nil;
    self.closeButton.hidden = YES;
}

- (void)textFieldDidBegin:(UITextField *)textField{
    [self addSubview:self.closeButton];
    self.closeButton.hidden = !textField.text.length;
}

- (void)textFieldDidEnd:(UITextField *)textField{
    self.closeButton.hidden = YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    [self addSubview:self.closeButton];
    self.closeButton.hidden = !textField.text.length;
}

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return NO;
//}

@end
