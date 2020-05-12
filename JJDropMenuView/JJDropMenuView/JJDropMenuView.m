//
//  JJDropMenuView.m
//  JJDropMenuView
//
//  Created by Lance on 2020/5/11.
//  Copyright © 2020 Lance. All rights reserved.
//

#import "JJDropMenuView.h"
#import "JJDropMenuCell.h"

//当前屏幕宽度
#define JJ_SCREEN_WIDTH ([[UIScreen mainScreen]  bounds].size.width)
//当前屏幕高度
#define JJ_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface JJDropMenuView () <UITableViewDelegate, UITableViewDataSource, JJDropMenuButtonDelegate>

@property (nonatomic, strong) UIButton *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *menuTitleArray;

@property (nonatomic, strong) JJDropMenuButton *menuButton;

@end

@implementation JJDropMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.itemSelectColor = [UIColor blueColor];
        self.itemNormalColor = [UIColor blackColor];
        self.titleSelectColor = [UIColor blueColor];
        self.titleNormalColor = [UIColor blackColor];
        
        [self setupBackgroundView];
        [self setupContentView];
    }
    return self;
}

/// Description 初始化数据
/// @param menuTitleArray 构造数组
- (void)setupDataWithMenuTitleArray:(NSMutableArray *)menuTitleArray
{
    self.menuTitleArray = menuTitleArray;
    
    [self layoutIfNeeded];
    
    NSMutableArray *menuButtonArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < menuTitleArray.count; i++) {

        JJDropMenuModel *model = menuTitleArray[i];
        JJDropMenuButton *menuButton = [[JJDropMenuButton alloc] init];
        menuButton.delegate = self;
        [self addSubview:menuButton];
        
        menuButton.selectColor = self.titleSelectColor;
        menuButton.normalColor = self.titleNormalColor;
        menuButton.title = model.title;
        menuButton.index = i;
        menuButton.selectRow = 0;
        
        for (NSInteger j = 0; j < model.items.count; j++) {
            JJDropMenuItemModel *itemModel = model.items[j];
            
            if (itemModel.isSelected) {
                menuButton.selectRow = j;
            }
        }
        
        [menuButtonArray addObject:menuButton];
        
        menuButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *btnTopCon = [NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:btnTopCon];
        
        NSLayoutConstraint *btnBottomCon = [NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraint:btnBottomCon];
        
        NSLayoutConstraint *btnCenterXCon = [NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 / menuTitleArray.count * (i * 2 + 1) constant:0];
        [self addConstraint:btnCenterXCon];
        
        NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0 constant:self.frame.size.width / menuTitleArray.count];

        [menuButton addConstraint:btnWidth];
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:224.0 / 255.0 green:224.0 / 255.0 blue:224.0 / 255.0 alpha:1];
    [self addSubview:line];
    
    line.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *lineLeftCon = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:lineLeftCon];
    
    NSLayoutConstraint *lineRightCon = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:lineRightCon];
    
    NSLayoutConstraint *lineBottomCon = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:lineBottomCon];
    
    NSLayoutConstraint *lineHeight = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.5];

    [line addConstraint:lineHeight];
}

- (void)setupBackgroundView
{
    //背景图
    UIButton *backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
    
    self.backgroundView = backgroundView;
    
    //手势点击
    UIView *gestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JJ_SCREEN_WIDTH, 0)];
    
    gestureView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [gestureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    gestureView.alpha = 0;
    [self.backgroundView addSubview:gestureView];
    
    self.gestureView = gestureView;
}

- (void)setupContentView
{
    //内容图
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JJ_SCREEN_WIDTH, 0)];
    contentView.layer.masksToBounds = YES;
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:contentView];
    
    self.contentView = contentView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, JJ_SCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionFooterHeight = 0.01;
    tableView.sectionHeaderHeight = 0.01;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerClass:[JJDropMenuCell class] forCellReuseIdentifier:@"JJDropMenuCell"];
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [contentView addSubview:tableView];
    
    self.tableView = tableView;
}

