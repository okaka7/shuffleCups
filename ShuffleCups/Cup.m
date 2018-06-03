//
//  Cup.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "Cup.h"

@implementation Cup

- (id)initWithColor:(int)color position:(int)position
{
    self = [super init];
    if(self){
        
        self.color = color;
        self.position = position;
        self.overturn = NO;
    }
    
    return self;
}


@end
