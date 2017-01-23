//
//  AHDropMenuViewCell.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "AHDropMenuViewCell.h"
#import "AHDropMenuViewModel.h"
#import "Masonry.h"

@interface AHDropMenuViewCell ()
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIImageView *checkImg;
@property(nonatomic, strong) UIView *lineView;

@end

@implementation AHDropMenuViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViewsAndConstrains];
    }
    
    return self;
}

- (void)createSubViewsAndConstrains{
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
    _lineView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_lineView];
    
    _checkImg = [[UIImageView alloc]init];
    
    [self.contentView addSubview:_checkImg];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_lessThanOrEqualTo(120);
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.title);
        
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self);
    }];
    [_checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-30);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.title);
    }];
}

- (void)makeCellWithModel:(AHDropMenuViewModel *)mItem indexPath:(NSIndexPath *)indexPath {
    _title.text = mItem.title;
    
    _imgView.image = mItem.icon;
    
    if (mItem.selected) {
        [_checkImg setImage:[UIImage imageNamed:@"check"]];
    } else {
        [_checkImg setImage:[UIImage imageNamed:@"check_no"]];
    }
}

- (void)setTitleFontSize:(CGFloat)fontSize{
    _title.font = [UIFont systemFontOfSize:fontSize];
   
}
- (void)setTitleColor:(UIColor *)titleColor{
    _title.textColor = titleColor;
}



@end
