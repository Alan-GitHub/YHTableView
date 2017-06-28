//
//  YHTableView.m
//  YHTableView
//
//  Created by Alan.Turing on 17/6/15.
//  Copyright © 2017年 Alan.Turing. All rights reserved.
//

#import "YHTableView.h"

#define sectionIndex 0
#define ID @"CELL"

@implementation YHTableView

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor redColor];
        self.secNumInTableView = 1;
        self.contentWidth = ScreenWidth;
        self.contentHeight = 0;
        self.firstCreate = true;
        self.topCell = 0;
        self.buttomCell = 0;
        self.visibleCells = [NSMutableArray array];
        self.reusedCells = [NSMutableDictionary dictionary];
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] init];
        [panGesture addTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];
        

//        YHCellNode* node0 = [[YHCellNode alloc] init];
//        [self.reusedCells setValue:node0 forKey:@"ID"];
//        
//        YHCellNode* iterater = [self.reusedCells valueForKey:@"ID"];
//        
//        NSLog(@"iterater = %@", iterater);
//        for (NSUInteger i = 0; i < 3; i++) {
//            YHCellNode* node = [[YHCellNode alloc] init];
//            iterater.pointer = node;
//            iterater = iterater.pointer;
//        }
//        
//        YHCellNode* iterater0 = [self.reusedCells valueForKey:@"ID"];
//        while (iterater0 != nil) {
//            NSLog(@"%@", iterater0);
//            iterater0 = iterater0.pointer;
//        }
//        
//        NSLog(@"Remove the first...");
//        YHCellNode* iterater1 = [self.reusedCells valueForKey:@"ID"];
//        [self.reusedCells setValue:iterater1.pointer forKey:@"ID"];
//        YHCellNode* iterater2 = [self.reusedCells valueForKey:@"ID"];
//        while (iterater2 != nil) {
//            NSLog(@"%@", iterater2);
//            iterater2 = iterater2.pointer;
//        }
    }
    
    return self;
}

- (void) handlePanGesture:(UIPanGestureRecognizer*) panGesture
{
    if(panGesture.state == UIGestureRecognizerStateBegan)
    {
        self.prevOrigin = self.bounds.origin;
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGesture translationInView:self];
        
        CGFloat newOriginX = self.prevOrigin.x;
        CGFloat newOriginY = self.prevOrigin.y - point.y;
        
        [self dynAddRemoveCell:newOriginY];
        
        [UIView animateWithDuration:0.75 animations:^{
            CGRect rect = self.bounds;
            rect.origin = CGPointMake(newOriginX, newOriginY);
            self.bounds = rect;
        }];
        
//        [panGesture setTranslation:CGPointZero inView:self];
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [panGesture translationInView:self];
        
        CGFloat newOriginX = self.prevOrigin.x;
        CGFloat newOriginY = self.prevOrigin.y - point.y;
        
        if (newOriginY < 0 || self.contentHeight < ScreenHeight) {
            newOriginY = 0;
        } else if (newOriginY > (self.contentHeight - ScreenHeight)) {   //up drag and contentHeight > screenHeight
            newOriginY = self.contentHeight - ScreenHeight;
        }
  
        [UIView animateWithDuration:0.75 animations:^{
            CGRect rect = self.bounds;
            rect.origin = CGPointMake(newOriginX, newOriginY);
            self.bounds = rect;
        }];
    }
}

