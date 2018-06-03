//
//  BallView.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ball;
@protocol BallViewDelegate;

@interface BallView : UIImageView

@property (strong,nonatomic) Ball* ball;
@property id<BallViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ball:(Ball *)ball;
- (void)drop;

@end

@protocol BallViewDelegate<NSObject>

- (void)bounce:(BallView*)ball position:(int)position;
- (void)failedBounce:(BallView*)ball position:(int)position;

@end