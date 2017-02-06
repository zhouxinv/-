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


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor) {
        _backgroundColor = backgroundColor;
    }
}

- (void)setBackgroundColorHighlighted:(UIColor *)backgroundColorHighlighted {
    if (backgroundColorHighlighted) {
        _backgroundColorHighlighted = backgroundColorHighlighted;
    }
}

- (void)setCheckImage:(UIImage *)checkImage {
    if (checkImage) {
        _checkImage = checkImage;
    }
}

- (void)setCheckImageSelected:(UIImage *)checkImageSelected {
    if (checkImageSelected) {
        _checkImageSelected = checkImageSelected;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (titleFont) {
        _titleFont = titleFont;
    }
}
- (void)setTitleFontHighlighted:(UIFont *)titleFontHighlighted {
    if (titleFontHighlighted) {
        _titleFontHighlighted = titleFontHighlighted;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (titleColor) {
        _titleColor = titleColor;
    }
}

- (void)setTitleColorHighlighted:(UIColor *)titleColorHighlighted {
    if (titleColorHighlighted) {
        _titleColorHighlighted = titleColorHighlighted;
    }
}


@end
