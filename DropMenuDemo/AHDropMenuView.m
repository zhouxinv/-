//
//  AHDropMenuView.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "AHDropMenuView.h"
#import "AHDropMenuViewCell.h"
#import "AHDropMenuItem.h"
#import "Masonry.h"

static NSString *reuserIdentify = @"AHDropMenuViewCell";
//默认cell高度
static const CGFloat defaultCellRowHeight = 44;
//tableView 展示最多行数
static const NSInteger _maxRowNum = 8;

//tableView 最大高度 = defaultCellRowHeight * _maxRowNum + currentHeadViewHeight;
static const CGFloat _maxTableViewHeight = 412;
//tableView 当前高度
CGFloat _currentTableViewHeight;
//tableView headView 当前高度
CGFloat _currentHeadViewHeight;


@interface AHDropMenuView ()<UITableViewDelegate, UITableViewDataSource>
//数据源数组
@property(nonatomic, strong) NSArray<AHDropMenuItem *>  *arrDataSource;

@property (nonatomic, strong) UIView *vSuper;
//
@property(nonatomic, strong) UITableView *tableView;
// headView
@property(nonatomic, strong) UIView *headerView;
//阴影遮盖View
@property(nonatomic, strong) UIView *blurredView;
//当前被选中的index的集合
@property(nonatomic, strong) NSMutableIndexSet *indexSet;
//上一次选择的model
@property(nonatomic, strong) AHDropMenuItem *lastModel;

@end

@implementation AHDropMenuView

- (instancetype)init {
    NSAssert(nil, @"请使用其他 init 方法");
    return self;
}


- (instancetype)initWithNavigationController:(UINavigationController *)navigationController withDelegate:(id<AHDropMenuViewDelegate>)delegate {
//    CGFloat _navHeight = 64;
    UIViewController *vcBase = navigationController.viewControllers.lastObject;
//    CGRect frame = CGRectMake(0, _navHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _navHeight);
    self = [self initWithViewController:vcBase withDelegate:delegate];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController withDelegate:(id<AHDropMenuViewDelegate>)delegate {
    self = [self initWithView:viewController.view withDelegate:delegate];

    if (self) {
        
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view withDelegate:(id<AHDropMenuViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        if (view) {
            _vSuper = view; //用屏幕高度也可以吧 即使是按钮也是屏幕的高度啊?
            [view addSubview:self];
            self.backgroundColor = [UIColor clearColor];
            [self mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(64);
                make.leading.trailing.mas_equalTo(0);
                make.height.mas_equalTo(_vSuper.frame.size.height);
            }];
            
        }
        
        [self initialValue];
        
        self.hidden = YES;
        [self createSubViewsAndConstraints];
//        为view添加key 防止约束冲突
//        MASAttachKeys(self, _tableView, _headerView, _blurredView);
    }
    return self;
}

- (void)initialValue {
    //初始化数据放在一起
    if (_delegate && [_delegate respondsToSelector:@selector(dataSourceForDropMenu)]) {
        _arrDataSource = [_delegate dataSourceForDropMenu];
    }
    _indexSet = [[NSMutableIndexSet alloc] init];
    //若用户没有设置tableView的高度 默认最多展示8条。
    NSInteger maxRowNum = _arrDataSource.count > _maxRowNum ? _maxRowNum : _arrDataSource.count;
    _currentTableViewHeight = defaultCellRowHeight * maxRowNum;
    _isShow = NO;
}

- (void)createSubViewsAndConstraints {

    _blurredView = [[UIView alloc]init];
    _blurredView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_blurredView];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [_blurredView addGestureRecognizer:bgTap];

    
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
//    _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
//    ------------------------------  孙老师  -----------------------------------
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    [_blurredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(_tableView.mas_bottom);
        make.height.mas_equalTo(_vSuper.mas_height);
    }];

    
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(dropMenuHeaderView:)]) {
        UIView *vHeaderChild = [_delegate dropMenuHeaderView:self];
        
        CGFloat headerHeight = 0.0f;
        
        if (vHeaderChild) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(dropMenuHeaderViewHeight)]) {
                headerHeight = [_delegate dropMenuHeaderViewHeight];
                //tableView的高度最多为60
                
                headerHeight = headerHeight > 60 ? 60 : headerHeight;
                _currentHeadViewHeight = headerHeight;
                _currentTableViewHeight += headerHeight;
            }
            
            _headerView = [[UIView alloc] init];
            [_headerView addSubview:vHeaderChild];
            _tableView.tableHeaderView = _headerView;
            [_headerView mas_makeConstraints:^(MASConstraintMaker *make){
                make.leading.top.mas_equalTo(0);
                make.width.equalTo(_tableView.mas_width);
                make.height.mas_equalTo(headerHeight);
            }];
            
            [_tableView layoutIfNeeded];
            
            vHeaderChild.center = _headerView.center;
        }
    }
   
}

/** 点击阴影遮罩 */
-(void)bgTappedAction:(UITapGestureRecognizer *)tap {
    [self hide];
}
#pragma mark - Public
- (void)maxTableViewMaxRowNum:(NSInteger)maxRowNum {
    
    maxRowNum = maxRowNum > _maxRowNum ? _maxRowNum : maxRowNum;
    _currentTableViewHeight = maxRowNum * defaultCellRowHeight + _currentHeadViewHeight;
    [_tableView reloadData];
}

- (void)show {
   
    _isShow = YES;
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];

//    [self mas_remakeConstraints:^(MASConstraintMaker *make){
//                make.top.mas_equalTo(64);
//                make.leading.trailing.mas_equalTo(0);
//                make.height.mas_equalTo(_vSuper.mas_height);
//    }];
//    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.leading.trailing.mas_equalTo(0);
//        make.height.mas_equalTo(0);
//    }];
//    [_blurredView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.mas_equalTo(0);
//        make.top.equalTo(_tableView.mas_bottom);
//         make.height.mas_equalTo(_vSuper.mas_height).with.offset(-64);
////        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height - _currentTableViewHeight);
//    }];
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(_currentTableViewHeight);
        }];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            
        }];
    }];
  
}

- (void)hide {
    _isShow = NO;

    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        
        self.hidden = YES;
        self.alpha = 1;

    }];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //不论是单选还是多选都需要为model赋值
    AHDropMenuItem *model = _arrDataSource[indexPath.row];
    if (_isMultiselect) {
        model.selected = !model.selected;
    } else {
        _lastModel.selected = NO;
        model.selected = YES;
        _lastModel = model;
    }
    
    if (_isMultiselect) {
        
        if ([_indexSet containsIndex:indexPath.row]) {
            [_indexSet removeIndex:indexPath.row];
        } else {
            [_indexSet addIndex:indexPath.row];
        }
        
        if ([_delegate respondsToSelector:@selector(dropMenuView:didMultiSelectIndexPaths:)]) {
            [_delegate dropMenuView:self didMultiSelectIndexPaths:_indexSet];
        }
    } else {
       
        [_indexSet removeAllIndexes];
        [_indexSet addIndex:indexPath.row];
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
    NSInteger count = _arrDataSource.count? _arrDataSource.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AHDropMenuViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuserIdentify];
    
    if (cell == nil) {
        cell = [[AHDropMenuViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentify];
    }
    [cell makeCellWithModel:_arrDataSource[indexPath.row] indexPath:indexPath];
    return cell;
}



@end
