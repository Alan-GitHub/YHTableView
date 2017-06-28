//
//  YHTableViewCell.m
//  YHTableView
//
//  Created by Alan.Turing on 17/6/16.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import "YHTableViewCell.h"

@implementation YHTableViewCell

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor greenColor];
        self.cellHeight = 40;
        self.layer.borderWidth = 1;
        self.layer. borderColor = [[UIColor blackColor] CGColor];
    }

    return self;
}

@end
