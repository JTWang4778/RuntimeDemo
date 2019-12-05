//
//  AFNTestController.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/6/13.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "AFNTestController.h"
#import <AFNetworking.h>

int isPrime(int n){
    for (int i = 2; i <= sqrt(n); i++) {
        if (n % i == 0) {
            return 0;
        }
    }
    return 1;
}

void cMethod(){
//    printf(isPrime(2));
    
    printf("呵呵呵呵呵");
}

@interface AFNTestController ()

@end

@implementation AFNTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"AFN";
//    NSObject *obj = [[NSObject alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @synchronized(obj) {
//            NSLog(@"需要线程同步的操作1 开始");
//            sleep(3);
//            NSLog(@"需要线程同步的操作1 结束");
//        }
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        @synchronized(obj) {
//            NSLog(@"需要线程同步的操作2");
//        }
//    });
    
//    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
//
//    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_wait(signal, overTime);
//        NSLog(@"需要线程同步的操作1 开始");
//        sleep(2);
//        NSLog(@"需要线程同步的操作1 结束");
//        dispatch_semaphore_signal(signal);
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        dispatch_semaphore_wait(signal, overTime);
//        NSLog(@"需要线程同步的操作2");
//        dispatch_semaphore_signal(signal);
//    });
    
    cMethod();
    
}

- (void)testDispatchGroup{
    // dispatch_group 测试
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("asdf", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        NSLog(@"1111111%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"22222222%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"3333333%@",[NSThread currentThread]);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"下载完成");
    });
}


- (void)testAFN{
    NSURLSessionConfiguration *config = [[NSURLSessionConfiguration alloc] init];
    
    AFHTTPSessionManager *manage = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //    text/html
    
    AFNetworkReachabilityManager *asdf = [AFNetworkReachabilityManager manager];
    [asdf setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%d",status);
    }];
    [asdf startMonitoring];
    
    NSLog(@"新增代码");
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
    
    
    AFHTTPSessionManager *managasde = [AFHTTPSessionManager manager];
    
    managasde.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    
    [managasde POST:@"https://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    NSLog(@"devBranchTest");
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
