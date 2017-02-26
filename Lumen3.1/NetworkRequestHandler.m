//
//  NetworkRequestHandler.m
//  
//
//  Created by Preston Perriott on 1/24/17.
//
//

#import "AFNetworking.h"
#import "NetworkRequestHandler.h"
#import "Networks.h"

@implementation NetworkRequestHandler
+(NetworkRequestHandler*)sharedHandler{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
-(void)GetNetworks{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:[NSString stringWithFormat:@"https://jsonplaceholder.typicode.com/users"] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject){
        
        //Checks if JSOn is array or dictionary
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSLog(@"Array : %@", responseObject);
            
            NSMutableArray *networksArray = [NSMutableArray new];
            for (NSArray *dataObject in responseObject) {
                
                Networks *network = [[Networks alloc]initWithJson:dataObject];
                [networksArray addObject:network];
            }
            if ([_delegate respondsToSelector:@selector(requestHandler:didGetNetworks:)]) [_delegate requestHandler:self didGetNetworks:networksArray];
            
        }else if ([responseObject isKindOfClass:[NSDictionary class]]){
            
            
            NSLog(@"Dictionary : %@", responseObject);
        
        }
        
    }failure:^(NSURLSessionTask *task, NSError *error){
        NSLog(@"The error is : %@", error);}];
    
    
    
    
  /*  [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:@"https://jsonplaceholder.typicode.com/comments"] completionHandler:^(NSData * _Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error){
        
        NSLog(@"Data Task With URL : %@", data);
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Data into String : %@", myString);
        
        
        if (data == nil) {
            NSLog(@"Data is nil");
            //[self GetNetworks];
            return ;
        }
        if (error) {
            if ([_delegate respondsToSelector:@selector(requestHandler:didNotGetNetworksWithErr:)])
                [_delegate requestHandler:self didNotGetNetworksWithErr:[[NSError alloc]initWithDomain:@"error.eh.api" code:9 userInfo:@{
                                                                                                    NSLocalizedDescriptionKey :
                                                                                                                                             @"Network connection not found",
                                                                                                                                         }] ];
        }
                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"JSON Dicitinoary OBj with data: %@", json);
        
        
            if (error) {
                if ([_delegate respondsToSelector:@selector(requestHandler:didNotGetNetworksWithErr:)]) [_delegate requestHandler:self didNotGetNetworksWithErr:[[NSError alloc] initWithDomain:@"error.eh.api" code:9 userInfo:@{
                                                                                                                                                                                                                                       NSLocalizedDescriptionKey : @"JSON could not decrypt",
                                                                                                                                                                                                                                       }]];}
            NSMutableArray *networksArray = [NSMutableArray new];
            for (NSArray *dataObject in json) {
                
                Networks *network = [[Networks alloc]initWithJson:dataObject];
                [networksArray addObject:network];
            }
            if ([_delegate respondsToSelector:@selector(requestHandler:didGetNetworks:)]) [_delegate requestHandler:self didGetNetworks:networksArray];} ] resume];

        
    */    
    }
      
      
@end
