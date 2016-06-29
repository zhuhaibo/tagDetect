//
//  TagDetect.m
//  TagDetection
//
//  Created by zidane on 16/6/23.
//  Copyright © 2016年 Ants. All rights reserved.
//

#import "TagDetect.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface TagDetect()
@property (nonatomic, strong) NSMutableArray *tagRangeArray;
@end

@implementation TagDetect
@dynamic tagRangeArray;
- (void)setTagRangeArray:(NSMutableArray *)tagRangeArray {
    objc_setAssociatedObject(self, _cmd, tagRangeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)tagRangeArray {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMutableAttributedString*)convertStr:(NSString*)str {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    if (nil == self.tagRangeArray) {
        self.tagRangeArray = @[].mutableCopy;
    }
    
    NSMutableArray *tagArr = @[].mutableCopy;
    NSRange firstRange = NSMakeRange(0, 0), secondRange = NSMakeRange(0, 0);
    do {
        firstRange = [str rangeOfString:@"#" options:NSLiteralSearch range:NSMakeRange(secondRange.location, str.length - (secondRange.length + secondRange.location))];
        if (firstRange.location != NSNotFound) {
            NSRange temRange = NSMakeRange(0, 0), temRange2 = NSMakeRange(0, 0);
            temRange = [str rangeOfString:@" " options:NSLiteralSearch range:NSMakeRange(firstRange.location + firstRange.length, str.length - (firstRange.length + firstRange.location))];
            if (temRange.location == firstRange.location + 1) {
                firstRange.location = NSNotFound;
                continue;
            }
            temRange2 = [str rangeOfString:@"#" options:NSLiteralSearch range:NSMakeRange(firstRange.location + firstRange.length, str.length - (firstRange.length + firstRange.location))];
            if (temRange.location != NSNotFound && (temRange2.location > temRange.location || temRange2.location == NSNotFound)) {
                secondRange = temRange;
                [tagArr addObject:[str substringWithRange:NSMakeRange(firstRange.location, secondRange.location - firstRange.location + 1)]];
                // 改变 NSMutableAttributedString23
                [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(firstRange.location, secondRange.location - firstRange.location + 1)];
                // 标签range保存
                [self.tagRangeArray enumerateObjectsUsingBlock:^(NSString *rangStr, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([rangStr isEqualToString:NSStringFromRange(NSMakeRange(firstRange.location, secondRange.location - firstRange.location + 1))]) {
                        *stop = TRUE;
                        return;
                    }
                    if (idx == self.tagRangeArray.count - 1) {
                        [self.tagRangeArray addObject:NSStringFromRange(NSMakeRange(firstRange.location, secondRange.location - firstRange.location + 1))];
                        *stop = YES;
                        return;
                    }
                }];
                if (self.tagRangeArray.count == 0) {
                    [self.tagRangeArray addObject:NSStringFromRange(NSMakeRange(firstRange.location, secondRange.location - firstRange.location + 1))];
                }
            }else if (temRange2.location < secondRange.location) {
                continue;
            }else {
                firstRange.location = NSNotFound;
            }
        }
    } while (firstRange.location != NSNotFound);
    return attStr;
}

@end
