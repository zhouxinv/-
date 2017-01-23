//
//  ViewController.m
//  DropMenuDemo
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import "ViewController.h"
#import "AHDropMenuView.h"

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
    
    //1.设置标题
    NSArray *arr = @[@"1.CELTICS",@"2.CLIPPERS",@"3.WARRIORS",@"4.CELTICS",@"5.CLIPPERS",@"6.WARRIORS",@"7.CELTICS",@"8.CLIPPERS",@"9.WARRIORS",@"10.CELTICS",@"11.CLIPPERS",@"12.WARRIORS",@"13.CELTICS",@"14.CLIPPERS",@"15.WARRIORS"];
    self.dropView = [[AHDropMenuView alloc]initWithNavigationController:self.navigationController];
    _dropView.delegate = self;
    [_dropView showWithDataSource:arr];
    //2.设置图标icon
//    [_dropView setCelliconsArray:@[@"1",@"2", @"3", @"4",@"5", @"3",@"1",@"2", @"5",@"4",@"2", @"3"]];
    NSMutableArray *iconMutableArr = [NSMutableArray array];
    NSArray *iconArray = @[@"1",@"2", @"3", @"4",@"5", @"3",@"1",@"2", @"5",@"4",@"2", @"3"];
    [iconArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * img = [UIImage imageNamed:obj];
        
        [iconMutableArr addObject:img];
    }];
    
    [_dropView showWithCelliconsArray:iconMutableArr];
    // 3. 多选
    _dropView.isMultiselect = YES;
    //4.标题颜色大小
    [_dropView setTitleColor:[UIColor blueColor]];
    [_dropView setTitleFontSize:12];
    //5. 设置下拉菜单的最大高度
    [_dropView maxTableViewMaxRowNum:4];
    
}

- (void)navButtonClicked:(UIButton *)btn{
    
    if (self.dropView.isShow) {
        [self.dropView hide];
    }else{
        [self.dropView show];
        
    }
}
#pragma mark - AHDropMenuViewDelegate
- (UIView *)dropMenuHeaderView:(AHDropMenuView *)dropMenuView{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(50, 0, 200, 50);
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

- (CGFloat)heightForHeaderView{
    return 50;
}

- (void)dropMenuView:(AHDropMenuView *)dropMenuView didSelectAtIndex:(NSIndexPath *)indexPath{
    NSLog(@"第%zd项",indexPath.row);
}
- (void)dropMenuView:(AHDropMenuView *)dropMenuView didMultiSelectIndexPaths:(NSIndexSet *)selIndexSet{
    [selIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"含有%zd项",idx);

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
