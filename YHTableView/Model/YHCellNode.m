//
//  YHCellNode.m
//  YHTableView
//
//  Created by Alan.Turing on 17/6/27.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import "YHCellNode.h"

static NSUInteger NodeCreateCounter = 0;

@implementation YHCellNode

- (instancetype) init
{
    NodeCreateCounter++;
    
//    NSLog(@"NodeCreateCounter = %zd", NodeCreateCounter);
    
    self = [super init];
    if (self != nil) {
        self.pointer = nil;
        self.cell = [[YHTableViewCell alloc] init];
        self.cell.cellNodePointer = self;
    }
    
    return self;
}

//- (void) description
//{
//    [super description];
//    NSLog(@"text = %@", self.text);
//}
@end
