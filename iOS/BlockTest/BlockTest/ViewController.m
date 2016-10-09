//
//  ViewController.m
//  BlockTest
//
//  Created by rongyan.zry on 15/10/24.
//  Copyright © 2015年 rongyan.zry. All rights reserved.
//

#import "ViewController.h"

#define bPaddingTop   74
#define bButtonHeight 50
#define bPaddingLeft  ceilf(self.view.frame.size.width/5)

#define BLog(prefix,obj) {NSLog(@"位置和指针变量名:%@ ,指针内存地址:%p, 指针值:%p ,指向的对象:%@ ",prefix,&obj,obj,obj);}

@interface ViewController ()
{
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    int buttonY =0;
    buttonY += bButtonHeight;
    UIButton *blockWeakRef = [UIButton buttonWithType:UIButtonTypeSystem];
    blockWeakRef.frame = CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    
    [blockWeakRef setTitle:@"block内变量弱应用" forState:UIControlStateNormal];
    [blockWeakRef addTarget:self action:@selector(blockVariableWeakReferenceTest) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:blockWeakRef];
    
    buttonY += bButtonHeight;
    UIButton *blockStrongRef = [UIButton buttonWithType:UIButtonTypeSystem];
    blockStrongRef.frame =  CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    [blockStrongRef setTitle:@"block强引用" forState:UIControlStateNormal];
    [blockStrongRef addTarget:self action:@selector(blockVariableStrongReferenceTest) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:blockStrongRef];
    
    buttonY += bButtonHeight;
    UIButton *blockMultiThread = [UIButton buttonWithType:UIButtonTypeSystem];
    blockMultiThread.frame =  CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    [blockMultiThread setTitle:@"block内多线程下对象安全 " forState:UIControlStateNormal];
    [blockMultiThread addTarget:self action:@selector(blockVariableMutiThreadTest) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:blockMultiThread];
    
    buttonY += bButtonHeight;
    UIButton *blockVariable = [UIButton buttonWithType:UIButtonTypeSystem];
    blockVariable.frame =  CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    [blockVariable setTitle:@" __block变量 " forState:UIControlStateNormal];
    [blockVariable addTarget:self action:@selector(blockVariable) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:blockVariable];
    
    buttonY += bButtonHeight;
    UIButton *blockObjectInMemory = [UIButton buttonWithType:UIButtonTypeSystem];
    blockObjectInMemory.frame =  CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    [blockObjectInMemory setTitle:@"block在内存中的位置" forState:UIControlStateNormal];
    [blockObjectInMemory addTarget:self action:@selector(blockObjectInMemory) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:blockObjectInMemory];

    buttonY += bButtonHeight;
    UIButton *mallocBlockObjectInMemory = [UIButton buttonWithType:UIButtonTypeSystem];
    mallocBlockObjectInMemory.frame =  CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    [mallocBlockObjectInMemory setTitle:@"malloc block " forState:UIControlStateNormal];
    [mallocBlockObjectInMemory addTarget:self action:@selector(blockInmemory) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mallocBlockObjectInMemory];

    buttonY += bButtonHeight;
    UIButton *stackBlockObjectInMemory = [UIButton buttonWithType:UIButtonTypeSystem];
    stackBlockObjectInMemory.frame =  CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    [stackBlockObjectInMemory setTitle:@"手动copy block " forState:UIControlStateNormal];
    [stackBlockObjectInMemory addTarget:self action:@selector(stackBlockInMemory) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:stackBlockObjectInMemory];

    buttonY += bButtonHeight;
    UIButton *valueCatchInBlock = [UIButton buttonWithType:UIButtonTypeSystem];
    valueCatchInBlock.frame =  CGRectMake(bPaddingLeft, buttonY, ceilf(self.view.frame.size.width/2), bButtonHeight);
    [valueCatchInBlock setTitle:@"valueCatch block " forState:UIControlStateNormal];
    [valueCatchInBlock addTarget:self action:@selector(catchValueBlock) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:valueCatchInBlock];

    
}

