//
//  CupView.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "CupView.h"
#import "Cup.h"

@implementation CupView

static NSString* redCupImage = @"RedCup";
static NSString* greenCupImage = @"GreenCup";
static NSString* blueCupImage = @"BlueCup";
static NSString* upperRedCupImage = @"UpperRedCup";
static NSString* upperGreenCupImage = @"UpperGreenCup";
static NSString* upperBlueCupImage = @"UpperBlueCup";
static NSString* redCupOverturnImage = @"RedCupOverturn";
static NSString* greenCupOverturnImage = @"GreenCupOverturn";
static NSString* blueCupOverturnImage = @"BlueCupOverturn";


- (id)initWithFrame:(CGRect)frame cup:(Cup *)cup delegate:(id<CupViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if(self){
        
        self.cup = cup;
        switch (self.cup.color) {
            case Red:   self.image = [UIImage imageNamed:redCupImage];
                self.upperCupView = [[UIImageView alloc] initWithFrame:frame];
                self.upperCupView.image = [UIImage imageNamed:upperRedCupImage];
                break;
            case Green: self.image = [UIImage imageNamed:greenCupImage];
                self.upperCupView = [[UIImageView alloc] initWithFrame:frame];
                self.upperCupView.image = [UIImage imageNamed:upperGreenCupImage];
                break;
            case Blue:  self.image = [UIImage imageNamed:blueCupImage];
                self.upperCupView = [[UIImageView alloc] initWithFrame:frame];
                self.upperCupView.image = [UIImage imageNamed:upperBlueCupImage];
                break;
                
            default:    break;
        }
        self.moving = NO;
        self.upperCupView.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        [self addSubview:self.upperCupView];
        self.delegate = delegate;
        
        
    }
    
    return self;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    
    
    SEL sel = @selector(configureTouchBeganCupWithTouch:withEvent:);
    id delegate = self.delegate;
    
    if(delegate && [delegate respondsToSelector:sel])
        [delegate configureTouchBeganCupWithTouch:touch withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    SEL sel = @selector(configureTouchEndedCupWithTouch:withEvent:);
    id delegate = self.delegate;
    
    
    if(delegate && [delegate respondsToSelector:sel])
        [delegate configureTouchEndedCupWithTouch:touch withEvent:event];
    
    if( [touch tapCount] >= 2 && [touch tapCount] % 2 == 0)
        [self overturn];
   
}


- (void)overturn
{
    if(self.cup.overturn == NO)
    {
        self.upperCupView.hidden = YES;
        
        
        if(self.upperCupView.hidden == YES)
        {
            [UIView beginAnimations:@"overturn" context:nil];
            [UIView setAnimationDuration:0.07];
            
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            
            self.transform = CGAffineTransformMakeRotation(M_PI);
            self.upperCupView.transform = CGAffineTransformMakeRotation(M_PI);
            
            switch (self.cup.color) {
                case Red:   self.image = [UIImage imageNamed:redCupOverturnImage];
                    break;
                case Green: self.image = [UIImage imageNamed:greenCupOverturnImage];
                    break;
                case Blue:  self.image = [UIImage imageNamed:blueCupOverturnImage];
                    break;
                    
                default:    break;
            }
            
            [UIView commitAnimations];
        }
        
    }
    else
    {
        [UIView beginAnimations:@"overturn" context:nil];
        [UIView setAnimationDuration:0.07];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.transform = CGAffineTransformIdentity;
        self.upperCupView.transform =CGAffineTransformIdentity;
        
        switch (self.cup.color) {
            case Red:   self.image = [UIImage imageNamed:redCupImage];
                break;
            case Green: self.image = [UIImage imageNamed:greenCupImage];
                break;
            case Blue:  self.image = [UIImage imageNamed:blueCupImage];
                break;
            default:    break;
        }
        
        self.upperCupView.hidden = NO;
        
        [UIView commitAnimations];
    }
    [self performSelector:@selector(overturnDone) withObject:nil afterDelay:0.03f];
    
    self.moving = YES;
}

- (void)overturnDone{
    self.cup.overturn = !(self.cup.overturn);
    self.moving = NO;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
