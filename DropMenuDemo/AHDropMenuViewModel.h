//
//  AHDropMenuViewModel.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/22.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AHDropMenuViewModel : NSObject
///title 可选项标题
@property(nonatomic, strong) NSString *title;
///iconName 可选项头像图片名
@property(nonatomic, strong) UIImage *icon;
///checkImage 选中的图片显示
@property(nonatomic, strong) UIImage *checkImage;
///selected 当前选项是否被选择
@property(nonatomic, assign) BOOL selected;

- (instancetype)initWithIconImage:(UIImage *)iconImage title:(NSString *)title;
- (instancetype)initWithIconImage:(UIImage *)iconImage title:(NSString *)title checkImage:(UIImage *)checkImage;

@end
