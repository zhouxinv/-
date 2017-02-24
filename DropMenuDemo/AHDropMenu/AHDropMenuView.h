//
//  AHDropMenuView.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, AHDropMenuViewStyle) {
    AHDropMenuViewStyleSingleSelect = 0,//单选
    AHDropMenuViewStyleMutiSelect,//多选
    AHDropMenuViewStyleSingleSelectPain,//不带蒙层单选样式
    AHDropMenuViewStyleMutiSelectPain,//不带蒙层多选样式    
};
typedef NS_ENUM(NSUInteger, AHDropMenuViewAnimationType) {
    AHDropMenuViewAnimationTypeDrop,//从上向下的动画
    AHDropMenuViewAnimationTypeSheet,//从下向上的动画
};


@protocol AHDropMenuViewDelegate;

@class AHDropMenuItem;

@interface AHDropMenuView : UIView

@property(nonatomic, weak) id<AHDropMenuViewDelegate> delegate;
///是否为展开状态(只读)
@property(nonatomic, assign, readonly) BOOL isShow;
///是否为多选
@property (nonatomic,assign,readonly) BOOL isMultiselect;
///展开类型
@property(nonatomic, assign, readonly) AHDropMenuViewStyle style;
///动画类型
@property (nonatomic, assign) AHDropMenuViewAnimationType animationType;
//点击后是否自动收回
@property(nonatomic, assign) BOOL isAutoHidden;
///初始化
- (instancetype)init;



/**
 在 window 上创建 menu

 @param window window层
 @param delegate 代理对象
 @return AHDropMenuView
 */
- (instancetype)initWithWindow:(UIWindow *)window withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style;


/**
 创建一个在导航栏下的下拉菜单

 @param navigationController 导航控制器
 */
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style;


/**
 在 View Controller 中创建 menu

 @param viewController menu 所在 View Controller
 @return AHDropMenuView
 */
- (instancetype)initWithViewController:(UIViewController *)viewController withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style;


/**
 在 View 中创建 menu

 @param view menu 所在的 View
 @return AHDropMenuView
 */
- (instancetype)initWithView:(UIView *)view withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style;

/** 下拉菜单展开 **/
- (void)showAnimated:(BOOL)animated;
- (void)showAnimated:(BOOL)animated showCompletionHandler:(void(^)())showCompletionHandler;

/**
 下拉菜单展开

 @param animated 展开是否有动画
 @param showCompletionHandler 展示动画完成后的操作
 @param hideWhenHandler 隐藏动画开始的操作
 */
- (void)showAnimated:(BOOL)animated showCompletionHandler:(void(^)())showCompletionHandler hideWhenHandler:(void(^)())hideWhenHandler;
/** 下拉菜单收起 **/
- (void)hideAnimated:(BOOL)animated;

/**
 设置下拉菜单的最大高度

 @param maxRowNum 最大高度有几行
 */
- (void)maxTableViewMaxRowNum:(NSInteger)maxRowNum;

@end


@protocol AHDropMenuViewDelegate <NSObject>

- (NSArray<AHDropMenuItem *> *)dataSourceForDropMenu;

@optional

/*
 *  single select
 */
- (void)dropMenuView:(AHDropMenuView *)dropMenuView didSelectAtIndex:(NSIndexPath *)indexPath;
/*
 *  multi select
 */
- (void)dropMenuView:(AHDropMenuView *)dropMenuView didMultiSelectIndexPaths:(NSIndexSet *)selIndexSet;
/*
 * headerView
 */
- (UIView *)dropMenuHeaderView:(AHDropMenuView *)dropMenuView;
/*
 * footerView
 */
- (UIView *)dropMenuFooterView:(AHDropMenuView *)dropMenuView;
/*
 * headerView String
 */
- ( NSString *)dropMenuHeaderViewString:(AHDropMenuView *)dropMenuView;
/*
 * headerViewHeight 
 * 设置headView 不设置headView的高度，即使view有高度，仍然不能显示，必须设置headView的高度。
 */
- (CGFloat)dropMenuHeaderViewHeight;
/*
 * footerViewHeight
 * 设置footerView 不设置footerView的高度，即使view有高度，仍然不能显示，必须设置footerView的高度。
 */
- (CGFloat)dropMenuFooterViewHeight;

/*
 * DropMenuViewCell Height
 */

- (CGFloat)dropMenuView:(AHDropMenuView *)dropMenuView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
