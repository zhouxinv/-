//
//  AHDropMenuViewCell.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "AHDropMenuViewCell.h"
#import "AHDropMenuItem.h"
#import "Masonry.h"
#import "ACDefine.h"


@interface AHDropMenuViewCell ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIImageView *checkImg;
@property(nonatomic, strong) UIView *lineView;

@end

@implementation AHDropMenuViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViewsAndConstrains];
    }
    
    return self;
}


- (void)makeCellWithModel:(AHDropMenuItem *)mItem indexPath:(NSIndexPath *)indexPath {
    //为cell 赋值
    _title.text = mItem.title;
    //为cell 设置样式
    //状态为被选中时
    if (mItem.selected) {
        _imgView.image = mItem.iconHighlighted;
        self.backgroundColor = mItem.backgroundColorHighlighted;
        _checkImg.image = mItem.checkImageSelected;
        _title.font = mItem.titleFontHighlighted;
        _title.textColor = mItem.titleColorHighlighted;
        
    } else {
        _imgView.image = mItem.icon;
        self.backgroundColor = mItem.backgroundColor;
        _checkImg.image = mItem.checkImage;
        _title.font = mItem.titleFont;
        _title.textColor = mItem.titleColor;
    }
    
    
    switch (mItem.titleLayout) {
        case AHDropMenuItemTitleLayoutLeft:
            [self updateTitleLeft];
            break;
        case AHDropMenuItemTitleLayoutCenter:
            [self updateTitleCenter];
            break;
        default:
            [self updateTitleCenter];
            break;
    }
    
}

- (void)updateTitleLeft {
    [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(WIDTH_PT(15));
        make.width.mas_lessThanOrEqualTo(WIDTH_PT(120));
        make.centerY.equalTo(self);
    }];
}

- (void)updateTitleCenter {
    [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(WIDTH_PT(120));
    }];
}




- (void)createSubViewsAndConstrains {
    _title = [[UILabel alloc]init];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14];
    _title.textColor = [UIColor blackColor];
    [self.contentView addSubview:_title];
    _imgView = [[UIImageView alloc]init];
    _imgView.layer.cornerRadius = 15;
    _imgView.clipsToBounds = YES;
    [self.contentView addSubview:_imgView];
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = kACColorLine;
    [self.contentView addSubview:_lineView];
    
    _checkImg = [[UIImageView alloc]init];
//    _checkImg.contentMode = UIViewContentModeCenter;
    _checkImg.clipsToBounds = YES;
    [self.contentView addSubview:_checkImg];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(WIDTH_PT(120));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(WIDTH_PT(15));
        make.width.height.mas_equalTo(WIDTH_PT(30));
        make.centerY.equalTo(self.title);
        
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView);
    }];
    [_checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(WIDTH_PT(-30));
        make.width.height.mas_equalTo(HEIGHT_PT(20));
        make.centerY.equalTo(self.title);
    }];
}



@end
