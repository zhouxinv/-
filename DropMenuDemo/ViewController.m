//
//  ViewController.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "ViewController.h"
#import "AHDropMenuView.h"
#import "AHDropMenuItem.h"


@interface ViewController ()<AHDropMenuViewDelegate>
@property(nonatomic, strong) AHDropMenuView *dropView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [button setTitle:@"Drop" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    //1.设置model
    _dataSourceArr = [NSMutableArray new];

    NSArray *arr = @[@"1.CELTICS",@"2.CLIPPERS",@"3.WARRIORS",@"4.CELTICS",@"5.CLIPPERS",@"6.WARRIORS",@"7.CELTICS",@"8.CLIPPERS",@"9.WARRIORS",@"10.CELTICS",@"11.CLIPPERS",@"12.WARRIORS",@"13.CELTICS",@"14.CLIPPERS",@"15.WARRIORS"];
    NSMutableArray *iconMutableArr = [NSMutableArray array];
    NSArray *iconArray = @[@"1",@"2", @"3", @"4",@"5", @"3",@"1",@"2", @"5",@"4",@"2", @"3"];
    [iconArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * img = [UIImage imageNamed:obj];
        
        [iconMutableArr addObject:img];
    }];

    __weak typeof(*&self) wSelf = self;
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak typeof(*&self) self = wSelf;
        AHDropMenuItem *model;
        if (iconMutableArr.count > idx) {
            //几个没有头像的特殊情况处理
            if (idx == 4 || idx == 7 || idx == 8) {
                model = [[AHDropMenuItem alloc]initWithTitle:obj icon:nil iconHighlighted:nil];
                
            }
            //这两个被选择的时候对勾传入自定义图片
            else if (idx == 1 || idx == 2){
                model = [[AHDropMenuItem alloc]initWithTitle:obj icon:iconMutableArr[idx]];
                [model setTitleFont:[UIFont systemFontOfSize:12]];
                model.checkImageSelected = [UIImage imageNamed:@"tick"];
                
            }
            else {
                model = [[AHDropMenuItem alloc]initWithTitle:obj icon:iconMutableArr[idx]];
            }
            
        } else {
            model = [[AHDropMenuItem alloc]initWithTitle:obj icon:nil];
        }
        
        #warning 如果这样设置cell的话, 比如调用者只设置了cell的背景色,高亮的时候就用默认的高亮背景色了.
//        model.backgroundColor = [UIColor colorWithRed:0.976 green:0.84 blue:0.95 alpha:1];
        [self.dataSourceArr addObject:model];
    }];
    
}

- (void)navButtonClicked:(UIButton *)btn {
    
    if (_dropView == nil) {
        // 2. 多选样式
        _dropView = [[AHDropMenuView alloc] initWithNavigationController: self.navigationController withDelegate:self style:AHDropMenuViewStyleMutiSelect];
        //3. 设置下拉菜单的最大高度
        [_dropView maxTableViewMaxRowNum:4];

    }
    
    if (self.dropView.isShow) {
        [self.dropView hideAnimated:YES];
        _dropView = nil;
    } else {
        [self.dropView showAnimated:YES showCompletionHandler:^{
            NSLog(@"展示动画完成");
        } hideWhenHandler:^{
            NSLog(@"隐藏动画的同时");
        }];
        
    }
}
#pragma mark - AHDropMenuViewDelegate

- (NSArray<AHDropMenuItem *> *)dataSourceForDropMenu {
    return _dataSourceArr;
}

- (UIView *)dropMenuHeaderView:(AHDropMenuView *)dropMenuView {
    //传入的headView的frame由外界控制，内部不做处理
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 50);
    lab.backgroundColor = [UIColor orangeColor];
    lab.text = @"设置你自己想要的headView";
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (CGFloat)dropMenuHeaderViewHeight {
    return 50.0;
}

- (void)dropMenuView:(AHDropMenuView *)dropMenuView didSelectAtIndex:(NSIndexPath *)indexPath {
    NSLog(@"第%zd项",indexPath.row);
}
- (void)dropMenuView:(AHDropMenuView *)dropMenuView didMultiSelectIndexPaths:(NSIndexSet *)selIndexSet {
    [selIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"含有%zd项",idx);

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
