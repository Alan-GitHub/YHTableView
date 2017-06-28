//
//  YHCellNode.m
//  YHTableView
//
//  Created by Alan.Turing on 17/6/27.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import "YHCellNode.h"

@implementation YHCellNode

- (instancetype) init
{
    self = [super init];
    if (self != nil) {
        self.pointer = nil;
        self.cell = [[YHTableViewCell alloc] init];
    }
    
    return self;
}

//- (void) description
//{
//    [super description];
//    NSLog(@"text = %@", self.text);
//}
@end
