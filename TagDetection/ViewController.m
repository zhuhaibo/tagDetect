//
//  ViewController.m
//  TagDetection
//
//  Created by zidane on 16/6/22.
//  Copyright © 2016年 Ants. All rights reserved.
//

#import "ViewController.h"
#import "NSString+TagDetect.h"

@interface ViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSMutableArray *tagRangeArray;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _tagRangeArray = @[].mutableCopy;
    NSString *str = @"sfkjaslk";
    [str convertStr:str];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    textView.attributedText = [textView.text convertStr:textView.text];
}

@end
