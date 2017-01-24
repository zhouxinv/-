//
//  AHDropMenuView.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AHDropMenuViewDelegate;
@class AHDropMenuViewModel;
@interface AHDropMenuView : UIView

@property(nonatomic, weak) id<AHDropMenuViewDelegate> delegate;
//是否为展开状态
@property(nonatomic, assign) BOOL isShow;
//是否为多选
@property (nonatomic,assign) BOOL isMultiselect;
//初始化
- (instancetype)init;

/**
 设置数据源

 @param dataSource cell数据源  单独传入数据源可以在同一个VC中只创建一个MenuView传入不同数据源
 */
- (void)showWithDataSource:(NSArray <AHDropMenuViewModel *> *)dataSource;

/**
 创建一个在导航栏下的下拉菜单

 @param navigationController 导航控制器
 */
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

/** 下拉菜单展开 **/
- (void)show;
/** 下拉菜单收起 **/
- (void)hide;

/**
 设置下拉菜单的最大高度

 @param maxRowNum 最大高度有几行
 */
- (void)maxTableViewMaxRowNum:(NSInteger)maxRowNum;


/** 设置cell的字体大小 **/
- (void)setTitleFontSize:(CGFloat)fontSize;
/** 设置cell的字体颜色 **/
- (void)setTitleColor:(UIColor *)titleColor;


@end


@protocol AHDropMenuViewDelegate <NSObject>

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
- (CGFloat)heightForHeaderView;

@end
