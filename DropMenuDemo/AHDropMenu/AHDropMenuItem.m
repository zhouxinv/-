//
//  AHDropMenuViewModel.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/22.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "AHDropMenuItem.h"

#pragma mark - 默认 style 值
//#define kAHDropMenuTitleFont [UIFont 

@implementation AHDropMenuItem

- (instancetype)init {
    NSAssert(nil, @"使用 - (instancetype)initWithTitle:(NSString *)title iconImage:(UIImage *)iconImage");
    return nil;
}

- (instancetype)initWithTitle:(NSString *)title {
    
    if (self = [self initWithTitle:title icon:nil]) {
        
    }
    return  self;
}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon{
    if (self = [self initWithTitle:title icon:icon iconHighlighted:nil]) {
        
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon
              iconHighlighted:(UIImage *)iconHighlighted {
    self = [super init];
    if (self) {
        _title = title;
        _icon = icon;
        
        if (_iconHighlighted) {
           _iconHighlighted = iconHighlighted;
        } else {
            _iconHighlighted = _icon;
        }
        
        
        [self initialParamsValue];
    }
    return self;
}


- (void)initialParamsValue {
    _backgroundColor = [UIColor whiteColor];
    _backgroundColorHighlighted = [UIColor whiteColor];
    _checkImage = nil;
    _checkImageSelected = [UIImage imageNamed:@"check"];
    _titleFont = [UIFont systemFontOfSize:14];
    _titleFontHighlighted = [UIFont systemFontOfSize:14];
    _titleColor = [UIColor blackColor];
    _titleColorHighlighted = [UIColor blackColor];
    
    
    _titleLayout = AHDropMenuItemTitleLayoutCenter;
}

- (void)setItemStyleWithbackgroundColor:(UIColor *)backgroundColor
             backgroundColorHighlighted:(UIColor *)backgroundColorHighlighted
                             checkImage:(UIImage *)checkImage
                     checkImageSelected:(UIImage *)checkImageSelected
                             titleColor:(UIColor *)titleColor
                  titleColorHighlighted:(UIColor *)titleColorHighlighted
                              titleFont:(UIFont *)titleFont
                   titleFontHighlighted:(UIFont *)titleFontHighlighted {
    
    _backgroundColor = backgroundColor;
    _backgroundColorHighlighted = backgroundColorHighlighted;
    _checkImage = checkImage;
    _checkImageSelected = checkImageSelected;
    _titleColor = titleColor;
    _titleColorHighlighted = titleColorHighlighted;
    _titleFont = titleFont;
    _titleFontHighlighted = titleFontHighlighted;
    
}

- (void)setItemStyleWithTitleLayout:(AHDropMenuItemTitleLayout)titleLayout {
    _titleLayout = titleLayout;
}



@end
