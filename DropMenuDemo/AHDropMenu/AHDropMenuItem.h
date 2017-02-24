//
//  AHDropMenuViewModel.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/22.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    /** 标题居左 */
    AHDropMenuItemTitleLayoutLeft,
    /** 标题居中 */
    AHDropMenuItemTitleLayoutCenter,
    
} AHDropMenuItemTitleLayout;

@interface AHDropMenuItem : NSObject
#pragma mark - 基础项
/** 可选项标题 */
@property(nonatomic, strong) NSString *title;
/** 可选项头像图片名 */
@property(nonatomic, strong) UIImage *icon;
/** 可选项头像图片名 */
@property(nonatomic, strong) UIImage *iconHighlighted;
/** 当前选项选中状态 */
@property(nonatomic, assign) BOOL selected;

#pragma mark - 样式
/** 背景 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 高亮背景 */
@property (nonatomic, strong) UIColor *backgroundColorHighlighted;
/** 选中打勾-默认 */
@property(nonatomic, strong) UIImage *checkImage;
///选中打勾-已选中
@property(nonatomic, strong) UIImage *checkImageSelected;
/** 标题字号 */
@property (nonatomic, strong) UIFont *titleFont;
/** 标题高亮字号 */
@property (nonatomic, strong) UIFont *titleFontHighlighted;
/** 标题文字默认颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 标题文字高亮颜色 */
@property (nonatomic, strong) UIColor *titleColorHighlighted;

#pragma mark - UI布局样式
/** 标题靠左 */
@property(nonatomic, assign) AHDropMenuItemTitleLayout titleLayout;

#pragma mark - initializer
- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon;

- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon
              iconHighlighted:(UIImage *)iconHighlighted;

#pragma mark - 样式设置
- (void)setItemStyleWithbackgroundColor:(UIColor *)backgroundColor
             backgroundColorHighlighted:(UIColor *)backgroundColorHighlighted
                             checkImage:(UIImage *)checkImage
                     checkImageSelected:(UIImage *)checkImageSelected
                             titleColor:(UIColor *)titleColor
                  titleColorHighlighted:(UIColor *)titleColorHighlighted
                              titleFont:(UIFont *)titleFont
                   titleFontHighlighted:(UIFont *)titleFontHighlighted;

- (void)setItemStyleWithTitleLayout:(AHDropMenuItemTitleLayout)titleLayout;

@end
