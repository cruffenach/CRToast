//
//  DeviceFamily.h
//  CountdownPro
//
//  Created by Mohammad Zulqarnain on 17/10/2019.
//  Copyright © 2019 Apps Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceFamily : NSObject
    + (NSString *)family;
    + (BOOL *)isIphoneX;
@end

NS_ASSUME_NONNULL_END
