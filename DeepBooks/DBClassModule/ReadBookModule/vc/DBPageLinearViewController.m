//
//  DBPageLinearViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import "DBPageLinearViewController.h"
#import "DBReaderPageViewController.h"
#import "DBReadBookBackViewController.h"
#import "DBReadBookSetting.h"
#import "DBReaderEndViewController.h"
#import "DBReaderAdViewController.h"

@interface DBPageLinearViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPageViewController *pageBoyViewController;
@property (nonatomic, strong) DBReadBookBackViewController *mirrorVc;

@property (nonatomic, strong) DBReaderAdViewController *readerAdVc;
@end

@implementation DBPageLinearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self addChildViewController:self.pageBoyViewController];
    [self.view addSubview:self.pageBoyViewController.view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (!self.model) return;
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (touchPoint.x < UIScreen.screenWidth/3){
        if (self.model.currentChapter == 0 && self.model.currentPage == 0) {
            [self.view showAlertText:@"已经是第一页"];
            return;
        }
        
        UIViewController *nextVc = [self getReaderAdViewController:NO]?:[self getReaderPageController:NO isTap:YES];
        if (nextVc && self.mirrorVc) {
            [self.pageBoyViewController setViewControllers:@[nextVc,self.mirrorVc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            }];
        }
    }else if (touchPoint.x > UIScreen.screenWidth*2/3){
        if (self.model.currentChapter == self.model.chapterCacheList.count-1 && self.model.currentPage == self.model.contentList.count-1) return;
        UIViewController *nextVc = [self getReaderAdViewController:YES]?:[self getReaderPageController:YES isTap:YES];
        if (nextVc && self.mirrorVc) {
            [self.pageBoyViewController setViewControllers:@[nextVc,self.mirrorVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            }];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self.view];
    if (touchPoint.x < UIScreen.screenWidth/3 || touchPoint.x > UIScreen.screenWidth*2/3){
        return YES;
    }
    return NO;
}

- (void)setModel:(DBReaderModel *)model{
    _model = model;
    
    DBReaderPageViewController *nextVc = [[DBReaderPageViewController alloc] init];
    nextVc.model = model;
    [self.pageBoyViewController setViewControllers:@[nextVc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
    }];
}

- (void)appWillResignActive:(NSNotification *)notification {
    DBReaderPageViewController *readerPageVc = self.pageBoyViewController.viewControllers.firstObject;
    if ([readerPageVc isKindOfClass:DBReaderPageViewController.class]){
        self.model.currentPage = readerPageVc.currentPageIndex;
        self.model.currentChapter = readerPageVc.currentChapterIndex;
        self.model.isAdPage = NO;
    }
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if (![viewController isEqual:self.mirrorVc]){
        self.mirrorVc.backImage = viewController.view.captureMirrorImage;
        return self.mirrorVc;
    }
    
    if (self.model.currentChapter == 0 && self.model.currentPage == 0) {
        return nil;
    }
    
    DBReaderAdViewController *readerAdVc = [self getReaderAdViewController:NO];
    if (readerAdVc) return readerAdVc;
    
    return [self getReaderPageController:NO isTap:NO];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (![viewController isEqual:self.mirrorVc]){
        self.mirrorVc.backImage = viewController.view.captureMirrorImage;
        return self.mirrorVc;
    }
    
    if (self.model.isEnd) return nil;
    if (self.model.currentChapter == self.model.chapterCacheList.count-1 && self.model.currentPage == self.model.contentList.count-1) {
        DBReaderEndViewController *endVc = [[DBReaderEndViewController alloc] init];
        endVc.model = self.model;
        self.model.isEnd = YES;
        return endVc;
    }
    
    DBReaderAdViewController *readerAdVc = [self getReaderAdViewController:YES];
    if (readerAdVc) return readerAdVc;
    
    return [self getReaderPageController:YES isTap:NO];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    DBReaderPageViewController *readerPageVc = self.pageBoyViewController.viewControllers.firstObject;
    if ([readerPageVc isKindOfClass:DBReaderPageViewController.class]){
        self.model.currentPage = readerPageVc.currentPageIndex;
        self.model.currentChapter = readerPageVc.currentChapterIndex;
    }
}

- (DBReaderPageViewController *)getReaderPageController:(BOOL)after isTap:(BOOL)isTap{
    DBReaderPageViewController *nextVc = [[DBReaderPageViewController alloc] init];
    if (after){
        if (self.model.isAdPage && !self.readerAdVc.after){
            nextVc.model = self.model;
        }else{
            nextVc.model = isTap ? [self.model getNextPageChapterModelWithDiff:1] : [self.model getNextPageChapterNosetModelWithDiff:1];
        }
    }else{
        if (self.model.isEnd) {
            nextVc.model = self.model;
        }else if (self.model.isAdPage){
            if (self.readerAdVc.after){
                nextVc.model = self.model;
            }else{
                nextVc.model = isTap ? [self.model getNextPageChapterModelWithDiff:-1] : [self.model getNextPageChapterNosetModelWithDiff:-1];
            }
        }else{
            nextVc.model = isTap ? [self.model getNextPageChapterModelWithDiff:-1] : [self.model getNextPageChapterNosetModelWithDiff:-1];
        }
        if (self.model.isEnd) self.model.isEnd = NO;
    }
    if (self.model.isAdPage) self.model.isAdPage = NO;
    return nextVc;
}

- (DBReaderAdViewController *)getReaderAdViewController:(BOOL)after{
    if (self.model.isAdPage)  return nil;
    
    DBReaderAdType adType = [DBReaderAdViewModel getReaderAdTypeWithModel:self.model after:after];
    if (adType == DBReaderNoAd) return nil;
    
    self.readerAdVc.readerAdType = adType;
    self.readerAdVc.after = after;
    self.model.isAdPage = YES;
    return self.readerAdVc;
}

- (UIPageViewController *)pageBoyViewController{
    if (!_pageBoyViewController){
        _pageBoyViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageBoyViewController.view.frame = self.view.bounds;
        _pageBoyViewController.delegate = self;
        _pageBoyViewController.dataSource = self;
        _pageBoyViewController.doubleSided = YES;
        
        for (UIGestureRecognizer *gestureRecognizer in _pageBoyViewController.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                gestureRecognizer.enabled = NO;
            }
        }
    }
    return _pageBoyViewController;
}

- (DBReadBookBackViewController *)mirrorVc{
    if (!_mirrorVc){
        _mirrorVc = [[DBReadBookBackViewController alloc] init];
    }
    return _mirrorVc;
}

- (DBReaderAdViewController *)readerAdVc{
    if (!_readerAdVc){
        _readerAdVc = [[DBReaderAdViewController alloc] init];
    }
    return _readerAdVc;
}


@end
