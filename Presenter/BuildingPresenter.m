//
//  BuildingPresenter.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "BuildingPresenter.h"
#import "Header.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "BuildingResponse.h"

@implementation BuildingPresenter

- (void)getListBuildingswithParam:(NSDictionary *)params{
    NSString *urlPath = [NSString stringWithFormat:@"%@api/buildings",SERVICE_BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager GET:urlPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *array  = [NSMutableArray new];
        NSError *error;
        array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        NSMutableArray *buildings = [NSMutableArray new];
        for (NSDictionary *dict in array) {
            BuildingResponse *obj = [[BuildingResponse alloc]initWithDictionary:dict error:nil];
            [buildings addObject:obj];
        }
        if ([self.delegate respondsToSelector:@selector(getListBuildingsSuccess:)]) {
            [self.delegate getListBuildingsSuccess:buildings];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(getListBuildingsFail:)]) {
            [self.delegate getListBuildingsFail:error];
        }
    }];
    [dataTask resume];
}

@end
