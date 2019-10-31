//
//  GLPhotoModel.h
//  MultiTarget1
//
//  Created by lijinhai on 2019/10/30.
//  Copyright © 2019 gaussli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPhotoModel : NSObject
@property(strong, nonatomic) PHAsset *asset;
@property(assign, nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
