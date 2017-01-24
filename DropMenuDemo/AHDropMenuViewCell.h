//
//  AHDropMenuViewCell.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AHDropMenuViewModel;
@protocol AHDropMenuViewCellDelegate;
@interface AHDropMenuViewCell : UITableViewCell

@property(nonatomic, weak) id<AHDropMenuViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
// 为cell赋值
- (void)makeCellWithModel:(AHDropMenuViewModel *)mItem indexPath:(NSIndexPath *)indexPath;
//设置标题字体大小
- (void)setTitleFontSize:(CGFloat)fontSize;
//设置标题字体颜色
- (void)setTitleColor:(UIColor *)titleColor;

@end

@protocol AHDropMenuViewCellDelegate <NSObject>

//自定义cell 暂时没实现
//- (void)configCell:(CGFloat)rowHeight
//   BackgroundColor:(UIColor *)backgroundColor
//              Font:(UIFont *)font
//       iconImage:(UIImage *)iconImage
//        checkImage:(UIImage *)checkImage;

@end


