//
//  postman.m
//  Login_Demo
//
//  Created by Jenkins on 01/09/16.
//  Copyright © 2016 srinivas. All rights reserved.
//

#import "postman.h"

@implementation postman

{
    AFHTTPSessionManager *manager;
    AFJSONRequestSerializer *requestSerializer;
}

-(id)init
{
    if (self = [super init]) {
        [self initializationMethod];
    }
    return self;
}

-(void)initializationMethod
{
    manager =[AFHTTPSessionManager manager];
    requestSerializer = [AFJSONRequestSerializer serializer];
    [self setheadermethod];
}



- (void)get:(NSString *)URLString withParameters:(NSString *)parameter success:(void(^)(NSURLSessionDataTask *operation,id responseObject))success failure:(void(^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    
    [manager GET:URLString parameters:parameter progress:^(NSProgress *downloadProgress) {
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        failure(task,error);
    }];
}



-(void)post:(NSString *)URLString withParameter:(NSString *)parameter success:(void(^)(NSURLSessionDataTask *operation,id responseObject))sucess
   failour :(void(^)(NSURLSessionDataTask *operation, NSError *error))failour
{
    NSData *data =[parameter dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameterDict =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [manager POST:URLString parameters:parameterDict progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        sucess(task,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failour(task,error);
    }];
}


-(void)setheadermethod
{
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = requestSerializer;
    
}




@end