#pragma mark table 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JJDropMenuModel *model = self.menuTitleArray[self.menuButton.index];
    return model.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJDropMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJDropMenuCell" forIndexPath:indexPath];
    
    NSString *contentString = @"";
    BOOL isSelected = NO;
    
    JJDropMenuModel *model = self.menuTitleArray[self.menuButton.index];
    JJDropMenuItemModel *itemModel = model.items[indexPath.row];
    contentString = itemModel.title;
    isSelected = self.menuButton.selectRow == indexPath.row;

    cell.titleLabel.text = contentString;
    cell.titleLabel.textColor = isSelected ? self.itemSelectColor : self.itemNormalColor;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.menuButton.selectRow = indexPath.row;
    
    NSString *itemId = @"";
    
    JJDropMenuModel *model = self.menuTitleArray[self.menuButton.index];
    
    if (model.items.count) {
        JJDropMenuItemModel *itemModel = model.items[indexPath.row];
        itemId = itemModel.itemId;
        self.menuButton.subTitle = itemModel.title;
    }

    if ([self.delegate respondsToSelector:@selector(jj_dropMenuView_didSelectRowAtMenuButton:itemId:)]) {
         [self.delegate jj_dropMenuView_didSelectRowAtMenuButton:self.menuButton itemId:itemId];
    }
    
    [self.tableView reloadData];
    [self dismiss];
}

#pragma mark JJDropMenuButtonDelegate

- (void)jj_dropMenuButton_select:(JJDropMenuButton *)button
{
    if (self.menuButton.selected && ![self.menuButton isEqual:button]) {
        self.menuButton.selected = NO;
    }
    
    self.menuButton = button;

    if (button.selected) {
        [self show];
    } else {
        [self dismiss];
    }
}

/// Description 刷新数据
- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)show
{
    [self.tableView reloadData];
    
    CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    
    self.backgroundView.frame = CGRectMake(0, CGRectGetMaxY(rect), JJ_SCREEN_WIDTH, JJ_SCREEN_HEIGHT - CGRectGetMaxY(rect));
    self.gestureView.frame = CGRectMake(0, 0, JJ_SCREEN_WIDTH, JJ_SCREEN_HEIGHT - CGRectGetMaxY(rect));
    
    NSInteger rowCount = (NSInteger)ceilf((CGFloat)[self.tableView numberOfRowsInSection:0]);
    CGFloat viewHeight = 50 * rowCount;
    CGFloat maxHeight = JJ_SCREEN_HEIGHT - CGRectGetMaxY(self.frame) - 200;
    viewHeight = viewHeight > maxHeight ? maxHeight : viewHeight;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.3 animations:^{
            self.gestureView.alpha = 1;
            self.contentView.frame = CGRectMake(0, 0, JJ_SCREEN_WIDTH, viewHeight);
            self.tableView.frame = CGRectMake(0, 0, JJ_SCREEN_WIDTH, viewHeight);
            self.gestureView.frame = CGRectMake(0, viewHeight, JJ_SCREEN_WIDTH, JJ_SCREEN_HEIGHT - viewHeight - CGRectGetMaxY(rect));
        } completion:^(BOOL finished) {
            
        }];
    });
}

/// Description 关闭页面
- (void)dismiss
{
    self.menuButton.selected = NO;
    
    CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.gestureView.alpha = 0;
        self.contentView.frame = CGRectMake(0, 0, JJ_SCREEN_WIDTH, 0);
        self.tableView.frame = CGRectMake(0, 0, JJ_SCREEN_WIDTH, 0);
        self.gestureView.frame = CGRectMake(0, 0, JJ_SCREEN_WIDTH, JJ_SCREEN_HEIGHT - CGRectGetMaxY(rect));
    } completion:^(BOOL finished) {
        
        CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
        self.backgroundView.frame = CGRectMake(0, CGRectGetMaxY(rect), JJ_SCREEN_WIDTH, 0);
    }];
}

- (void)dealloc
{
    NSLog(@"销毁了");
    
    [self.backgroundView removeFromSuperview];
    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.subviews);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
