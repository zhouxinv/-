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
#import "ACDefine.h"
#import "UIImage+Size.h"


static NSString *reuserIdentify = @"AHDropMenuViewCell";
//tableView 展示最多行数
static  NSInteger _maxRowNum = 8;
//tableView 最大高度 = _defaultCellRowHeight * _maxRowNum + currentHeadViewHeight;
//static const CGFloat _maxTableViewHeight = 412;

typedef void(^completionHandler)();

@interface AHDropMenuView ()<UITableViewDelegate, UITableViewDataSource>
//数据源数组
@property(nonatomic, strong) NSArray<AHDropMenuItem *>  *arrDataSource;
//父类View
@property (nonatomic, strong) UIView *vSuper;
//展示tableview
@property(nonatomic, strong) UITableView *tableView;
// headView
@property(nonatomic, strong) UIView *headerView;
// headView
@property(nonatomic, strong) UIView *footerView;
//阴影遮盖View
@property(nonatomic, strong) UIView *blurredView;

//当前被选中的index的集合
@property(nonatomic, strong) NSMutableIndexSet *indexSet;
//上一次选择的model
@property(nonatomic, strong) AHDropMenuItem *lastModel;
@property(nonatomic, assign) NSInteger navHeight;
//tableView 当前高度
@property(nonatomic, assign) CGFloat currentTableViewHeight;
//tableView headView 当前高度
@property(nonatomic, assign) CGFloat currentHeadViewHeight;
//tableView footerView 当前高度
@property(nonatomic, assign) CGFloat currentfooterViewHeight;
//默认cell高度
@property(nonatomic, assign) CGFloat defaultCellRowHeight;
///是否有蒙层遮挡
@property(nonatomic, assign) BOOL isHaveBlurredView;
///是否为多选
@property (nonatomic,assign,readwrite) BOOL isMultiselect;
///隐藏后handle
@property (nonatomic, copy) completionHandler hideWhenHandler;

@end

@implementation AHDropMenuView

- (instancetype)init {
    NSAssert(nil, @"请使用其他 init 方法");
    return self;
}


