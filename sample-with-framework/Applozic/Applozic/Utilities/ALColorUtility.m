//
//  ALColorUtility.m
//  Applozic
//
//  Created by Divjyot Singh on 23/11/15.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import "ALColorUtility.h"

@implementation ALColorUtility

+ (UIImage *)imageWithSize:(CGRect)rect WithHexString:(NSString*)stringToConvert {
    
    
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f] CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(NSString *)getAlphabetForProfileImage:(NSString *)actualName
{
    NSString * iconAlphabet = @"";
    NSString * trimmed = [actualName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmed.length == 0)
    {
        return actualName;
    }
    NSString *firstLetter = [trimmed substringToIndex:1];
    NSRange whiteSpaceRange = [trimmed rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *listNames = [trimmed componentsSeparatedByString:@" "];
    
    if (whiteSpaceRange.location != NSNotFound)
    {
        NSString *firstLetter = [[listNames[0] substringToIndex:1] uppercaseString];
        NSString *lastLetter = [[listNames[1] substringToIndex:1] uppercaseString];
        iconAlphabet = [[firstLetter stringByAppendingString:lastLetter] uppercaseString];
    }
    else
    {
        iconAlphabet = [firstLetter uppercaseString];
    }
    
    return iconAlphabet;
}

@end
