//
//  NetworkRequestHandler.h
//  
//
//  Created by Preston Perriott on 1/24/17.
//
//

#import <Foundation/Foundation.h>
@class Networks, NetworkRequestHandler;
@protocol NetworkRequestHandlerDelegate <NSObject>

@optional
-(void)requestHandler:(NetworkRequestHandler*)request didGetNetworks:(NSArray <Networks*>*)networks;

-(void)requestHandler:(NetworkRequestHandler *)request didNotGetNetworksWithErr:(NSError*)error;

@end

@interface NetworkRequestHandler : NSObject
@property (nonatomic,retain) id<NetworkRequestHandlerDelegate> delegate;

+(NetworkRequestHandler*)sharedHandler;
-(void)GetNetworks;
@end
