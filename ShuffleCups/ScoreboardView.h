//
//  ScoreboardView.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scoreboard;

@interface ScoreboardView : UIImageView

@property (strong, nonatomic)Scoreboard* scoreboard;
@property (strong, nonatomic)UIImageView* score0;
@property (strong, nonatomic)UIImageView* score1;
@property (strong, nonatomic)UIImageView* score2;
@property (strong, nonatomic)UIImageView* score3;

- (id)initWithFrame:(CGRect)frame scoreboard:(Scoreboard *)scoreboard;
- (void)updateScore;

@end
