//
//  TestBlockVariable.m
//  BlockTest
//
//  Created by rongyan.zry on 15/12/2.
//  Copyright © 2015年 rongyan.zry. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(){
    __block NSObject *obj = [[NSObject alloc] init];
    void (^blockTest)(void) = ^{
        NSLog(@"%@",obj);
    };
    return 0;
    
}