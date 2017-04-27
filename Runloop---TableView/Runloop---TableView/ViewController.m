//
//  ViewController.m
//  Runloop---TableView
//
//  Created by chenpeng on 2017/4/27.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "ViewController.h"

typedef void(^RunloopBlock)(void);
@interface ViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    UITableView *myTableView;
}

@property (nonatomic, copy) void(^callBackBlock)(void);
@property (nonatomic, strong) NSMutableArray *taskArrary;
@property (nonatomic, assign) NSUInteger maxTask;
@property (nonatomic, strong) NSMutableArray *dataArrary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _taskArrary = [[NSMutableArray alloc] initWithCapacity:0];
    _maxTask = 40;
    [self addObserverRunLoop];
    
    myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 100;
    [self.view addSubview:myTableView];
}

- (UIImageView *)imgLeftImageView{
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"];
    img1.image = [UIImage imageWithContentsOfFile:imgPath];
    img1.layer.cornerRadius = 10;
    img1.layer.masksToBounds = YES;
    return img1;
}

- (UIImageView *)imgCenterImageView{
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 0, 50, 50)];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"];
    img1.image = [UIImage imageWithContentsOfFile:imgPath];
    img1.layer.cornerRadius = 10;
    img1.layer.masksToBounds = YES;
    return img1;
}

- (UIImageView *)imgCenterImageView1{
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 50, 50, 40)];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"];
    img1.image = [UIImage imageWithContentsOfFile:imgPath];
    return img1;
}

- (UIImageView *)imgCenterImageView2{
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 60, 40, 40)];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"];
    img1.image = [UIImage imageWithContentsOfFile:imgPath];
    img1.layer.cornerRadius = 20;
    img1.layer.masksToBounds = YES;
    return img1;
}

- (UIImageView *)imgCenterImageView3{
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 0, 50, 40)];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"];
    img1.image = [UIImage imageWithContentsOfFile:imgPath];
    img1.layer.cornerRadius = 20;
    img1.layer.masksToBounds = YES;
    return img1;
}

- (UIImageView *)imgRightImageView{
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(230, 0, 100, 100)];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"];
    img1.image = [UIImage imageWithContentsOfFile:imgPath];
    img1.layer.cornerRadius = 10;
    img1.layer.masksToBounds = YES;
    return img1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 800;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    for (UIImageView *img in cell.contentView.subviews) {
        [img removeFromSuperview];
    }
//    __weak typeof(self)weakSelf = self;
//    [self addTask:^{
        [cell.contentView addSubview:[self imgLeftImageView]];
//    }];
//    [self addTask:^{
        [cell.contentView addSubview:[self imgCenterImageView]];
//    }];
//    [self addTask:^{
    [cell.contentView addSubview:[self imgCenterImageView1]];
//    }];
//    [self addTask:^{
    [cell.contentView addSubview:[self imgCenterImageView2]];
//    }];
//    [self addTask:^{    
    [cell.contentView addSubview:[self imgCenterImageView3]];
//    }];
//    [self addTask:^{
    [cell.contentView addSubview:[self imgRightImageView]];
//    }];
    
    return cell;
}

- (void)addTask:(RunloopBlock)task{
    //保存任务
    [self.taskArrary addObject:task];
    if (self.taskArrary.count > _maxTask) {
        [self.taskArrary removeObjectAtIndex:0];
    }
}


static void observeCallBack (CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    //从数组里面取出任务
    ViewController *vc = (__bridge ViewController *)info;
    if (vc.taskArrary.count == 0) {
        return;
    }
    void(^task)(void)  = vc.taskArrary.firstObject;
    task();
    [vc.taskArrary removeObjectAtIndex:0];//执行完后，移除
}

- (void)addObserverRunLoop{
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    
    CFRunLoopObserverContext observerContext = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL,
    };
    static CFRunLoopObserverRef loopObserver;
    
    loopObserver =  CFRunLoopObserverCreate(kCFAllocatorDefault,
                                            kCFRunLoopBeforeWaiting,
                                            YES,
                                            0,
                                            observeCallBack,
                                            &observerContext);
    CFRunLoopAddObserver(runloopRef, loopObserver, kCFRunLoopCommonModes);
    CFRelease(loopObserver);
}

- (void)runloopRun{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
