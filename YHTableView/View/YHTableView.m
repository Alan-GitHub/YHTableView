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
    YHTableViewCell* firstCellInTableView = nil;
    YHTableViewCell* lastCellInTableView = nil;
    
    for (NSUInteger i = 0; i < self.visibleCells.count; i++) {
        if (firstCellInTableView != nil && lastCellInTableView != nil)
            break;
        
        if (self.topCell == self.visibleCells[i].cellIndex) {
            firstCellInTableView = self.visibleCells[i];
        }
        
        if (self.buttomCell == self.visibleCells[i].cellIndex) {
            lastCellInTableView = self.visibleCells[i];
        }
    }
    
    if (originY > firstCellInTableView.cellDownEdge) {
        self.topCell = firstCellInTableView.cellIndex + 1;
        [firstCellInTableView removeFromSuperview];
        
        [self enqueueReusableCellWithIdentifier:firstCellInTableView.cellNodePointer forKey:ID];
        
        [self.visibleCells removeObject:firstCellInTableView];
    }
    
    else if(originY < firstCellInTableView.cellUpEdge && originY > 0)
    {
        
        
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.topCell - 1) inSection:sectionIndex];
        
        YHTableViewCell* cell = nil;
        if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
            cell = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        }
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        cell.cellIndex = self.topCell - 1;
        cell.cellDownEdge = firstCellInTableView.cellUpEdge;
        cell.cellUpEdge = cell.cellDownEdge - cell.cellHeight;
        self.topCell = cell.cellIndex;
        
        cell.frame = CGRectMake(0, cell.cellUpEdge, ScreenWidth, cell.cellHeight);
        [self addSubview:cell];
        
        [self.visibleCells addObject:cell];
    }
    
    
    if (originY + ScreenHeight < lastCellInTableView.cellUpEdge) {
        self.buttomCell = lastCellInTableView.cellIndex - 1;
        [lastCellInTableView removeFromSuperview];
        
        [self enqueueReusableCellWithIdentifier:lastCellInTableView.cellNodePointer forKey:ID];
        
        [self.visibleCells removeObject:lastCellInTableView];
    }
    
    else if(originY + ScreenHeight > lastCellInTableView.cellDownEdge && lastCellInTableView.cellIndex < self.rowNumInSection)
    {
        
        //get row height for each
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.buttomCell + 1) inSection:sectionIndex];
        
        YHTableViewCell* cell = nil;
        if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
            cell = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        }
        
        if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
            cell.cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        
        cell.cellIndex = self.buttomCell + 1;
        cell.cellUpEdge = lastCellInTableView.cellDownEdge;
        cell.cellDownEdge = cell.cellUpEdge + cell.cellHeight;
        self.buttomCell = cell.cellIndex;
        
        cell.frame = CGRectMake(0, cell.cellUpEdge, ScreenWidth, cell.cellHeight);
        [self addSubview:cell];
        
        [self.visibleCells addObject:cell];
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
    
//    NSLog(@"layoutSubviews %zd", (NSUInteger)self.bounds.origin.y);
    
    [self dynAddRemoveCell:self.bounds.origin.y];
    
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
        
        [self.visibleCells addObject:node.cell];
    
        self.contentHeight += node.cell.cellHeight;
    }
    
    self.buttomCell = i - 1;
    
}

#pragma mark Maintenance queue. Enqueue and Dequeue
- (YHTableViewCell*) dequeueReusableCellWithIdentifier:(NSString*) identifier
{
    YHCellNode* node = [self.reusedCells valueForKey:identifier];
    
    
    [self.reusedCells setValue:node.pointer forKey:identifier];
    
    return node.cell;
}

- (void) enqueueReusableCellWithIdentifier:(YHCellNode*) node forKey:(NSString*) identifier
{
    node.pointer = [self.reusedCells valueForKey:identifier];
    
    [self.reusedCells setValue:node forKey:identifier];
}

@end
