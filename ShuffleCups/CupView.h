//
//  CupView.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cup;
@protocol CupViewDelegate;

@interface CupView : UIImageView

@property(strong) Cup* cup;
@property(strong) UIImageView* upperCupView;
@property(strong) id<CupViewDelegate> delegate;
@property(assign) BOOL moving;

- (id)initWithFrame:(CGRect)frame cup:(Cup *)cup delegate:(id<CupViewDelegate>)delegate;
- (void)overturn;
@end

@protocol CupViewDelegate<NSObject>

@optional
- (void)configureTouchBeganCupWithTouch:(UITouch*)touch withEvent:(UIEvent*)event;
- (void)configureTouchEndedCupWithTouch:(UITouch*)touch withEvent:(UIEvent*)event;
- (void)shuffleCups;

@end
