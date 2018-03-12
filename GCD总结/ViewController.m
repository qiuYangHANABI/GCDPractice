//
//  ViewController.m
//  GCD总结
//
//  Created by 黄秋阳 on 2017/4/5.
//  Copyright © 2017年 黄秋阳. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//DISPATCH_QUEUE_CONCURRENT 并发
//
//DISPATCH_QUEUE_SERIAL 串行

#pragma -- GCD 单例

- (void)once{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //这里的内容程序开始到结束只执行一次
    });
}

#pragma -- GCD 串行同步／异步

- (void)serial{
    
    //创建串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("串行队列", DISPATCH_QUEUE_SERIAL);
//获取主队列 -- 系统创建的串行队列
//    dispatch_queue_t serialQueue = dispatch_get_main_queue();
    
    dispatch_sync(serialQueue, ^{
       
        //以同步方式在串行队列中添加任务并执行
    });
    
    dispatch_async(serialQueue, ^{
       
        //以异步方式在串行队列中添加任务并执行
    });
    
}

#pragma -- GCD 并发同步／异步

- (void)concurrent{
    
    //创建并发队列
    dispatch_queue_t concurrent = dispatch_queue_create("并发队列 ", DISPATCH_QUEUE_CONCURRENT);
//获取全局队列 -- 系统创建的并发队列
//    dispatch_queue_t concurrent = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(concurrent, ^{
       
        //以同步的方式在并发队列中添加任务并执行
    });
    
    dispatch_async(concurrent, ^{
       
        //以异步的方式在并发队列中添加任务并执行
    });
}

#pragma -- GCD 队列组

- (void)group{
    
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    //获取全局队列（优先级，0）
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
       
        //异步操作1
    });
    
    dispatch_group_async(group, queue, ^{
       
        //异步操作2
    });
    
    dispatch_group_notify(group, queue, ^{
       
        //在上述异步操作结束后的操作
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //回到主线程执行
        });
    });
}

#pragma -- GCD 延时执行

- (void)delay{
    
    //发送消息
//    [self performSelector:@selector(test) withObject:nil afterDelay:4.0];
    
    //NSTimer
//    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(test) userInfo:nil repeats:NO];
    
    //GCD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"延时执行 -- test");
    });
    
}

- (void)test{
    
    NSLog(@"延时执行 -- test");
}

#pragma -- GCD barrier

- (void)barrier{
    
    dispatch_queue_t barrierQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(barrierQueue, ^{
       
        NSLog(@"异步操作1");
    });
    
    dispatch_async(barrierQueue, ^{
        
        NSLog(@"异步操作2");
    });
    
    dispatch_barrier_async(barrierQueue, ^{
        
        NSLog(@"barrier");
    });
    
    dispatch_async(barrierQueue, ^{
        
        NSLog(@"异步操作3");
    });
    
    dispatch_async(barrierQueue, ^{
       
        NSLog(@"异步操作4");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
