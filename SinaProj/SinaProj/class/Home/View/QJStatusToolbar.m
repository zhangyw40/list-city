//
//  QJStatusToolbar.m
//  SinaProj
//
//  Created by 杨丽娟 on 15/12/30.
//  Copyright © 2015年 Qin.Yu. All rights reserved.
//

#import "QJStatusToolbar.h"
#import "QJStatus.h"

@interface QJStatusToolbar ()

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, weak) UIButton *reweetBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;

@end
@implementation QJStatusToolbar

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置图片
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImageWithName:@"timeline_card_bottom_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_bottom_background_highlighted"];
        
        // 2.添加按钮
        self.reweetBtn = [self setupBtnWithTitle:@"转发" image:@"timeline_icon_retweet" bgImage:@"timeline_card_bottom_background_highlighted"];
        self.commentBtn = [self setupBtnWithTitle:@"评论" image:@"timeline_icon_comment" bgImage:@"timeline_card_bottom_background_highlighted"];
        self.attitudeBtn = [self setupBtnWithTitle:@"赞" image:@"timeline_icon_unlike" bgImage:@"timeline_card_bottom_background_highlighted"];
        
        // 3.添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}

/**
 *  初始化分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    [self.dividers addObject:divider];
}

/**
 *  初始化按钮
 *
 *  @param title   按钮的文字
 *  @param image   按钮的小图片
 *  @param bgImage 按钮的背景
 */
- (UIButton *)setupBtnWithTitle:(NSString *)title image:(NSString *)image bgImage:(NSString *)bgImage
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.adjustsImageWhenHighlighted = NO;
    [btn setBackgroundImage:[UIImage resizedImageWithName:bgImage] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    
    // 添加按钮到数组
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置按钮的frame
    int dividerCount = (int)self.dividers.count; // 分割线的个数
    CGFloat dividerW = 2; // 分割线的宽度
    int btnCount = (int)self.btns.count;
    CGFloat btnW = (self.frame.size.width - dividerCount * dividerW) / btnCount;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        // 设置frame
        CGFloat btnX = i * (btnW + dividerW);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 2.设置分割线的frame
    CGFloat dividerH = btnH;
    CGFloat dividerY = 0;
    for (int j = 0; j<dividerCount; j++) {
        UIImageView *divider = self.dividers[j];
        // 设置frame
        UIButton *btn = self.btns[j];
        CGFloat dividerX = CGRectGetMaxX(btn.frame);
        divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
}

- (void)setStatus:(QJStatus *)status
{
    _status = status;
    [self SetupBtn:self.reweetBtn originalTitle:@"转发" count:status.reposts_count];
    [self SetupBtn:self.commentBtn originalTitle:@"评论" count:status.comments_count];
    [self SetupBtn:self.attitudeBtn originalTitle:@"赞" count:status.attitudes_count];
}

- (void)SetupBtn:(UIButton *)btn originalTitle:(NSString *)originalTitle count:(int)count
{
    if (count) {
        NSString *title = nil;
        if (count < 10000) { // 小于1W
            title = [NSString stringWithFormat:@"%d", count];
        } else { // >= 1W
            // 42342 / 1000 * 0.1 = 42 * 0.1 = 4.2
            // 10742 / 1000 * 0.1 = 10 * 0.1 = 1.0
            // double countDouble = count / 1000 * 0.1;
            
            // 42342 / 10000.0 = 4.2342
            // 10742 / 10000.0 = 1.0742
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", countDouble];
            
            // title == 4.2万 4.0万 1.0万 1.1万
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];

        [btn setTitle:title forState:UIControlStateNormal];
    }else{
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}
@end
