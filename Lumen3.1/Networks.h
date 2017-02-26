//
//  Networks.h
//  Lumen3.0
//
//  Created by Preston Perriott on 1/24/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networks : NSObject
@property (nonatomic, strong)NSString *SSID;
@property (strong, nonatomic)NSString *RSSI;
- (instancetype)initWithJson:(NSArray*)json;


@end
