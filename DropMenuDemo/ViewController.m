//
//  ViewController.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "ViewController.h"
#import "AHDropMenuView.h"
#import "AHDropMenuViewModel.h"

@interface ViewController ()<AHDropMenuViewDelegate>
@property(nonatomic, strong) AHDropMenuView *dropView;

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
    NSMutableArray *dataSourceArr = [NSMutableArray array];
    NSArray *arr = @[@"1.CELTICS",@"2.CLIPPERS",@"3.WARRIORS",@"4.CELTICS",@"5.CLIPPERS",@"6.WARRIORS",@"7.CELTICS",@"8.CLIPPERS",@"9.WARRIORS",@"10.CELTICS",@"11.CLIPPERS",@"12.WARRIORS",@"13.CELTICS",@"14.CLIPPERS",@"15.WARRIORS"];
    NSMutableArray *iconMutableArr = [NSMutableArray array];
    NSArray *iconArray = @[@"1",@"2", @"3", @"4",@"5", @"3",@"1",@"2", @"5",@"4",@"2", @"3"];
    [iconArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * img = [UIImage imageNamed:obj];
        
        [iconMutableArr addObject:img];
    }];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (iconMutableArr.count > idx) {
            //几个没有头像的特殊情况处理
            if (idx == 4 || idx == 7 || idx == 8) {
                AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]initWithIconImage:nil title:obj];
                [dataSourceArr addObject:model];
            }
            //这两个被选择的时候对勾传入自定义图片
            else if (idx == 1 || idx == 2){
                AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]initWithIconImage:iconMutableArr[idx] title:obj checkImage:[UIImage imageNamed:@"tick"]];
                [dataSourceArr addObject:model];
            }
            else {
                AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]initWithIconImage:iconMutableArr[idx] title:obj];
                [dataSourceArr addObject:model];
            }
            
        } else {
            AHDropMenuViewModel *model = [[AHDropMenuViewModel alloc]initWithIconImage:nil title:obj];
            [dataSourceArr addObject:model];
        }
        
    }];
    
    _dropView = [[AHDropMenuView alloc]initWithNavigationController:self.navigationController];
    _dropView.delegate = self;
    // 添加数据源
    [_dropView showWithDataSource:dataSourceArr];
    
    // 2. 多选
    _dropView.isMultiselect = YES;
    //3.标题颜色大小
    [_dropView setTitleColor:[UIColor blueColor]];
    [_dropView setTitleFontSize:12];
    //4. 设置下拉菜单的最大高度
    [_dropView maxTableViewMaxRowNum:6];
    
}

- (void)navButtonClicked:(UIButton *)btn {
    
    if (self.dropView.isShow) {
        [self.dropView hide];
    } else {
        [self.dropView show];
        
    }
}
#pragma mark - AHDropMenuViewDelegate
- (UIView *)dropMenuHeaderView:(AHDropMenuView *)dropMenuView {
    //传入的headView的frame由外界控制，内部不做处理
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20 , 50);
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

- (CGFloat)heightForHeaderView {
    return 50;
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
