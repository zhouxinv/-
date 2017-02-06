//
//  AHDropMenuViewCell.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AHDropMenuItem;
@protocol AHDropMenuViewCellDelegate;
@interface AHDropMenuViewCell : UITableViewCell

@property(nonatomic, weak) id<AHDropMenuViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
// 为cell赋值
- (void)makeCellWithModel:(AHDropMenuItem *)mItem indexPath:(NSIndexPath *)indexPath;

@end

@protocol AHDropMenuViewCellDelegate <NSObject>

//自定义cell 暂时没实现
//- (void)configCell:(CGFloat)rowHeight
//   BackgroundColor:(UIColor *)backgroundColor
//              Font:(UIFont *)font
//       iconImage:(UIImage *)iconImage
//        checkImage:(UIImage *)checkImage;

@end