- (instancetype)initWithWindow:(UIWindow *)window withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style {
    
    if (self = [super init]) {
        if (window) {
            _navHeight = 64;
            self = [self initViewWithSuperView:window withDelegate:delegate style:style];
        }
        
    }
    return self;
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style {
    
    if (self = [super init]) {
        if (navigationController) {
            _navHeight = 64;
            UIViewController *vcBase = navigationController.viewControllers.lastObject;
            self = [self initWithViewController:vcBase withDelegate:delegate style:style];
        }
    }
    
    return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style {
    if (self = [super init]) {
        if (viewController) {
            self = [self initWithView:viewController.view withDelegate:delegate style:style];
        }
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style {
   
    if (self = [super init]) {
        if (view) {
           self = [self initViewWithSuperView:view withDelegate:delegate style:style];
        }
    }
    return self;
}

- (instancetype)initViewWithSuperView:(id)superView withDelegate:(id<AHDropMenuViewDelegate>)delegate style:(AHDropMenuViewStyle)style {
    _vSuper = superView;
    _delegate = delegate;
    [superView addSubview:self];
    self.backgroundColor = [UIColor clearColor];
 
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_navHeight);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(_vSuper.frame.size.height - _navHeight);
    }];
    
    switch (style) {
        case AHDropMenuViewStyleSingleSelect:
            _isMultiselect = NO;
            _isHaveBlurredView = YES;
            break;
        case AHDropMenuViewStyleMutiSelect:
           _isMultiselect = YES;
            _isHaveBlurredView = YES;
            break;
        case AHDropMenuViewStyleSingleSelectPain:
            _isMultiselect = NO;
            _isHaveBlurredView = NO;
            break;
        case AHDropMenuViewStyleMutiSelectPain:
            _isMultiselect = YES;
            _isHaveBlurredView = NO;
            break;

        default:
            _isMultiselect = NO;
            _isHaveBlurredView = YES;
            break;
    }

    self.hidden = YES;
    [self initialValue];
    [self createSubViewsAndConstraints];
    //        为view添加key 防止约束冲突
    //        MASAttachKeys(self, _tableView, _headerView, _blurredView);
    
    return self;
}


- (void)initialValue {
    //初始化数据放在一起
    if (_delegate && [_delegate respondsToSelector:@selector(dataSourceForDropMenu)]) {
        _arrDataSource = [_delegate dataSourceForDropMenu];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(){
        NSInteger count = 0;
        for ( AHDropMenuItem *model in _arrDataSource) {
            if (count >= 2) {
                _isMultiselect = YES;
                break;
            }
            if (model.selected == YES) {
                count += 1;
                _lastModel = model;                
            }
        }
    });
    _indexSet = [[NSMutableIndexSet alloc] init];
    _isShow = NO;
    _isAutoHidden = YES;
}

- (void)createSubViewsAndConstraints {
    if (_isHaveBlurredView == YES) {
        _blurredView = [[UIView alloc]init];
        _blurredView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_blurredView];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [_blurredView addGestureRecognizer:bgTap];
        [_blurredView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        
        
    }

    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    
   //headView 的设置
   
    CGFloat headerHeight = 0.0f;

    if (_delegate && [_delegate respondsToSelector:@selector(dropMenuHeaderViewString:)]) {
        _headerView = [[UIView alloc] init];
        _tableView.tableHeaderView = _headerView;
        
        NSString *strHeaderChild = [_delegate dropMenuHeaderViewString:self];
        UILabel *labHeaderChild = [[UILabel alloc]init];
        _headerView.backgroundColor = kACColorBackground;
        labHeaderChild.text = strHeaderChild;
        labHeaderChild.font = kFontSize(14);
        labHeaderChild.textColor = kACColorGray1;
        [_headerView addSubview:labHeaderChild];
        [labHeaderChild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(HEIGHT_PT(15));
            make.bottom.mas_equalTo(HEIGHT_PT(-10));
            make.leading.mas_equalTo(WIDTH_PT(15));
            make.trailing.mas_equalTo(WIDTH_PT(-15));
        }];
        
        if (_delegate && [_delegate respondsToSelector:@selector(dropMenuHeaderViewHeight)]) {
            headerHeight = [_delegate dropMenuHeaderViewHeight];
            //tableView的高度最多为60
            headerHeight = headerHeight > HEIGHT_PT(60) ? HEIGHT_PT(60) : headerHeight;
        }
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make){
            make.leading.top.mas_equalTo(0);
            make.width.equalTo(_tableView.mas_width);
            make.height.mas_equalTo(headerHeight);
        }];
        
    }
    else if (_delegate && [_delegate respondsToSelector:@selector(dropMenuHeaderView:)]) {
        UIView *vHeaderChild = [_delegate dropMenuHeaderView:self];
        
        if (vHeaderChild) {
            
            _headerView = [[UIView alloc] init];
            _tableView.tableHeaderView = _headerView;
            if (_delegate && [_delegate respondsToSelector:@selector(dropMenuHeaderViewHeight)]) {
                headerHeight = [_delegate dropMenuHeaderViewHeight];
                //tableView的高度最多为60
                headerHeight = headerHeight > HEIGHT_PT(60) ? HEIGHT_PT(60) : headerHeight;
            }
            [_headerView addSubview:vHeaderChild];
            [_headerView mas_makeConstraints:^(MASConstraintMaker *make){
                make.leading.top.mas_equalTo(0);
                make.width.equalTo(_tableView.mas_width);
                make.height.mas_equalTo(headerHeight);
            }];
            [_tableView layoutIfNeeded];
            vHeaderChild.center = _headerView.center;
        }
        
    }
   
    
    _currentHeadViewHeight = headerHeight;
    _currentTableViewHeight = _tableView.contentSize.height + headerHeight;

    
    
}

/** 点击阴影遮罩 */
-(void)bgTappedAction:(UITapGestureRecognizer *)tap {
    //判断被点击之后是否收起tableView
    if (self.isAutoHidden) {
        [self hideAnimated:YES];
    }
}
#pragma mark - Public
- (void)maxTableViewMaxRowNum:(NSInteger)maxRowNum {
    
    maxRowNum = maxRowNum > _maxRowNum ? _maxRowNum : maxRowNum;
    _currentTableViewHeight = maxRowNum * _defaultCellRowHeight + _currentHeadViewHeight;
    [_tableView reloadData];
}

