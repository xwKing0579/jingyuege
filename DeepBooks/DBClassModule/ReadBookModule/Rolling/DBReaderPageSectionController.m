//
//  DBReaderPageSectionController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/15.
//

#import "DBReaderPageSectionController.h"
#import "DBReadBookSetting.h"
#import "DBPageScrollCollectionViewCell.h"
#import "DBScrollAdCollectionViewCell.h"

@interface DBReaderPageSectionController ()

@end

@implementation DBReaderPageSectionController


- (NSInteger)numberOfItems {
    return 1 + (_model.finish && _model.adType != DBReaderNoAd);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    if (index){
        DBScrollAdCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:DBScrollAdCollectionViewCell.class forSectionController:self atIndex:index];
        return cell;
    }else{
        DBPageScrollCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:DBPageScrollCollectionViewCell.class forSectionController:self atIndex:index];
        cell.model = _model;
        return cell;
    }
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    if (index == 0) {
        return CGSizeMake(UIScreen.screenWidth,_model.finish ? _model.cellHeight : 60);
    }
    return CGSizeMake(UIScreen.screenWidth, DBReadBookSetting.calculateCanvaseSize.height-60);
}

- (void)didUpdateToObject:(id)object {
    _model = object;
}

@end
