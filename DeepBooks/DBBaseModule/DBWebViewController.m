//
//  DBWebViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBWebViewController.h"
#import <WebKit/WebKit.h>
@interface DBWebViewController ()
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation DBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.navLabel,self.webView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    
    [self.webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)setDarkModel{
    [super setDarkModel];
    self.webView.backgroundColor = DBColorExtension.whiteColor;
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView){
            self.navLabel.text = self.webView.title;
        }
    }
}

- (WKWebView *)webView{
    if (!_webView){
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.websiteDataStore = WKWebsiteDataStore.defaultDataStore;
        config.userContentController = [[WKUserContentController alloc] init];
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preferences;
        config.allowsInlineMediaPlayback = YES;
        config.processPool = WKProcessPool.new;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    }
    return _webView;
}
@end