// 弱引用
- (void)blockVariableWeakReferenceTest
{
    NSLog(@"\n");
    NSObject *obj = [[NSObject alloc] init];
    BLog(@"StrongRef obj",obj);
    __weak NSObject *weakObj = obj;
    BLog(@"WeakRef weakObj", weakObj);
    void(^testBlock)()= ^(){
        BLog(@"weakObj in block",weakObj);
    };
    testBlock();
    obj = nil;
    testBlock();
}

// 强引用
- (void)blockVariableStrongReferenceTest
{
    NSLog(@"\n");
    NSObject *obj = [[NSObject alloc] init];
    BLog(@"StrongRef obj",obj);
    void(^testBlock)()= ^(){
        BLog(@"StrongRef in block",obj);
    };
    testBlock();
    // Block外部尝试将obj置为nil
    obj = nil;
    testBlock();
}

//多线程内变量安全
- (void)blockVariableMutiThreadTest
{
    NSObject *obj = [[NSObject alloc]init]; //obj强引用,<NSObject: 0x7f9413c1c040>对象引用计数＋1，＝1
    BLog(@"obj", obj);
    __weak NSObject *weakObj = obj;//weakObj弱引用,<NSObject: 0x7f9413c1c040>对象引用计数不变，＝1
    BLog(@"weakObj-0", weakObj);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong NSObject *strongObj = weakObj; //strongObj强引用,<NSObject: 0x7f9413c1c040>对象引用计数＋1，＝2
        sleep(3);
        BLog(@"weakObj - block", weakObj);
        BLog(@"strongObj - block", strongObj);
    });
    sleep(1);
    obj = nil; //obj被置为nil，<NSObject: 0x7f9413c1c040>对象引用计数－1，＝1
    BLog(@"weakObj-1", weakObj);  //没被释放
    sleep(4); //block在异步线程中执行完毕（在另一块内存中执行），block内存被释放，<NSObject: 0x7f9413c1c040>对象引用计数－1，＝0；ARC开始把0x7f9413c1c040对象内存回收，把弱引用weakObj置为nil
    BLog(@"weakObj-2", weakObj);
}


- (void)blockVariable
{
    // 使用__block
    NSObject *obj = [[NSObject alloc]init];
    BLog(@"obj",obj);
    __block NSObject *blockObj = obj;
    obj = nil;
    BLog(@"外部blockObj -1",blockObj);
    void(^testBlock)() = ^(){
        BLog(@"内部blockObj - block",blockObj);
        NSObject *obj2 = [[NSObject alloc]init];
        BLog(@"内部obj2",obj2);
        blockObj = obj2;
        BLog(@"blockObj - block",blockObj);
    };
    NSLog(@"%@",testBlock);
    
    BLog(@"外部blockObj -2",blockObj);
    testBlock();
    BLog(@"外部blockObj -3",blockObj);

}


- (void)blockObjectInMemory
{
    // global block
    void (^globalBlockInMemory)(int number) = ^(int number){
        printf("%d \n",number);
    };
    globalBlockInMemory(90);
    BLog(@"global block %@", globalBlockInMemory);
    
    // malloc block
    int outVariable = 100;
    void (^mallocBlockInMemory)(int number) = ^(int number){
        printf("%d \n",outVariable+number);
    };
    BLog(@"stackBlock block %@", mallocBlockInMemory);
    
}

- (id)returnBlock
{
    int outVariable = 100;
    void (^mallocBlockInMamory)(void) = ^(void){
            NSLog(@"in block");
    };
    BLog(@" block  ", mallocBlockInMamory);
    return mallocBlockInMamory;
}

- (void)blockInmemory
{
    id block = [self returnBlock];
    BLog(@"a block %@", block);
}

- (void)stackBlockInMemory
{
    NSArray *array = [self getBlockArray];
    id block = array[0];
    BLog(@"block %@", block);
}

- (id)getBlockArray
{
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            [^{NSLog(@"value:%d", val);} copy],
            [^{NSLog(@"value:%d", val);} copy], nil];
}

- (void)catchValueBlock
{
    // block 捕获
    int val = 2;
    const char *fmt = "old value = %d";
    void (^block_one) (void) = ^{printf(fmt,val);};
    val = 10;
    fmt = "new value = %d";
    block_one();
    // 结果 old value = 2 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
