//
//  AFNTestController.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/6/13.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "AFNTestController.h"
#import <AFNetworking.h>

@interface AFNTestController ()

@end

@implementation AFNTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"AFN";
    
//    NSURLSessionConfiguration *config = [[NSURLSessionConfiguration alloc] init];
    
//    AFHTTPSessionManager *manage = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //text/html
    
    AFNetworkReachabilityManager *asdf = [AFNetworkReachabilityManager manager];
    [asdf setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%d",status);
    }];
    [asdf startMonitoring];
//    switch (asdf.networkReachabilityStatus) {
//        case AFNetworkReachabilityStatusUnknown:
//            NSLog(@"AFNetworkReachabilityStatusUnknown");
//            break;
//        case AFNetworkReachabilityStatusNotReachable:
//            NSLog(@"AFNetworkReachabilityStatusNotReachable");
//            break;
//        case AFNetworkReachabilityStatusReachableViaWWAN:
//            NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
//            break;
//        case AFNetworkReachabilityStatusReachableViaWiFi:
//            NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
//            break;
//
//        default:
//            break;
//    }
//    NSLog(@"%d",asdf.networkReachabilityStatus);
    
    
    AFHTTPSessionManager *managasde = [AFHTTPSessionManager manager];
    
    managasde.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    
    [managasde POST:@"https://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
