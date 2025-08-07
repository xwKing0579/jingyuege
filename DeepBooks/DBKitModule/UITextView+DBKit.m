//
//  UITextView+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "UITextView+DBKit.h"

static NSArray *propertyList;
static const void *WZBPlaceholderViewKey = &WZBPlaceholderViewKey;
@interface UITextView ()
@property (nonatomic, strong) UITextView *placeView;
@property (nonatomic, assign) BOOL isObserve;
@end

@implementation UITextView (DBKit)

- (BOOL)isObserve{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setIsObserve:(BOOL)isObserve{
    objc_setAssociatedObject(self, @selector(isObserve), @(isObserve), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)placeholder{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholder:(NSString *)placeholder{
    self.placeView.text = placeholder;
    [self textViewTextChange];
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSAttributedString *)attriPlaceHolder{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttriPlaceHolder:(NSAttributedString *)attriPlaceHolder{
    self.placeView.attributedText = attriPlaceHolder;
    objc_setAssociatedObject(self, @selector(attriPlaceHolder), attriPlaceHolder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UITextView *)placeView{
    UITextView *placeView = objc_getAssociatedObject(self, _cmd);
    if (!placeView){
        placeView = [UITextView new];
        placeView.backgroundColor = DBColorExtension.noColor;
        placeView.userInteractionEnabled = NO;
        placeView.textColor = DBColorExtension.grayColor;
        placeView.layer.anchorPoint = CGPointZero;
        [self addSubview:placeView];
        objc_setAssociatedObject(self, @selector(placeView), placeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange) name:UITextViewTextDidChangeNotification object:nil];
        propertyList = @[@"text",@"frame",@"bounds",@"font",@"textAlignment",@"textContainerInset"];
        for (NSString *property in propertyList) {
            [self placeViewPropertyChangeForKeyPath:property];
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
        }
        self.isObserve = YES;
    }
    return placeView;
}

- (void)textViewTextChange{
    self.placeView.hidden = self.text.length > 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]){
        [self textViewTextChange];
    }else{
        [self placeViewPropertyChangeForKeyPath:keyPath];
    }
}

- (void)placeViewPropertyChangeForKeyPath:(NSString *)keyPath{
    [self.placeView setValue:[self valueForKeyPath:keyPath] forKeyPath:keyPath];
}

- (void)dealloc{
    if (self.isObserve){
        for (NSString *property in propertyList) {
            [self removeObserver:self forKeyPath:property];
        }
    }
}
@end
