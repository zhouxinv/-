//
//  UIImage+Size.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/2/24.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

+ (UIImage *)ak_scaleImage:(UIImage *)image toSize:(CGSize)targetSize isBaseOnShortEdge:(BOOL)isBaseOnShortEdge {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    float imageRatio = imageWidth/imageHeight * 1.0;
    float targetRatio = targetWidth/targetHeight * 1.0;
    NSLog(@"imageRatio %f targetRatio %f",imageRatio,targetRatio);
    
    // 根据 isBaseOnShortEdge 进行图片是否需要进行缩放的判断
    if (isBaseOnShortEdge) {
        if (targetRatio>=1) {
            if (imageRatio >= 1) {
                if (imageHeight <= targetHeight) {
                    return image;
                }
            } else {
                if (imageWidth <= targetHeight) {
                    return image;
                }
            }
        } else {
            if (imageRatio >= 1) {
                if (imageHeight <= targetWidth) {
                    return image;
                }
            } else {
                if (imageWidth <= targetWidth) {
                    return image;
                }
            }
        }
    } else {
        if (targetRatio>=1) {
            if (imageRatio >= 1) {
                if (imageWidth <= targetWidth) {
                    return image;
                }
            } else {
                if (imageHeight <= targetWidth) {
                    return image;
                }
            }
        } else {
            if (imageRatio >= 1) {
                if (imageWidth <= targetHeight) {
                    return image;
                }
            } else {
                if (imageHeight <= targetHeight) {
                    return image;
                }
            }
        }
    }
    
    
    CGSize finalSize = [self finalSizeByImageSize:image.size targetSize:targetSize isBaseOnShortEdge:isBaseOnShortEdge];
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(finalSize);
    
    // 绘制改变大小的图片
    //    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    [image drawInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *  图片缩放大小计算
 *
 *  @param imageSize         原图大小
 *  @param targetSize        目标大小
 *  @param isBaseOnShortEdge 是否以最小边为基准: YES 以短边为基准, 长边会超出目标长边; NO 以长边为基准,最长边不超过目标的长边.
 *
 *  @return 计算后的图片实际大小
 */
+ (CGSize)finalSizeByImageSize:(CGSize)imageSize targetSize:(CGSize)targetSize isBaseOnShortEdge:(BOOL)isBaseOnShortEdge {
    
    CGSize finalSize = targetSize;
    
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    float imageRatio = imageWidth/imageHeight * 1.0;
    float targetRatio = targetWidth/targetHeight * 1.0;
    
    // ratio(宽度/高度): >1 : 宽>高; <1 : 宽<高; =1 : 宽=高
    NSLog(@"imageRatio %f targetRatio %f",imageRatio,targetRatio);
    
    // 根据 isBaseOnShortEdge 进行图片是否需要进行缩放的判断, 如无需缩放, 返回图片大小
    if (isBaseOnShortEdge) {
        if (targetRatio>=1) {
            if (imageRatio >= 1) {
                if (imageHeight <= targetHeight) {
                    return imageSize;
                }
            } else {
                if (imageWidth <= targetHeight) {
                    return imageSize;
                }
            }
        } else {
            if (imageRatio >= 1) {
                if (imageHeight <= targetWidth) {
                    return imageSize;
                }
            } else {
                if (imageWidth <= targetWidth) {
                    return imageSize;
                }
            }
        }
    } else {
        if (targetRatio>=1) {
            if (imageRatio >= 1) {
                if (imageWidth <= targetWidth) {
                    return imageSize;
                }
            } else {
                if (imageHeight <= targetWidth) {
                    return imageSize;
                }
            }
        } else {
            if (imageRatio >= 1) {
                if (imageWidth <= targetHeight) {
                    return imageSize;
                }
            } else {
                if (imageHeight <= targetHeight) {
                    return imageSize;
                }
            }
        }
    }
    
    
    if (isBaseOnShortEdge) { // 以短边为基准, 长边会超出目标长度.
        if (targetRatio >= 1) { // 目标 宽 >= 高
            if (imageRatio > 1) {
                targetWidth = targetHeight*imageRatio;
                finalSize.width = targetWidth;
            }
            else if(imageRatio < 1) {
                targetWidth = targetHeight/imageRatio;
                finalSize = CGSizeMake(targetHeight, targetWidth);
            }
            else {
                finalSize = CGSizeMake(targetHeight, targetHeight);
            }
        }
        else { // 目标 宽 < 高
            if (imageRatio > 1) {
                targetHeight = targetWidth*imageRatio;
                finalSize = CGSizeMake(targetHeight, targetWidth);
            }
            else if(imageRatio < 1) {
                targetHeight = targetWidth/imageRatio;
                finalSize.height = targetHeight;
            }
            else {
                finalSize = CGSizeMake(targetWidth, targetWidth);
            }
        }
    } else { // 以长边为基准, 长边不会超出目标长度.
        if (targetRatio >= 1) { // 目标 宽 >= 高
            if (imageRatio > 1) {
                targetHeight = targetWidth/imageRatio;
                finalSize.height = targetHeight;
            }
            else if(imageRatio < 1) {
                targetHeight = targetWidth*imageRatio;
                finalSize = CGSizeMake(targetHeight, targetWidth);
            }
            else {
                finalSize = CGSizeMake(targetHeight, targetHeight);
            }
        }
        else { // 目标 宽 < 高
            if (imageRatio > 1) {
                targetWidth = targetHeight/imageRatio;
                finalSize = CGSizeMake(targetHeight, targetWidth);
            }
            else if(imageRatio < 1) {
                targetWidth = targetHeight*imageRatio;
                finalSize.width = targetWidth;
            }
            else {
                finalSize = CGSizeMake(targetWidth, targetWidth);
            }
        }
    }
    
    NSLog(@"finalSizeWidth %f finalSizeHeight %f", finalSize.width, finalSize.height);
    
    return finalSize;
}

@end
