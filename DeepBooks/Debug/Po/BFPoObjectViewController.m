//
//  BFPoObjectViewController.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/26.
//

#import "BFPoObjectViewController.h"
#import "BFJsonObjectModel.h"
#import "NSObject+Category.h"
@interface BFPoObjectViewController ()
@end

@implementation BFPoObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"po对象";
    if ([self.object isKindOfClass:[UIView class]] || [self.object isKindOfClass:[CALayer class]]){
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithTitle:@"shotImage" style:(UIBarButtonItemStyleDone) target:self action:@selector(shotObjectImage)],[[UIBarButtonItem alloc]initWithTitle:@"custom" style:(UIBarButtonItemStyleDone) target:self action:@selector(customPropertyList)]];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"去解析" style:(UIBarButtonItemStyleDone) target:self action:@selector(toJsonText)];
    }
   
    self.data = self.object.propertyList;
    [self.tableView reloadData];
}

- (void)toJsonText{
    [BFJsonObjectModel toJson:nil];
}

- (void)shotObjectImage{
    if (self.object) [BFRouter jumpUrl:BFString.vc_shot_object params:@{@"object":self.object}];
}

- (void)customPropertyList{
    if (!self.object) return;
    
    NSMutableArray *propertyList = [NSMutableArray array];
    if ([self.object isKindOfClass:[UILabel class]]){
        [propertyList addObjectsFromArray:[self.object customPropertyList:@[@"text",@"attributedText",@"font",@"textColor",@"textAlignment",@"numberOfLines",@"lineBreakMode"]]];
    }
    if ([self.object isKindOfClass:[UIImageView class]]){
        [propertyList addObjectsFromArray:[self.object customPropertyList:@[@"image",@"sd_currentImageURL"]]];

        UIImageView *imageView = (UIImageView *)self.object;
        if (imageView.image) [propertyList addObjectsFromArray:[imageView.image.imageAsset customPropertyList:@[@"assetName",@"containingBundle"]]];
    }
    if ([self.object isKindOfClass:[UIButton class]]){
        [propertyList addObjectsFromArray:[self.object customPropertyList:@[@"sd_currentImageURL"]]];
    }
    if ([self.object isKindOfClass:[UITextView class]]){
        [propertyList addObjectsFromArray:[self.object customPropertyList:@[@"text",@"font",@"textColor",@"textAlignment"]]];
    }
    if ([self.object isKindOfClass:[UITextField class]]){
        [propertyList addObjectsFromArray:[self.object customPropertyList:@[@"text",@"font",@"textColor",@"textAlignment",@"placeholder",@"attributedText"]]];
    }
    if ([self.object isKindOfClass:[UIView class]]){
        [propertyList addObjectsFromArray:[self.object customPropertyList:@[@"frame",@"bounds",@"backgroundColor",@"contentMode"]]];
        UIView *view = (UIView *)self.object;
        [propertyList addObjectsFromArray:[view.layer customPropertyList:@[@"cornerRadius",@"borderWidth",@"borderColor"]]];
    }

    [propertyList addObject:@{@"类":NSStringFromClass(self.object.class)}];
    [propertyList addObject:@{@"内存地址":[NSString stringWithFormat:@"%p",self.object]}];
    [propertyList addObject:@{@"指针地址":[NSString stringWithFormat:@"%lu",(uintptr_t)self.object]}];
    [propertyList addObject:@{@"描述":self.object.description}];
    self.data = propertyList;
    [self.tableView reloadData];
}

- (NSString *)cellClass{
    return BFString.tc_po_object;
}

@end
