//
//  YHCellNode.h
//  YHTableView
//
//  Created by Alan.Turing on 17/6/27.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHTableViewCell.h"

@interface YHCellNode : UIView
@property(nonatomic, retain) YHTableViewCell* cell;
@property(nonatomic, retain) YHCellNode* pointer;
@end
