//
//  JJDropMenuButton.h
//  JJDropMenuView
//
//  Created by Lance on 2020/5/11.
//  Copyright © 2020 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJDropMenuButton;

NS_ASSUME_NONNULL_BEGIN

@protocol JJDropMenuButtonDelegate <NSObject>

/// Description 点击回调
/// @param button 当前按钮
- (void)jj_dropMenuButton_select:(JJDropMenuButton *)button;

@end

@interface JJDropMenuButton : UIView

@property (nonatomic, weak) id<JJDropMenuButtonDelegate> delegate;

/// Description 点击状态
@property (nonatomic, assign) BOOL selected;

/// Description 按钮索引
@property (nonatomic, assign) NSInteger index;

/// Description 当前菜单列表选中位置
@property (nonatomic, assign) NSInteger selectRow;

/// Description 标题选中颜色
@property (nonatomic, strong) UIColor *selectColor;

/// Description 标题默认颜色
@property (nonatomic, strong) UIColor *normalColor;

/// Description 标题
@property (nonatomic, copy) NSString *title;

/// Description 副标题
@property (nonatomic, copy) NSString *subTitle;

@end

NS_ASSUME_NONNULL_END
