//
//  BallView.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "BallView.h"
#import "Ball.h"

@implementation BallView

static NSString* redBallImage = @"RedBall";
static NSString* greenBallImage = @"GreenBall";
static NSString* blueBallImage = @"BlueBall";
static NSString* yellowBallImage = @"YellowBall";

-(id)initWithFrame:(CGRect)frame ball:(Ball *)ball
{
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.ball = ball;
        
        switch (self.ball.color) {
            case Red:    self.image = [UIImage imageNamed:redBallImage];
                break;
            case Green:  self.image = [UIImage imageNamed:greenBallImage];
                break;
            case Blue:   self.image = [UIImage imageNamed:blueBallImage];
                break;
            case Yellow: self.image = [UIImage imageNamed:yellowBallImage];
                break;
            default:     break;
        }
    }
    
    return self;
}

- (void)drop
{
    
    CGRect frame = self.frame;
    frame.origin.y += self.ball.speed;
    [self setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
