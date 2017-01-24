//
//  AHDropMenuViewModel.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/22.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "AHDropMenuViewModel.h"

@implementation AHDropMenuViewModel
- (instancetype)initWithIconImage:(UIImage *)iconImage title:(NSString *)title {
    if (self = [self initWithIconImage:iconImage title:title checkImage:nil]) {
        
    }
    return self;
}

- (instancetype)initWithIconImage:(UIImage *)iconImage title:(NSString *)title checkImage:(UIImage *)checkImage {
    if (self = [super init]) {
        _icon = iconImage;
        _title = title;
        _checkImage = checkImage;
    }
    return self;

}



@end
