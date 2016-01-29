//
//  XFDrowView.m
//  XFTouchTracker
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "XFDrowView.h"
#import "XFLine.h"

@interface XFDrowView()
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic,strong) NSMutableArray *finishedLines;

@end

@implementation XFDrowView

/**
 *  覆盖初始化方法
 *
 *  @param frame frame初始化值
 *
 *  @return 新建对象
 */
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [NSMutableArray new];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

-(void) strokeLine:(XFLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

-(void) drawRect:(CGRect)rect
{
    // 用黑色绘制已经完成的线条
    [[UIColor blackColor] set];
    for (XFLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    // 使用红色绘制正在画的线条
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];

    }
}


// 开始点击
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 输出日志，查看触摸时间发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        // 根据触摸位置来创建XFLine对象
        CGPoint location = [t locationInView:self];
        XFLine *line = [[XFLine alloc] init];
        line.begin = location;
        line.end = location;
        
        
        // 将线条放入字典中保存，需要将touch对象的内存地址封如NSValue中作为key，因为整个过程touch对象一直是同一个
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    // 驱动屏幕绘制
    [self setNeedsDisplay];
}

// 移动
- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 输出日志，查看触摸时间发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        // 取出此touch对应的line
        XFLine *line = self.linesInProgress[[NSValue valueWithNonretainedObject:t]];
        line.end = location;
    }
    
    [self setNeedsDisplay];
}

// 触摸结束
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 输出日志，查看触摸时间发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        // 取出此touch对应的line
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        XFLine *line = self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }

    [self setNeedsDisplay];
}

//// 触摸结束
//- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    // 指针指向已经结束的触摸对象
//    UITouch *touch = [touches anyObject];
//    
//    // 触摸结束时的位置（使用当前UIControl对象的坐标系）
//    CGPoint touchLocation = [touch locationInView:self];
//    
//    // 判断结束时候是否在控件的bonds范围内
//    if (CGRectContainsPoint(self.bounds, touchLocation)) {
//        // 向所有注册了UIControlEventTouchUpInside事件的对象发送动作消息
//        [self sendActionsForControlEvents: UIControlEventTouchUpInside];
//    }else{
//        // 触摸事件发生在bounds区域外，则向所有注册了UIControlEventTouchUpOutside事件的所有对象发送动作消息
//        [self sendActionsForControlEvents: UIControlEventTouchOutInside];
//    }
//}


// 触摸取消事件，当外部打断当前触摸行为的时候（如电话接入等），需要将正在touch的事件全部取消。
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 输出日志，查看触摸时间发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
    
}

@end
