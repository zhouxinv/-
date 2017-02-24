//
//  ACDefine.h
//  AutoTraderCloud
//
//  Created by zhangMo on 2017/2/15.
//  Copyright © 2017年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - APP KEYs

#define kAPP_KEY    @"atc.iphone"

// 渠道
#if DEBUG
// 默认debug运行程序，默认取到 beta
#define kNormalChannelStr @"beta"
#else
// beta(测试用) | [线上渠道: ]
#define kNormalChannelStr [ACDefine currentChannel]
#endif


#pragma mark - ON/OFF

// 线下环境/线上环境 0:线下 1:线上
#define HostStatus 0

// 开启显示环境
#define OnTestStatus 0

// 是否在 Debug 模式下开启 Fabric 0 关闭 1 开启 (默认0关闭)
#define Debug_Fabric_ON 0

// 开启https模式：0否，1是，正常应该是1
#define kOpenSSLPinningMode 1

#if DEBUG
#define kFabric_Should_Start Debug_Fabric_ON
#else
#define kFabric_Should_Start (!IsBetaVersion || COMPARE_VERSION_GREATER_THAN_OR_EQUAL_TO(APP_BUILD, @"80"))
#endif

#pragma mark - UI Style

/** 字体 */
#define kFontSize(size)              [UIFont systemFontOfSize:(size)]

/** 颜色 */
#define kACColorClear                [UIColor clearColor]
#define kACColorWhite                [UIColor whiteColor]
#define kACColorBlack                [UIColor blackColor]

#define kACColorRGBA(r, g, b, a)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kACColorRGB(r, g, b)         kACColorRGBA((r), (g), (b), 1.0)
#define kACColorRandom               kACColorRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define kACColorNavigation           kACColorRGBA((248), (248), (248), 1.0)
#define kACColorBackground           kACColorRGBA((242), (243), (246), 1.0)
#define kACColorItemSelect           kACColorRGBA((242), (242), (242), 1.0)
#define kACColorGray1                kACColorRGBA((34), (44), (56), 1.0)
#define kACColorGray2                kACColorRGBA((92), (99), (108), 1.0)
#define kACColorGray3                kACColorRGBA((197), (200), (207), 1.0)
#define kACColorGray4                kACColorRGBA((233), (233), (233), 1.0)
#define kACColorBlue                 kACColorRGBA((85), (172), (238), 1.0)
#define kACColorBlue1                kACColorRGBA((76), (154), (214), 1.0)
#define kACColorLine                 kACColorRGBA((231), (231), (231), 1.0)
#define kACColorRed                  kACColorRGBA((248), (73), (73), 1.0)
#define kACColorRed1                  kACColorRGBA((223), (66), (66), 1.0)
#define kACColorOrange               kACColorRGBA((255), (102), (51), 1.0)
#define kACColorYellow               kACColorRGBA((255), (253), (238), 1.0)

#define kToastErrorServer404 @"您的页面走丢了"
#define kToastErrotConnection @"抱歉，出问题了，我们正在修复~"
#define kToastLoading @"正在为您努力加载中~"

#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height

/**
 *  计算屏幕宽度比例
 *
 *  @param pt 设计图上的尺寸
 *
 *  @return 比例 * 设计图上的尺寸
 */
#define WIDTH_PT(pt) ceil([UIScreen mainScreen].bounds.size.width / 375 * (pt))

/**
 *  计算屏幕高度比例
 *
 *  @param pt 设计图上的尺寸
 *
 *  @return 比例 * 设计图上的尺寸
 */
#define HEIGHT_PT(pt) ceil([UIScreen mainScreen].bounds.size.height / 667 * (pt))


//退出登录通知
#define kNotificationLogout          @"NotificationLogout"


@interface ACDefine : NSObject



@end
