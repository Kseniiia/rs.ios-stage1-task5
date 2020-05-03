#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    NSDictionary *countries = @{
        @"998": @[@"UZ", @"998", @9],
        @"996": @[@"KG", @"996", @9],
        @"994": @[@"AZ", @"994", @9],
        @"993": @[@"TM", @"993", @8],
        @"992": @[@"TJ", @"992", @9],
        @"380": @[@"UA", @"380", @9],
        @"375": @[@"BY", @"375", @9],
        @"374": @[@"AM", @"374", @8],
        @"373": @[@"MD", @"373", @8],
        @"77" : @[@"KZ", @"7", @10],
        @"7"  : @[@"RU", @"7", @10]
    };
    
    NSString *country = [[NSString alloc] init];
    NSString *code = [[NSString alloc] init];
    NSNumber *numberLen = [[NSNumber alloc] init];
    NSString *newString = [[NSString alloc] initWithString:string];
    
    newString = [newString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    for (id key in countries) {
        NSUInteger len = [key length];
        if ([newString length] >= len && [[newString substringToIndex:len] isEqualToString:key]) {
            country = [countries objectForKey:key][0];
            code = [countries objectForKey:key][1];
            numberLen = [countries objectForKey:key][2];
        }
    }
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    if ([code isEqualToString:@""]) {
        [str appendString:@"+"];
        if ([newString length] > 12) {
            [str appendString:[newString substringToIndex:12]];
        } else {
            [str appendString:newString];
        }
    } else {
        NSUInteger len;
        
        if ([newString length] > 12) {
            len = [code length] + [numberLen intValue];
        } else {
            len = [newString length];
        }
        
        [str appendString:@"+"];
        [str appendString:code];
        
        NSArray *arr = [[NSArray alloc] init];
        if ([numberLen isEqualToNumber:@8]) {
            arr = @[@[@0, @" ("], @[@2, @") "], @[@5, @"-"]];
        } else if ([numberLen isEqualToNumber:@9]) {
            arr = @[@[@0, @" ("], @[@2, @") "], @[@5, @"-"], @[@7, @"-"]];
        } else if ([numberLen isEqualToNumber:@10]) {
            arr = @[@[@0, @" ("], @[@3, @") "], @[@6, @"-"], @[@8, @"-"], @[@10, @"-"]];
        }
        
        for (int i = 0; i < len - [code length]; i++) {
            for (int j = 0; j < [arr count]; j++) {
                if (i == [[[arr objectAtIndex:j] objectAtIndex:0] intValue]) {
                    [str appendString:[[arr objectAtIndex:j] objectAtIndex:1]];
                }
            }
            [str appendString:[newString substringWithRange:NSMakeRange([code length] + i, 1)]];
        }
    }
    
    return @{KeyPhoneNumber: str,
             KeyCountry: country};
}
@end
