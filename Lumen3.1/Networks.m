//
//  Networks.m
//  Lumen3.0
//
//  Created by Preston Perriott on 1/24/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import "Networks.h"

@implementation Networks
-(instancetype)initWithJson:(NSArray*)json{
    self =[super init];
    if (self) {
        //Because were using a json place holder key is city & city
        _SSID = [json valueForKey:@"name"];
        _RSSI = [json valueForKey:@"email"];
    }
    return self;
}
@end
