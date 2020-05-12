//
//  ViewController.m
//  JJDropMenuView
//
//  Created by Lance on 2020/5/11.
//  Copyright © 2020 Lance. All rights reserved.
//

#import "ViewController.h"
#import "JJDropMenuView.h"

@interface ViewController () <JJDropMenuViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    JJDropMenuView *view = [[JJDropMenuView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44)];
    view.delegate = self;
    [self.view addSubview:view];
    
    //构造数据（二维）
    NSMutableArray *array = [NSMutableArray array];
    
    //标题1
    JJDropMenuModel *model1 = [[JJDropMenuModel alloc] init];
    
    model1.title = @"1";
    model1.items = [NSMutableArray array];
    
    //下拉数据
    for (NSInteger i = 0; i < 5; i++) {
        JJDropMenuItemModel *model = [[JJDropMenuItemModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@-%ld", model1.title, (long)i];
        model.itemId = [NSString stringWithFormat:@"%ld", (long)i];
        model.isSelected = i == 2;
        
        [model1.items addObject:model];
    }
    
    //标题2
    JJDropMenuModel *model2 = [[JJDropMenuModel alloc] init];
    
    model2.title = @"2";
    model2.items = [NSMutableArray array];
    
    //下拉数据
    for (NSInteger i = 0; i < 10; i++) {
        JJDropMenuItemModel *model = [[JJDropMenuItemModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@-%ld", model2.title, (long)i];
        model.itemId = [NSString stringWithFormat:@"%ld", (long)i];
        model.isSelected = i == 5;
        
        [model2.items addObject:model];
    }
    
    [array addObject:model1];
    [array addObject:model2];
    
    //设置数据
    [view setupDataWithMenuTitleArray:array];

}

#pragma mark JJDropMenuViewDelegate

- (void)jj_dropMenuView_didSelectRowAtMenuButton:(JJDropMenuButton *)menuButton itemId:(NSString *)itemId
{
    NSLog(@"点击了 %ld -- %@", (long)menuButton.index, itemId);
}


@end
