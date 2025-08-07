//
//  DBCustomPageView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/3.
//

#import "DBCustomPageView.h"

@interface DBCustomPageView ()
@property (nonatomic, strong) NSMutableArray *pageViews;
@end

@implementation DBCustomPageView
{
    CGFloat _pageViewWidth;
    CGFloat _pageViewHeight;
    CGFloat _pageViewSelectedWidth;
    CGFloat _pageViewSpace;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.currentDotPage = 0;
    self.pageViews = [NSMutableArray array];
    
    _pageViewWidth = 12;
    _pageViewHeight = 4;
    _pageViewSelectedWidth = 12;
    _pageViewSpace = 8;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    
    if (self.pageViews.count == numberOfPages) return;
    
    [self removeAllSubView];
    [self.pageViews removeAllObjects];
    
    if (numberOfPages < 2) return;
    CGFloat longWidth = (numberOfPages-1)*(_pageViewWidth+_pageViewSpace) + _pageViewSelectedWidth;
    CGFloat left = (self.width-longWidth)*0.5;
    for (NSInteger index = 0; index < numberOfPages; index++) {
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(left, (self.height-_pageViewHeight)*0.5, index == self.currentDotPage ? _pageViewSelectedWidth : _pageViewWidth, _pageViewHeight)];
        pageView.tag = index;
        pageView.backgroundColor = (index == self.currentDotPage) ? DBColorExtension.sunsetOrangeColor : DBColorExtension.fogSilverColor;
        pageView.layer.cornerRadius = 2;
        pageView.layer.masksToBounds = YES;
        [self addSubview:pageView];
        [self.pageViews addObject:pageView];
        left += pageView.width + _pageViewSpace;
    }
}

- (void)setCurrentDotPage:(NSInteger)currentDotPage{
    _currentDotPage = currentDotPage;
    if (self.numberOfPages < 2) return;

    for (NSInteger index = 0; index < self.pageViews.count; index++) {
        UIView *pageView = self.pageViews[index];
        pageView.backgroundColor = (index == currentDotPage) ? DBColorExtension.sunsetOrangeColor : DBColorExtension.fogSilverColor;
    }
}


@end
