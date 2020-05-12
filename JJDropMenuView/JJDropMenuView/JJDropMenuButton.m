//
//  JJDropMenuButton.m
//  JJDropMenuView
//
//  Created by Lance on 2020/5/11.
//  Copyright © 2020 Lance. All rights reserved.
//

#import "JJDropMenuButton.h"

@interface JJDropMenuButton ()

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *arrowView;
@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation JJDropMenuButton

- (instancetype)init
{
    self = [super init];
    
    if (self) {

        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.selectColor = [UIColor blueColor];
    self.normalColor = [UIColor blackColor];
    
    //点选按钮
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setTitle:@"--" forState:UIControlStateNormal];
    [selectedButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    [selectedButton setTitleColor:self.selectColor forState:UIControlStateSelected];
    selectedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectedButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectedButton];
    
    self.selectedButton = selectedButton;
    
    selectedButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *btnTopCon = [NSLayoutConstraint constraintWithItem:selectedButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:btnTopCon];
    
    NSLayoutConstraint *btnBottomCon = [NSLayoutConstraint constraintWithItem:selectedButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:btnBottomCon];
    
    NSLayoutConstraint *btnCenterXCon = [NSLayoutConstraint constraintWithItem:selectedButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-10];
    [self addConstraint:btnCenterXCon];

    //箭头
    UIView *arrowView = [[UIView alloc] init];
    [self addSubview:arrowView];
    
    arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.arrowView = arrowView;
    
    NSLayoutConstraint *arrowLeftCon = [NSLayoutConstraint constraintWithItem:arrowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:selectedButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    [self addConstraint:arrowLeftCon];

    NSLayoutConstraint *arrowCenterYCon = [NSLayoutConstraint constraintWithItem:arrowView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:selectedButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self addConstraint:arrowCenterYCon];
    
    NSLayoutConstraint *arrowHeight = [NSLayoutConstraint constraintWithItem:arrowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:3];

    [arrowView addConstraint:arrowHeight];
    
    NSLayoutConstraint *arrowWidth = [NSLayoutConstraint constraintWithItem:arrowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:6];

    [arrowView addConstraint:arrowWidth];

    CAShapeLayer *shapeLayer = [self creatArrowShapeLayer];
    [arrowView.layer addSublayer:shapeLayer];
    
    self.shapeLayer = shapeLayer;
}

- (CAShapeLayer *)creatArrowShapeLayer
{
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(6, 0)];
    [path addLineToPoint:CGPointMake(6 * 0.5, 3)];
    [path closePath];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [[UIColor colorWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1] CGColor];
    return shapeLayer;
}

- (void)selectAction:(UIButton *)button
{
    self.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(jj_dropMenuButton_select:)]) {
        [self.delegate jj_dropMenuButton_select:self];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self.selectedButton setTitle:title forState:UIControlStateNormal];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    
    if ([subTitle isEqualToString:@"全部"]) {
        [self.selectedButton setTitle:self.title forState:UIControlStateNormal];
    } else {
        [self.selectedButton setTitle:subTitle forState:UIControlStateNormal];
    }
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    
    if (selectColor == nil) return;
    
    [self.selectedButton setTitleColor:selectColor forState:UIControlStateSelected];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    
    if (normalColor == nil) return;
    
    [self.selectedButton setTitleColor:normalColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    self.selectedButton.selected = selected;
    
    if (selected) {
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            weakSelf.shapeLayer.fillColor = self.selectColor.CGColor;
        } completion:^(BOOL finished) {
        }];
    } else {
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.35 animations:^{
            weakSelf.arrowView.transform = CGAffineTransformIdentity;
            weakSelf.shapeLayer.fillColor = [[UIColor colorWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1] CGColor];
        } completion:^(BOOL finished) {
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
