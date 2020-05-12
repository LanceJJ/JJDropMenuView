//
//  JJDropMenuView.h
//  JJDropMenuView
//
//  Created by Lance on 2020/5/11.
//  Copyright © 2020 Lance. All rights reserved.
//  v1.0.0

#import <UIKit/UIKit.h>
#import "JJDropMenuModel.h"
#import "JJDropMenuButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JJDropMenuViewDelegate <NSObject>

@optional

/// Description 选中回调
/// @param menuButton 当前菜单按钮
/// @param itemId 选中id
- (void)jj_dropMenuView_didSelectRowAtMenuButton:(JJDropMenuButton *)menuButton itemId:(NSString *)itemId;

@end

@interface JJDropMenuView : UIView

@property (nonatomic, weak) id<JJDropMenuViewDelegate> delegate;

/// Description 标题点击颜色
@property (nonatomic, strong) UIColor *titleSelectColor;

/// Description 标题默认颜色
@property (nonatomic, strong) UIColor *titleNormalColor;

/// Description 列表点击颜色
@property (nonatomic, strong) UIColor *itemSelectColor;

/// Description 列表默认颜色
@property (nonatomic, strong) UIColor *itemNormalColor;

/// Description 初始化数据
/// @param menuTitleArray 构造数组
- (void)setupDataWithMenuTitleArray:(NSMutableArray *)menuTitleArray;

/// Description 刷新数据
- (void)reloadData;

/// Description 关闭页面
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
