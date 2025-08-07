//
//  UIImageView+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "UIImageView+DBKit.h"
#import <SDWebImage/SDWebImage.h>
@implementation UIImageView (DBKit)

- (void)setImageObj:(id)imageObj{
    if ([imageObj isKindOfClass:[NSString class]]){
        if ([(NSString *)imageObj hasPrefix:@"http"]){
            [self sd_setImageWithURL:[NSURL URLWithString:imageObj] placeholderImage:[UIImage imageNamed:@"appLogo"]];
        }else{
            self.image = [UIImage imageNamed:imageObj];
        }
    }else if ([imageObj isKindOfClass:[UIImage class]]){
        self.image = (UIImage *)imageObj;
    }else if ([imageObj isKindOfClass:[NSData class]]){
        self.image = [UIImage imageWithData:imageObj];
    }
}

- (id)imageObj{
    return nil;
}

@end

