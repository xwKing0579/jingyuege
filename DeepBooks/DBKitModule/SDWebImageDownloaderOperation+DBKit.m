//
//  SDWebImageDownloaderOperation+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/26.
//

#import "SDWebImageDownloaderOperation+DBKit.h"

@implementation SDWebImageDownloaderOperation (DBKit)

+ (void)load{
    [self swizzleInstanceMethod:@selector(URLSession:task:didCompleteWithError:) withSwizzleMethod:@selector(resetURLSession:task:didCompleteWithError:)];
}

- (void)resetURLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSMutableData *imageData = [self dynamicAllusionTomethod:@"imageData"];
    NSString *imageUrl = task.currentRequest.URL.absoluteString;
    if (imageData.length > 400 && [self shouldAllowURL:imageUrl]){
        for (int a = 400; a >= 0; a--) {
            if (a % 2 != 0) {
                [imageData replaceBytesInRange:NSMakeRange(a, 1) withBytes:NULL length:0];
            }
        }
    }
 
    [self resetURLSession:session task:task didCompleteWithError:error];
}

- (BOOL)shouldAllowURL:(NSString *)urlString {
    if (urlString.length == 0) {
        return NO;
    }
    
    NSString *pattern = @"^(https?://)[^/]*c-res\\.[^/]+/(?!ad([/?]|$)|qr([/?]|$))[^?]+";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                         options:0
                                                                           error:&error];
    if (error) {
        NSLog(@"Error creating regex: %@", error.localizedDescription);
        return NO;
    }
    
    NSRange range = NSMakeRange(0, urlString.length);
    return [regex numberOfMatchesInString:urlString options:0 range:range] > 0;
}


@end
