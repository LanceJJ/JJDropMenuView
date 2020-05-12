//
//  JJDropMenuModel.h
//  JJDropMenuView
//
//  Created by Lance on 2020/5/12.
//  Copyright © 2020 Lance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJDropMenuItemModel : NSObject

@property (nonatomic, copy) NSString *itemId;//列表id
@property (nonatomic, copy) NSString *title;//列表标题
@property (nonatomic, assign) BOOL isSelected;//是否选中

@end

@interface JJDropMenuModel : NSObject

@property (nonatomic, copy) NSString *title;//菜单按钮标题
@property (nonatomic, strong) NSMutableArray *items;//子列表

@end

NS_ASSUME_NONNULL_END
