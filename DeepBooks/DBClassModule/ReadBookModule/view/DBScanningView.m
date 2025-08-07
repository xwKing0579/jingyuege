//
//  DBScanningView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import "DBScanningView.h"
#import "DBScaningSettingView.h"
#import "DBReadBookSetting.h"
#import "DBReadBookView.h"
@interface DBScanningView ()
@property (nonatomic, strong) UIImageView *scanBar; // 扫描杆
@property (nonatomic, assign) CGFloat scanProgress;
@property (nonatomic, strong) CADisplayLink *displayLink; // 用于自动扫描的定时器

@property (nonatomic, strong) DBScaningSettingView *scaningSettingView;

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation DBScanningView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.zPosition = 1;
        self.backgroundColor = DBColorExtension.noColor;
        [self setupScanBar];
        [self setupGestureRecognizer];
    }
    return self;
}

- (void)setNextPageContentView:(UIView *)nextPageContentView{
    _nextPageContentView = nextPageContentView;
    
    if (nextPageContentView) {
        nextPageContentView.frame = self.bounds;
        [self addSubview:nextPageContentView];

        self.maskLayer = [CAShapeLayer layer];
        self.maskLayer.frame = self.bounds;
        self.maskLayer.fillColor = [DBColorExtension blackColor].CGColor;
        nextPageContentView.layer.mask = self.maskLayer;
    }
    
    [self updateMaskWithProgress:0];
}

- (void)updateMaskWithProgress:(CGFloat)progress {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * progress)];
    self.maskLayer.path = path.CGPath;
}

// 初始化扫描杆
- (void)setupScanBar {
    self.scanBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 8)];
    self.scanBar.userInteractionEnabled = YES;
    self.scanBar.image = [UIImage imageNamed:@"scanBar_icon"];
    [self addSubview:self.scanBar];
}

// 添加拖动手势识别器
- (void)setupGestureRecognizer {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
    
    [self addTapGestureTarget:self action:@selector(tapPan:)];
}

- (void)tapPan:(UIPanGestureRecognizer *)gesture{
    [self stopAutoScan];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DBScaningSettingView *scaningSettingView = [[DBScaningSettingView alloc] init];
        [UIScreen.appWindow addSubview:scaningSettingView];
        [scaningSettingView showAnimate];
        self.scaningSettingView = scaningSettingView;
        
        DBWeakSelf
        scaningSettingView.scanContinueBlock = ^(BOOL finish) {
            DBStrongSelfElseReturn
            [self startAutoScan];
        };
        scaningSettingView.scanFinishBlock = ^(BOOL finish) {
            DBStrongSelfElseReturn
            [self removeFromSuperview];
            if (self.scanFinishBlock) self.scanFinishBlock();
        };
    });

}

// 处理拖动手势
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self stopAutoScan];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:self];
            CGFloat newY = self.scanBar.center.y + translation.y;
            newY = MAX(newY, 0); // 不能超出顶部
            newY = MIN(newY, self.bounds.size.height); // 不能超出底部
            self.scanBar.center = CGPointMake(self.scanBar.center.x, newY);
            self.scanProgress = newY / self.bounds.size.height;
            [gesture setTranslation:CGPointZero inView:self];
            [self setNeedsDisplay];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self startAutoScan];
            break;
        }
        default:
            break;
    }
    
}

// 重写 scanProgress 的 setter 方法
- (void)setScanProgress:(CGFloat)scanProgress {
    _scanProgress = scanProgress;
    // 更新扫描杆的位置
    self.scanBar.center = CGPointMake(self.scanBar.center.x, self.bounds.size.height * scanProgress);
    [self updateMaskWithProgress:scanProgress];
    [self setNeedsDisplay];
}

// 开始自动扫描
- (void)startAutoScan {
    if (self.isAutoScanning) {
        return;
    }
    
    self.isAutoScanning = YES;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAutoScan)];
    self.displayLink.preferredFramesPerSecond = 30;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// 停止自动扫描
- (void)stopAutoScan {
    if (!self.isAutoScanning) {
        return;
    }
    
    self.isAutoScanning = NO;
    if (self.displayLink){
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}


- (void)updateAutoScan {
    self.scanProgress += DBReadBookSetting.setting.scrollSpeed;
    if (self.scanProgress >= 1.0) {
        self.scanProgress = 0.0;
        [_nextPageContentView removeFromSuperview];
        if (self.scanCompletionBlock) self.scanCompletionBlock();
    }
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.targetView) {
        return;
    }
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:self.targetView.bounds.size];
    UIImage *snapshot = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.targetView setNeedsDisplay];
            [self.targetView drawViewHierarchyInRect:self.targetView.bounds afterScreenUpdates:YES];
        });
    }];
    
    [snapshot drawInRect:rect];
    CGRect scanRect = CGRectMake(0, 0, rect.size.width, rect.size.height * self.scanProgress);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:0.1].CGColor);
    CGContextFillRect(context, scanRect);
}

@end
