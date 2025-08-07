//
//  NSAttributedString+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "NSAttributedString+DBKit.h"

@implementation NSAttributedString (DBKit)

+ (NSMutableAttributedString *)combineAttributeTexts:(NSArray *)texts colors:(NSArray *)colors fonts:(NSArray *)fonts{
    return [self combineAttributeTexts:texts colors:colors fonts:fonts attrs:@[]];
}

+ (NSMutableAttributedString *)combineAttributeTexts:(NSArray *)texts colors:(NSArray *)colors fonts:(NSArray *)fonts attrs:(NSArray <NSDictionary *>* __nullable)attrs{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [texts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:obj];
        UIColor *colorValue = UIColor.whiteColor;
        if (colors.count > idx) {
            colorValue = colors[idx];
        }else{
            colorValue = [colors lastObject];
        }
        
        UIFont *fontValue = [UIFont systemFontOfSize:12];
        if (fonts.count > idx) {
            fontValue = fonts[idx];
        }else{
            fontValue = [fonts lastObject];
        }
        
        [attribute addAttributes:@{
                                    NSForegroundColorAttributeName: colorValue,
                                    NSFontAttributeName: fontValue
                                    } range:NSMakeRange(0, attribute.length)];
        
        if (attrs.count > idx) {
            id thing = attrs[idx];
            if ([thing isKindOfClass:[NSDictionary class]]) {
                [attribute addAttributes:thing range:NSMakeRange(0, attribute.length)];
            }
        }
        [attributedString appendAttributedString:attribute];
    }];
    return attributedString;
}



@end
