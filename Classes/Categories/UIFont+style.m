//
//  UIFont+style.m
//  lksdfjlk
//
//  Created by Weifeng on 16/7/11.
//  Copyright © 2016年 Weifeng. All rights reserved.
//

#import "UIFont+style.h"

@implementation UIFont (style)

- (BOOL)isBold
{
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
}

- (BOOL)isItalic
{
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
}

- (CGFloat)fontWeight
{
    NSDictionary *traits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    return [traits[UIFontWeightTrait] floatValue];
}

- (UIFont *)fontWithBold
{
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.pointSize];
}

- (UIFont *)fontWithItalic
{
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)fontWithBoldItalic
{
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold|UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)fontWithNormal
{
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:0];
    
    if ([descriptor.postscriptName rangeOfString:@"PingFangSC"].location != NSNotFound)
    {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:self.pointSize];
    }
    return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
}

+ (void)debugDescriptAllSystemFonts
{
#if DEBUG
    NSArray *families = [UIFont familyNames];
    
    for (NSString *familyname in families)
    {
        NSArray *fontnames = [UIFont fontNamesForFamilyName:familyname];
        NSLog(@"%@", [fontnames debugDescription]);
    }
#endif

}



@end
