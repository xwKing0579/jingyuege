//
//  DBReadBookView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/4.
//

#import "DBReadBookView.h"
#import <CoreText/CoreText.h>
#import "DBReadBookSetting.h"
@implementation DBReadBookView


- (void)setAttributeString:(NSAttributedString *)attributeString{
    _attributeString = attributeString;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (self.attributeString.string.length == 0) return;
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) self.attributeString);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGPathRef pathRef = CGPathCreateWithRect(self.bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), pathRef, NULL);
    CTFrameDraw(frameRef, ctx);
    
    CFRelease(frameRef);
    CGPathRelease(pathRef);
    CFRelease(frameSetter);
}

@end
