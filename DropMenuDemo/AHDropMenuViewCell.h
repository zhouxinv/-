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

- (void)makeCellWithModel:(AHDropMenuViewModel *)mItem indexPath:(NSIndexPath *)indexPath;

- (void)setTitleFontSize:(CGFloat)fontSize;
- (void)setTitleColor:(UIColor *)titleColor;

@end

@protocol AHDropMenuViewCellDelegate <NSObject>

- (void)configCell:(CGFloat)rowHeight
   BackgroundColor:(UIColor *)backgroundColor
              Font:(UIFont *)font
       iconImage:(UIImage *)iconImage
        checkImage:(UIImage *)checkImage;

@end


