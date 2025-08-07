//
//  DBMarqueeView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/16.
//

#import "DBMarqueeView.h"

@implementation DBMarqueeView {
    DBBaseLabel *_currentLabel;
    DBBaseLabel *_nextLabel;
    BOOL _isAnimating;
    BOOL _isPaused;
    NSInteger _currentMessageIndex;
    
    // 添加这两个属性记录暂停时的状态
    CGRect _pausedCurrentFrame;
    CGRect _pausedNextFrame;
    NSInteger _pausedMessageIndex;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    _duration = 1.2;
    _currentMessageIndex = 0;
    
    _currentLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height)];
    _currentLabel.textAlignment = NSTextAlignmentLeft;
    _currentLabel.textColor = DBColorExtension.charcoalColor;
    [self addSubview:_currentLabel];
    
    _nextLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(10, self.bounds.size.height, self.bounds.size.width-20, self.bounds.size.height)];
    _nextLabel.textAlignment = NSTextAlignmentLeft;
    _nextLabel.textColor = DBColorExtension.charcoalColor;
    [self addSubview:_nextLabel];
}

- (void)startAnimation {
    if (self.messages.count == 0) return;
    
    // 如果已经在动画中，先完全停止
    if (_isAnimating) {
        [self stopAnimation];
    }
    
    _isAnimating = YES;
    _isPaused = NO;
    _currentMessageIndex = 0;
    
    // 重置位置
    _currentLabel.frame = CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height);
    _nextLabel.frame = CGRectMake(10, self.bounds.size.height, self.bounds.size.width-20, self.bounds.size.height);
    
    // 初始化显示前两条消息
    _currentLabel.text = self.messages[_currentMessageIndex];
    _nextLabel.text = self.messages[(_currentMessageIndex + 1) % self.messages.count];
    
    [self animate];
    
}

- (void)animate {
    if (!_isAnimating || _isPaused) return;
    
    // 预先设置下一个Label的初始位置（屏幕下方）
    _nextLabel.frame = CGRectMake(10, self.bounds.size.height, self.bounds.size.width-20, self.bounds.size.height);
    
    // 使用UIViewAnimationOptionBeginFromCurrentState选项防止动画叠加
    [UIView animateWithDuration:_duration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self->_currentLabel.frame = CGRectMake(10, -self.bounds.size.height, self.bounds.size.width-20, self.bounds.size.height);
        self->_nextLabel.frame = CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (!self->_isAnimating || self->_isPaused) return;

        // 交换Label引用
        DBBaseLabel *temp = self->_currentLabel;
        self->_currentLabel = self->_nextLabel;
        self->_nextLabel = temp;
        
        // 更新下一个Label的文本
        self->_currentMessageIndex = (self->_currentMessageIndex + 1) % self.messages.count;
        NSInteger nextIndex = (self->_currentMessageIndex + 1) % self.messages.count;
        self->_nextLabel.text = self.messages[nextIndex];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animate];
        });
    }];
}

- (void)pauseAnimation {
    if (!_isAnimating || _isPaused) return;
    
    // 保存当前状态
    _pausedCurrentFrame = _currentLabel.frame;
    _pausedNextFrame = _nextLabel.frame;
    _pausedMessageIndex = _currentMessageIndex;
    _isPaused = YES;
    
    // 移除动画并保持当前帧
    [_currentLabel.layer removeAllAnimations];
    [_nextLabel.layer removeAllAnimations];
    _currentLabel.frame = _pausedCurrentFrame;
    _nextLabel.frame = _pausedNextFrame;
}

- (void)resumeAnimation {
    if (!_isAnimating || !_isPaused) return;
    
    // 恢复暂停时的状态
    _currentLabel.frame = _pausedCurrentFrame;
    _nextLabel.frame = _pausedNextFrame;
    _currentMessageIndex = _pausedMessageIndex;
    
    _isPaused = NO;
    
    // 确保标签内容正确
    _currentLabel.text = self.messages[_currentMessageIndex];
    NSInteger nextIndex = (_currentMessageIndex + 1) % self.messages.count;
    _nextLabel.text = self.messages[nextIndex];
    
    // 重新开始动画
    [self animateFromCurrentPosition];
}

- (void)animateFromCurrentPosition {
    if (!_isAnimating || _isPaused) return;
    
    // 计算动画持续时间比例（根据当前位置）
    CGFloat progress = 1.0 - (_currentLabel.frame.origin.y + self.bounds.size.height) / self.bounds.size.height;
    CGFloat remainingDuration = _duration * MAX(0, MIN(1, progress));
    
    [UIView animateWithDuration:remainingDuration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self->_currentLabel.frame = CGRectMake(10, -self.bounds.size.height, self.bounds.size.width-20, self.bounds.size.height);
        self->_nextLabel.frame = CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (!self->_isAnimating || self->_isPaused) return;
        
        // 正常继续动画循环
        [self continueAnimationCycle];
    }];
}

- (void)continueAnimationCycle {
    // 交换Label引用
    DBBaseLabel *temp = self->_currentLabel;
    self->_currentLabel = self->_nextLabel;
    self->_nextLabel = temp;
    
    // 更新下一个Label的文本
    self->_currentMessageIndex = (self->_currentMessageIndex + 1) % self.messages.count;
    NSInteger nextIndex = (self->_currentMessageIndex + 1) % self.messages.count;
    self->_nextLabel.text = self.messages[nextIndex];
    
    // 重置位置
    self->_nextLabel.frame = CGRectMake(10, self.bounds.size.height, self.bounds.size.width-20, self.bounds.size.height);
    
    // 添加短暂停顿
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animate];
    });
}

- (void)stopAnimation {
    _isAnimating = NO;
    _isPaused = NO;
    [self.layer removeAllAnimations];
    [_currentLabel.layer removeAllAnimations];
    [_nextLabel.layer removeAllAnimations];
}

@end