- (void)showAnimated:(BOOL)animated {
    [self showAnimated:animated showCompletionHandler:nil];
}
- (void)showAnimated:(BOOL)animated showCompletionHandler:(void(^)())showCompletionHandler {
    [self showAnimated:animated showCompletionHandler:showCompletionHandler hideWhenHandler:nil];
}

- (void)showAnimated:(BOOL)animated showCompletionHandler:(void(^)())showCompletionHandler hideWhenHandler:(void(^)())hideWhenHandler {
    
    if (_isShow == YES) {
        return;
    }
    _isShow = YES;
    self.hidden = NO;
    self.alpha = 0;
    
    //设置初始位置
    switch (_animationType) {
        case AHDropMenuViewAnimationTypeDrop:
            [self dropHideAnimation];
            break;
        case AHDropMenuViewAnimationTypeSheet:
            [self sheetHideAnimation];
            break;
        default:
            [self dropShowAnimation];
            break;
    }
    
    //设置动画位置
    if (animated == YES) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            switch (_animationType) {
                case AHDropMenuViewAnimationTypeDrop:
                    [self dropShowAnimation];
                    break;
                case AHDropMenuViewAnimationTypeSheet:
                    
                    [self sheetShowAnimation];
                    break;
                default:
                    [self dropShowAnimation];
                    break;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (showCompletionHandler) {
                    showCompletionHandler();
                }
            }];
            
        }];
        

    }
    else {
        
        self.alpha = 1;
        switch (_animationType) {
            case AHDropMenuViewAnimationTypeDrop:
                [self dropShowAnimation];
                break;
            case AHDropMenuViewAnimationTypeSheet:
                
                [self sheetShowAnimation];
                break;
            default:
                [self dropShowAnimation];
                break;
        }
        [self layoutIfNeeded];
        if (showCompletionHandler) {
            showCompletionHandler();
        }
    }
    
    if (hideWhenHandler) {
        _hideWhenHandler = hideWhenHandler;
    }
  
}

- (void)hideAnimated:(BOOL)animated {
    
    _isShow = NO;
    
    switch (_animationType) {
        case AHDropMenuViewAnimationTypeDrop:
            [self dropHideAnimation];
            break;
        case AHDropMenuViewAnimationTypeSheet:
            [self sheetHideAnimation];
            break;
        default:
            [self dropHideAnimation];
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.alpha = 0;
        if (_hideWhenHandler) {
            _hideWhenHandler();
        }
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
        
    }];

}

#pragma mark - Private

- (void)dropShowAnimation {
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(_currentTableViewHeight);
    }];
}

- (void)dropHideAnimation {
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self layoutIfNeeded];
}

- (void)sheetShowAnimation {

    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT - _currentTableViewHeight - _navHeight);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(_currentTableViewHeight);
    }];
}
- (void)sheetHideAnimation {
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self layoutIfNeeded];
    
}
#pragma mark - ButtonClicked
- (void)onClickBtnAllConfirm:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    [_arrDataSource enumerateObjectsUsingBlock:^(AHDropMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.selected = btn.selected;
        
    }];
    
    [_tableView reloadData];
}

