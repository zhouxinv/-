//
//  AHDropMenuView.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AHDropMenuViewDelegate;

@class AHDropMenuItem;

@interface AHDropMenuView : UIView

@property(nonatomic, weak) id<AHDropMenuViewDelegate> delegate;
///是否为展开状态
@property(nonatomic, assign) BOOL isShow;
///是否为多选
@property (nonatomic,assign) BOOL isMultiselect;
///初始化
- (instancetype)init;

/**
 设置数据源

 @param dataSource cell数据源  单独传入数据源可以在同一个VC中只创建一个MenuView传入不同数据源

 */
//- (void)showWithDataSource:(NSArray <AHDropMenuItem *> *)dataSource;

/**
 创建一个在导航栏下的下拉菜单

 @param navigationController 导航控制器
 */
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController withDelegate:(id<AHDropMenuViewDelegate>)delegate;


/**
 在 View Controller 中创建 menu

 @param viewController menu 所在 View Controller
 @return AHDropMenuView
 */
- (instancetype)initWithViewController:(UIViewController *)viewController withDelegate:(id<AHDropMenuViewDelegate>)delegate;


/**
 在 View 中创建 menu

 @param view menu 所在的 View
 @return AHDropMenuView
 */
- (instancetype)initWithView:(UIView *)view withDelegate:(id<AHDropMenuViewDelegate>)delegate;

/** 下拉菜单展开 **/
- (void)show;
/** 下拉菜单收起 **/
- (void)hide;

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
 * headerViewHeight 
 * 设置headView 不设置headView的高度，即使view有高度，仍然不能显示，必须设置headView的高度。
 */
- (CGFloat)dropMenuHeaderViewHeight;

@end
