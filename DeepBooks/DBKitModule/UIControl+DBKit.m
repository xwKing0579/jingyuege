//
//  UIControl+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIControl+DBKit.h"

static const void *DBControlHandlersKey = &DBControlHandlersKey;

@interface DBControlWrapper : NSObject <NSCopying>

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation DBControlWrapper

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    self = [super init];
    if (!self) return nil;

    self.handler = handler;
    self.controlEvents = controlEvents;

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[DBControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender
{
    self.handler(sender);
}

@end

@implementation UIControl (DBKit)

- (void)setEnlargedEdgeInsets:(UIEdgeInsets)enlargedEdgeInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:enlargedEdgeInsets];
    objc_setAssociatedObject(self, @selector(enlargedEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)enlargedEdgeInsets{
    NSValue *value = objc_getAssociatedObject(self, @selector(enlargedEdgeInsets));
    if (value) return [value UIEdgeInsetsValue];
    return UIEdgeInsetsZero;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.enlargedEdgeInsets, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }

    UIEdgeInsets enlarge = UIEdgeInsetsMake(-self.enlargedEdgeInsets.top, -self.enlargedEdgeInsets.left, -self.enlargedEdgeInsets.bottom, -self.enlargedEdgeInsets.right);
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, enlarge);
    return CGRectContainsPoint(hitFrame, point);
}


- (void)addTagetHandler:(void (^)(id sender))handler controlEvents:(UIControlEvents)controlEvents{
    NSParameterAssert(handler);
    NSMutableDictionary *events = objc_getAssociatedObject(self, DBControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, DBControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    DBControlWrapper *target = [[DBControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
    [handlers addObject:target];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

@end