- (void)onClickBtnConfrim:(UIButton *)btn{
   

    [self hideAnimated:YES];
    //抛出一个代理
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //不论是单选还是多选都需要为model赋值
    AHDropMenuItem *model = _arrDataSource[indexPath.row];
    if (_isMultiselect) {
        model.selected = !model.selected;
    } else {
        
        if (self.isAutoHidden == NO && [_lastModel isEqual: model]) {
            model.selected = !model.selected;
        } else {
            _lastModel.selected = NO;
            model.selected = YES;
        }
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
        if (_lastModel.selected == YES) {
            [_indexSet addIndex:indexPath.row];
        }
        if ([_delegate respondsToSelector:@selector(dropMenuView:didSelectAtIndex:)]) {
            
            if (_indexSet.count > 0) {
              [_delegate dropMenuView:self didSelectAtIndex:indexPath];
            } else {
                [_delegate dropMenuView:self didSelectAtIndex:nil];
            }
            
        }
        //判断被点击之后是否收起tableView
        if (self.isAutoHidden) {
            [self hideAnimated:YES];
        }
    }
    
    [_tableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell 高度屏幕适配
    if ([_delegate respondsToSelector:@selector(dropMenuView:heightForRowAtIndexPath:)]) {
      _defaultCellRowHeight = [_delegate dropMenuView:self heightForRowAtIndexPath:indexPath];
        
    }
    _defaultCellRowHeight = _defaultCellRowHeight > 0 ? _defaultCellRowHeight : HEIGHT_PT(44);
    return _defaultCellRowHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (_isMultiselect) {
        
        if (_footerView == nil) {
            
            if ([_delegate respondsToSelector:@selector(dropMenuFooterView:)]) {
                _footerView =  [_delegate dropMenuFooterView:self];
                
                return _footerView;
            }
            
            _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,HEIGHT_PT(90))];
            _footerView.backgroundColor = kACColorWhite;
            
            UIButton *btnAllConfrim = [[UIButton alloc]init];
            //        btnAllConfrim.backgroundColor = kACColorWhite;
            UIImage *imgEmpty = [UIImage imageNamed:@"icon_box-empty"];
            UIImage *imgCheck = [UIImage imageNamed:@"icon_box-checked"];
            imgEmpty = [UIImage ak_scaleImage:imgEmpty toSize:CGSizeMake(22, 22) isBaseOnShortEdge:YES];
            imgCheck = [UIImage ak_scaleImage:imgCheck toSize:CGSizeMake(22, 22) isBaseOnShortEdge:YES];
            [btnAllConfrim setImage:imgEmpty forState:UIControlStateNormal];
            [btnAllConfrim setImage:imgCheck forState:UIControlStateSelected];
            [btnAllConfrim setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 13)];
            [btnAllConfrim setTitle:@"以上全部" forState:UIControlStateNormal];
            [btnAllConfrim setTitleColor:kACColorGray1 forState:UIControlStateNormal];
            btnAllConfrim.titleLabel.font = kFontSize(14);
            btnAllConfrim.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btnAllConfrim addTarget:self action:@selector(onClickBtnAllConfirm:) forControlEvents:UIControlEventTouchUpInside];
            [_footerView addSubview:btnAllConfrim];
            [btnAllConfrim mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(WIDTH_PT(15));
                make.height.mas_equalTo(HEIGHT_PT(45));
                make.width.mas_equalTo(WIDTH_PT(90));
                make.top.mas_equalTo(0);
            }];
            
            UIButton *btnConfrim = [[UIButton alloc]init];
            btnConfrim.backgroundColor = kACColorOrange;
            [btnConfrim setTitle:@"确定" forState:UIControlStateNormal];
            [btnConfrim addTarget:self action:@selector(onClickBtnConfrim:) forControlEvents:UIControlEventTouchUpInside];
            [_footerView addSubview:btnConfrim];
            [btnConfrim mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.mas_equalTo(0);
                make.height.mas_equalTo(HEIGHT_PT(45));
                make.bottom.mas_equalTo(0);
            }];
            [_footerView layoutIfNeeded];
        }
    }
    
    return _footerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_isMultiselect) {
        _currentfooterViewHeight = HEIGHT_PT(90);
        if ([_delegate respondsToSelector:@selector(dropMenuFooterViewHeight)]) {
           _currentfooterViewHeight = [_delegate dropMenuFooterViewHeight];
        }
    }
    
    return _currentfooterViewHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
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


//---------------------------------Frame-------------------------------------------
//    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];

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

//-----------------------------------SpringAnimation-------------------------------------
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self layoutIfNeeded];
//        self.alpha = 0;
//    }completion:^(BOOL finished) {
//
//        self.hidden = YES;
//        self.alpha = 1;
//
//    }];

//        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
//
//            [self layoutIfNeeded];
//        }completion:^(BOOL finished) {
//            if (completionHandler) {
//                completionHandler();
//            }
//        }];


@end
