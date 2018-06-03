//
//  Ball.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "Ball.h"

@implementation Ball

- (id)initWithColor:(int)color position:(int)position speed:(float)speed
{
    self = [super init];
    if(self){
        
        self.color = color;
        self.position = position;
        self.speed = speed;
    }
    
    return self;
}

@end
