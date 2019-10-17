//
//  DeviceFamily.m
//  CountdownPro
//
//  Created by Mohammad Zulqarnain on 17/10/2019.
//  Copyright © 2019 Apps Beyond. All rights reserved.
//

#import "DeviceFamily.h"

@import UIKit;

@interface DeviceFamily ()

@property(nonatomic, strong, readonly) NSString *family;

@end

@implementation DeviceFamily

@synthesize family = _family;

#pragma mark - Public methods

+ (NSString *)family {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (@available(iOS 8.0, *)) {
            switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                case 1136:
                    return @"iPhone 5 or 5S or 5C";
                    
                case 1334:
                    return @"iPhone 6/6S/7/8";
                    break;
                    
                case 1920:
                    return @"iPhone 6+/6S+/7+/8+";
                    
                case 2208:
                    return @"iPhone 6+/6S+/7+/8+";
                    
                case 2436:
                    return @"iPhone X/XS/11 Pro";
                    
                case 2688:
                    return @"iPhone XS Max/11 Pro Max";
                    
                case 1792:
                    return @"iPhone XR/ 11";
                    
                default:
                    return @"Unkown";
            }
        } else {
            // Fallback on earlier versions
        }
    }
    return @"iPad";
}

+ (BOOL *)isIphoneX {
    return ([[self family]  isEqual: @"iPhone X/XS/11 Pro"]) || ([[self family]  isEqual: @"iPhone XS Max/11 Pro Max"]) || ([[self family]  isEqual: @"iPhone XR/ 11"]);
}

@end
