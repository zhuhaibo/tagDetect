//
//  NSString+TagDetect.m
//  TagDetection
//
//  Created by zidane on 16/6/23.
//  Copyright © 2016年 Ants. All rights reserved.
//

#import "NSString+TagDetect.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSString (TagDetect)
- (NSMutableAttributedString*)convertStr:(NSString*)str {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange firstRange = NSMakeRange(0, 0), secondRange = NSMakeRange(0, 0);
    do {
        firstRange = [str rangeOfString:@"#" options:NSLiteralSearch range:NSMakeRange(secondRange.location, str.length - NSMaxRange(secondRange))];
        if (firstRange.location != NSNotFound) {
            NSRange temRange = NSMakeRange(0, 0), temRange2 = NSMakeRange(0, 0), temRange3 = NSMakeRange(0, 0);
            temRange = [str rangeOfString:@" " options:NSLiteralSearch range:NSMakeRange(NSMaxRange(firstRange), str.length - NSMaxRange(firstRange))];
            if (temRange.location == firstRange.location + 1) {
                if (str.length == NSMaxRange(temRange)) {
                    firstRange.location = NSNotFound;
                }
                secondRange = temRange;
                continue;
            }
            if (temRange.location != NSNotFound) {
                // 在firstRange 和 temRange之间查找
                temRange2 = [str rangeOfString:@"#" options:NSLiteralSearch range:NSMakeRange(NSMaxRange(firstRange), temRange.location - NSMaxRange(firstRange))];
                temRange3 = [str rangeOfString:@"#" options:NSLiteralSearch | NSBackwardsSearch range:NSMakeRange(NSMaxRange(firstRange), temRange.location - NSMaxRange(firstRange))];
                if (temRange3.location != NSNotFound && temRange3.location > temRange2.location && temRange.location > temRange3.location && temRange.location != NSMaxRange(temRange3)) {
                    //  ###abc' '
                    firstRange = temRange3;
                    // tag detected
                }else if (temRange2.location != NSNotFound && temRange2.location > firstRange.location && temRange.location > temRange2.location && temRange.location > temRange3.location && temRange.location != NSMaxRange(temRange3)) {
                    // ##abc' '#
                    firstRange = temRange2;
                    // tag detected
                }else if (temRange2.location == temRange3.location && temRange2.location + 1 != temRange.location) {
                    firstRange = firstRange;
                    // tag detected
                }else if (temRange2.location > firstRange.location && temRange.location > temRange2.location && temRange3.location > temRange.location && temRange.location != NSMaxRange(temRange3)) {
                    // ###abc' '#
                    firstRange = [str rangeOfString:@"#" options:NSLiteralSearch | NSBackwardsSearch range:NSMakeRange(NSMaxRange(firstRange), (temRange.location - firstRange.location))];
                }else {
                    secondRange = temRange;
                    continue;
                }
                secondRange = temRange;
                // 改变 NSMutableAttributedString2
                [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(firstRange.location, secondRange.location - firstRange.location)];
            }else {
                firstRange.location = NSNotFound;
            }
        }
    } while (firstRange.location != NSNotFound);
    return attStr;
}

@end
