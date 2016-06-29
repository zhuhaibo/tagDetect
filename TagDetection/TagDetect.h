//
//  TagDetect.h
//  TagDetection
//
//  Created by zidane on 16/6/23.
//  Copyright © 2016年 Ants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagDetect : NSString
@property (nonatomic, strong, readonly) NSMutableArray *tagRangeArray;
- (NSMutableAttributedString*)convertStr:(NSString*)str;
@end
