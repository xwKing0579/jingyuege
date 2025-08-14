//
//  DBCarouselCycleView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/2.
//

#import "DBCarouselCycleView.h"
#import <iCarousel/iCarousel.h>
#import "DBGridQuotedView.h"
#import "DBCustomPageView.h"
@interface DBCarouselCycleView ()<iCarouselDelegate,iCarouselDataSource>
@property (nonatomic, strong) iCarousel *carouselCycleView;
@property (nonatomic, strong) DBCustomPageView *customPageControl;
@property (strong, nonatomic) NSTimer *autoScrollTimer;
@end

@implementation DBCarouselCycleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.clipsToBounds = YES;
    [self addSubviews:@[self.carouselCycleView,self.customPageControl]];
    
    NSArray *imageList = @[@"hotBook",@"sellBestBook",@"rankBook"];
    NSArray *titleList = @[@"追书最热榜",@"畅销小说",@"全部榜单"];
    NSArray *starColors = @[DBColorExtension.peachCreamColor,DBColorExtension.blossomPinkColor,DBColorExtension.freshBlueColor];
    NSArray *endColors = @[DBColorExtension.ivoryWhiteColor,DBColorExtension.candyPinkColor,DBColorExtension.mistyBlueColor];
    CGFloat top = 182.0;
    CGFloat left = 12.0;
    CGFloat height = 68.0;
    CGFloat space = 8.0;
    CGFloat width = (UIScreen.screenWidth-left*2-space*(imageList.count-1))/(CGFloat)imageList.count;
    for (NSInteger index = 0; index < titleList.count; index++) {
        DBGridQuotedView *bookEnterView = [[DBGridQuotedView alloc] initWithFrame:CGRectMake(left, top, width, height)];
        bookEnterView.imageObj = imageList[index];
        bookEnterView.nameStr = titleList[index];
        bookEnterView.tag = index;
        [bookEnterView gradientStartColor:starColors[index] endColor:endColors[index]];
        [bookEnterView addTapGestureTarget:self action:@selector(clickBookEnterAction:)];
        [self addSubview:bookEnterView];
        left += width+space;
    }
}

- (void)clickBookEnterAction:(UITapGestureRecognizer *)tap{
    UIView *tapView = tap.view;
    switch (tapView.tag) {
        case 0:
            [DBRouter openPageUrl:DBHottestList params:@{@"defaultIndex":@(self.tag)}];
            break;
        case 1:
            [DBRouter openPageUrl:DBBestsellerList params:@{@"defaultIndex":@(self.tag)}];
            break;
        case 2:
            [DBRouter openPageUrl:DBGenderBooks params:@{@"defaultIndex":@(self.tag)}];
            break;
        default:
            break;
    }
}

- (void)setImageGroup:(NSArray *)imageGroup{
    _imageGroup = imageGroup;
    if (imageGroup.count == 0) return;
    
    self.customPageControl.numberOfPages = imageGroup.count;
    [self.carouselCycleView reloadData];
}

- (void)setImageModelGroup:(NSArray<DBBannerModel *> *)imageModelGroup{
    _imageModelGroup = imageModelGroup;
    if (imageModelGroup.count == 0) return;
    
    NSMutableArray *imageGroup = [NSMutableArray array];
    for (DBBannerModel *item in imageModelGroup) {
        if (item.image) [imageGroup addObject:item.image];
    }
    self.imageGroup = imageGroup;
}

- (void)startBannerScroll{
    [self endBannerScroll];
    
    DBWeakSelf
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        DBStrongSelfElseReturn
        NSInteger index = (self.carouselCycleView.currentItemIndex+1)%self.imageGroup.count;
        [self.carouselCycleView scrollToItemAtIndex:index animated:YES];
    }];
}

- (void)endBannerScroll{
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

#pragma mark - iCarouselDataSource,iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.imageGroup.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc] initWithFrame:carousel.bounds];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 8, view.width-48, carousel.height-16)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 12;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = DBColorExtension.noColor;
        [view addSubview:imageView];
    }
    UIImageView *bannerImageView = (UIImageView *)view.subviews.firstObject;
    bannerImageView.imageObj = self.imageGroup[index%self.imageGroup.count];
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    DBBannerModel *model = self.imageModelGroup[index%self.imageModelGroup.count];
    if (model.type == 1){
        [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.data.book_id)}];
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    self.customPageControl.currentDotPage = carousel.currentItemIndex%_imageGroup.count;
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel{
    [self endBannerScroll];
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel{
    [self startBannerScroll];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return 1;
        default:
            return value;
    }
}

- (iCarousel *)carouselCycleView{
    if (!_carouselCycleView){
        _carouselCycleView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 8, UIScreen.screenWidth, (UIScreen.screenWidth-48)*146.0/325.0)];
        _carouselCycleView.delegate = self;
        _carouselCycleView.dataSource = self;
    
        _carouselCycleView.autoscroll = 0;
        _carouselCycleView.pagingEnabled = YES;
        _carouselCycleView.scrollEnabled = YES;
        _carouselCycleView.type = iCarouselTypeRotary;
        _carouselCycleView.backgroundColor = DBColorExtension.noColor;
    }
    return _carouselCycleView;
}

- (DBCustomPageView *)customPageControl{
    if (!_customPageControl){
        _customPageControl = [[DBCustomPageView alloc] initWithFrame:CGRectMake(25, _carouselCycleView.height+12, UIScreen.screenWidth-50, 4)];
    }
    return _customPageControl;
}

@end