- (void) dynAddRemoveCell:(CGFloat) originY
{
    YHCellNode* firstNodeTableView = nil;
    YHCellNode* lastNodeInTableView = nil;
    YHCellNode* iterater = [self.reusedCells valueForKey:ID];
    
    NSLog(@"visiblecell=%zd", self.visibleCells.count);
    NSLog(@"self.topcell=%zd", self.topCell);
    NSLog(@"self.buttomcell=%zd", self.buttomCell);
    
    for (NSUInteger i = 0; i < self.visibleCells.count; i++) {
        if (firstNodeTableView != nil && lastNodeInTableView != nil)
            break;
        
        if (self.topCell == self.visibleCells[i].cell.cellIndex) {
            NSLog(@"top top");
            firstNodeTableView = self.visibleCells[i];
        }
        
        if (self.buttomCell == self.visibleCells[i].cell.cellIndex) {
            lastNodeInTableView = self.visibleCells[i];
        }
    }
    
    NSLog(@"firstNodeTableView.cellindex=%zd", firstNodeTableView.cell.cellIndex);
    NSLog(@"lastNodeInTableView.cellindex=%zd", lastNodeInTableView.cell.cellIndex);
    
    if (originY > firstNodeTableView.cell.cellDownEdge) {
        NSLog(@"remove cell for top");
        self.topCell = firstNodeTableView.cell.cellIndex + 1;
        [firstNodeTableView.cell removeFromSuperview];
        
        [self.reusedCells setValue:firstNodeTableView forKey:ID];
        firstNodeTableView.pointer = iterater;
        
        [self.visibleCells removeObject:firstNodeTableView];
    }
    
    else if(originY < firstNodeTableView.cell.cellUpEdge && originY > 0)
    {
        YHCellNode* node = [self.reusedCells valueForKey:ID];
        
        if (node == nil) {
            NSLog(@"add cell for top");
            node = [[YHCellNode alloc] init];
        }
 
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.topCell - 1) inSection:sectionIndex];
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            node.cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        node.cell.cellIndex = self.topCell - 1;
        node.cell.cellDownEdge = firstNodeTableView.cell.cellUpEdge;
        node.cell.cellUpEdge = node.cell.cellDownEdge - node.cell.cellHeight;
        self.topCell = node.cell.cellIndex;
        
        node.cell.frame = CGRectMake(0, node.cell.cellUpEdge, ScreenWidth, node.cell.cellHeight);
        [self addSubview:node.cell];
        
        [self.reusedCells setValue:node.pointer forKey:ID];
        
        [self.visibleCells addObject:node];
    }
    
    YHCellNode* iterater1 = [self.reusedCells valueForKey:ID];
    
    if (originY + ScreenHeight < lastNodeInTableView.cell.cellUpEdge) {
        NSLog(@"remove cell for buttom");
        self.buttomCell = lastNodeInTableView.cell.cellIndex - 1;
        [lastNodeInTableView.cell removeFromSuperview];
        
        [self.reusedCells setValue:lastNodeInTableView forKey:ID];
        lastNodeInTableView.pointer = iterater1;
        
        [self.visibleCells removeObject:lastNodeInTableView];
    }
    else if(originY + ScreenHeight > lastNodeInTableView.cell.cellDownEdge && lastNodeInTableView.cell.cellIndex < self.rowNumInSection)
    {
        YHCellNode* node = [self.reusedCells valueForKey:ID];
        
        if (node == nil) {
            NSLog(@"add cell for buttom");
            node = [[YHCellNode alloc] init];
        }
        
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.buttomCell + 1) inSection:sectionIndex];
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            node.cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        node.cell.cellIndex = self.buttomCell + 1;
        node.cell.cellUpEdge = lastNodeInTableView.cell.cellDownEdge;
        node.cell.cellDownEdge = node.cell.cellUpEdge + node.cell.cellHeight;
        self.buttomCell = node.cell.cellIndex;
        
        node.cell.frame = CGRectMake(0, node.cell.cellUpEdge, ScreenWidth, node.cell.cellHeight);
        [self addSubview:node];
        
        [self.visibleCells addObject:node];
        [self.reusedCells setValue:node.pointer forKey:ID];
    }
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    if(self.dataSource)
       [self executeDataSourceMethod];
    
    if(self.delegate)
       [self executeDelegateMethod];

    if (self.firstCreate) {
        self.firstCreate = false;
        [self createCell];
    }
    
}

- (void) executeDataSourceMethod
{
    self.secNumInTableView = [self.dataSource numberOfSectionsInTableView:self];  //default is 1
    self.rowNumInSection = [self.dataSource tableView:self numberOfRowsInSection:sectionIndex];
}

- (void) executeDelegateMethod
{    
    
}

- (void) createCell
{
    //NSInteger needCreateRowNum;
//    CGFloat visibleTableHeightCurrent = 0;  //it's Y value is cell bottom.
    
    NSInteger i = 0;
        
    for (; (i < self.rowNumInSection) && (self.contentHeight < ScreenHeight); i++) { //row number in section
//    for (; i < self.rowNumInSection; i++) {
    
        YHCellNode* node = [[YHCellNode alloc] init];
        
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            node.cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        node.cell.cellIndex = i;
        node.cell.cellUpEdge = self.contentHeight;
        node.cell.cellDownEdge = node.cell.cellUpEdge + node.cell.cellHeight;
        
        node.cell.frame = CGRectMake(0, node.cell.cellUpEdge, ScreenWidth, node.cell.cellHeight);
        [self addSubview:node.cell];
        
        [self.visibleCells addObject:node];
    
        self.contentHeight += node.cell.cellHeight;
    }
    
    self.buttomCell = i - 1;
    
}

@end
