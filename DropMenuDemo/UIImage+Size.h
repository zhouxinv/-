//
//  UIImage+Size.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/2/24.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)
+ (UIImage *)ak_scaleImage:(UIImage *)image toSize:(CGSize)targetSize isBaseOnShortEdge:(BOOL)isBaseOnShortEdge;
@end
