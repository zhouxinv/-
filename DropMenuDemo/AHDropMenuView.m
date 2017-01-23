//
//  AHDropMenuView.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "AHDropMenuView.h"
#import "AHDropMenuViewCell.h"
#import "AHDropMenuViewModel.h"
#import "Masonry.h"


static NSString *reuserIdentify = @"AHDropMenuViewCell";
//默认cell高度
static CGFloat defaultCellRowHeight = 44;
//tableView的最大高度
CGFloat _maxTableViewHeight;
CGFloat _navHeight = 64;



@interface AHDropMenuView ()<UITableViewDelegate, UITableViewDataSource>
//数据源数组 -- 标题
@property(nonatomic, strong) NSMutableArray *dataSoureArr;
// icon 数组 -- 图片
@property(nonatomic, strong) NSMutableArray *dataImageStrArr;
//
@property(nonatomic, strong) UITableView *tableView;
// headView
@property(nonatomic, strong) UIView *headerView;
//阴影遮盖View
@property(nonatomic, strong) UIView *blurredView;
//当前被选中的index的集合
@property(nonatomic, strong) NSMutableIndexSet *mutableSet;
//上一次选择的model
@property(nonatomic, strong) AHDropMenuViewModel *lastModel;

//设置字体颜色
@property(nonatomic, assign) CGFloat fontSize;
@property(nonatomic, strong) UIColor *titleColor;

@end

@implementation AHDropMenuView

- (instancetype)init {
    if (self = [self initWithUIView:nil frame:CGRectZero]) {
        
    }
    return self;

}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {

    UIViewController *vcBase = navigationController.viewControllers.lastObject;
    CGRect frame = CGRectMake(0, _navHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _navHeight);
    if (self = [self initWithUIView:vcBase.view frame:frame]) {
    }
    
    return self;
}

- (instancetype)initWithUIView:(UIView *)view frame:(CGRect)frame {
//    self = [super initWithFrame:CGRectMake(0, 450 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height )];
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        [self createSubViewsAndConstraints];
        [self initialValue];
        if (view ) {
            [view addSubview:self];
        }
    }
    return self;
}

- (void)createSubViewsAndConstraints {
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor grayColor];
    [self addSubview:_headerView];
    
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    _blurredView = [[UIView alloc]init];
    _blurredView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_blurredView];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [_blurredView addGestureRecognizer:bgTap];

    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0);
        
    }];
  
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(_headerView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [_blurredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(_tableView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
   
    
}

- (void)initialValue {
    //若用户没有设置tableView的高度 默认最多展示8条。
    _maxTableViewHeight = defaultCellRowHeight * 8;
    _isShow = NO;
    _dataSoureArr = [[NSMutableArray alloc]init];
    _dataImageStrArr = [[NSMutableArray alloc]init];
    _mutableSet = [[NSMutableIndexSet alloc]init];
}

/** 点击阴影遮罩 */
-(void)bgTappedAction:(UITapGestureRecognizer *)tap {
    [self hide];
}
#pragma mark - Public
- (void)maxTableViewMaxRowNum:(NSInteger)maxRowNum {
    _maxTableViewHeight = maxRowNum * defaultCellRowHeight;
    [_tableView reloadData];
}

- (void)setTitleFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
}

- (void)showWithDataSource:(NSArray <NSString *> *)dataSource {
    
    //判断数据源是否已经有数据
    if (_dataSoureArr.count > 0) {
        //遍历传入的数组
        [dataSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj;
            //判断数据源是否小于当前需要取值的index 小于的时候要创建新model
            if (_dataSoureArr.count <= idx) {
                AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]init];
                 model.title = title;
                [_dataSoureArr addObject:model];
                
            }
            //不小于的时候可以直接从数据源里面取出来model进行赋值
            else {
                AHDropMenuViewModel *model = _dataSoureArr[idx];
                model.title = title;
            }
            
        }];
        
    }
    //数据源中没有数据的时候 创建添加model
    else {
        [dataSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj;
            AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]init];
            model.title = title;
            [_dataSoureArr addObject:model];
        }];
    }
}

- (void)showWithCelliconsArray:(NSArray <UIImage *> *)imageStrArray {
    //判断数据源是否已经有数据
    if (_dataSoureArr.count > 0) {
        //遍历传入的数组
        [imageStrArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *img = obj;
            //判断数据源是否小于当前需要取值的index 小于的时候要创建新model
            if (_dataSoureArr.count <= idx) {
                AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]init];
                model.icon = img;
                [_dataSoureArr addObject:model];
                
            }
            //不小于的时候可以直接从数据源里面取出来model进行赋值
            else {
                AHDropMenuViewModel *model = _dataSoureArr[idx];
                model.icon = img;
            }
        }];
    }
    //数据源中没有数据的时候 创建添加model
    else {
        [imageStrArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *img = obj;
            AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]init];
            model.icon = img;
            [_dataSoureArr addObject:model];
        }];
    }
}

- (void)show {
    self.hidden = NO;
    _isShow = YES;
    if ([_delegate respondsToSelector:@selector(dropMenuHeaderView:)]) {
        UIView *vChild = [_delegate dropMenuHeaderView:self];
        [_headerView addSubview:vChild];
        
    }
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGFloat currentHeaderViewHeight = 0;
        if ([_delegate respondsToSelector:@selector(heightForHeaderView)]) {
            currentHeaderViewHeight = [_delegate heightForHeaderView];
        }
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(currentHeaderViewHeight);
        }];
        
        CGFloat currentTableViewHeight = defaultCellRowHeight * _dataSoureArr.count;
        if(currentTableViewHeight > _maxTableViewHeight){
            currentTableViewHeight = _maxTableViewHeight;
            
        }
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(currentTableViewHeight);
        }];
        
        [_blurredView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height - currentTableViewHeight - currentHeaderViewHeight);
        }];
        
    }completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)hide {
    _isShow = NO;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
       
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [_blurredView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //不论是单选还是多选都需要为model赋值
    AHDropMenuViewModel *model = _dataSoureArr[indexPath.row];
    if (_isMultiselect) {
        model.selected = !model.selected;
    } else {
        _lastModel.selected = NO;
        model.selected = YES;
        _lastModel = model;
    }
    
    if (_isMultiselect) {
        
        if ([_mutableSet containsIndex:indexPath.row]) {
            [_mutableSet removeIndex:indexPath.row];
        } else {
            [_mutableSet addIndex:indexPath.row];
        }
        
        if ([_delegate respondsToSelector:@selector(dropMenuView:didMultiSelectIndexPaths:)]) {
            [_delegate dropMenuView:self didMultiSelectIndexPaths:_mutableSet];
        }
    } else {
       
        [_mutableSet removeAllIndexes];
        [_mutableSet addIndex:indexPath.row];
        if ([_delegate respondsToSelector:@selector(dropMenuView:didSelectAtIndex:)]) {
            [_delegate dropMenuView:self didSelectAtIndex:indexPath];
        }
        //被点击之后收起tableView
        [self hide];
    }
    
    [_tableView reloadData];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = _dataSoureArr.count? _dataSoureArr.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AHDropMenuViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuserIdentify];
    
    if (cell == nil) {
        cell = [[AHDropMenuViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentify];
        if (_fontSize > 0) {
            [cell setTitleFontSize:_fontSize];
        }
        
        if (_titleColor != nil) {
            [cell setTitleColor:_titleColor];
        }
    }
    [cell makeCellWithModel:_dataSoureArr[indexPath.row] indexPath:indexPath];
    return cell;
}



@end
