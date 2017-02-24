//
//  AHDropMenuViewCell.h
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AHDropMenuItem;
@protocol AHDropMenuViewCellDelegate;
@interface AHDropMenuViewCell : UITableViewCell

@property(nonatomic, weak) id<AHDropMenuViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
/** 为cell赋值 **/
- (void)makeCellWithModel:(AHDropMenuItem *)mItem indexPath:(NSIndexPath *)indexPath;

@end

@protocol AHDropMenuViewCellDelegate <NSObject>


@end

