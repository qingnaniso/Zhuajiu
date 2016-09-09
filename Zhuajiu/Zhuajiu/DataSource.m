//
//  DataSource.m
//  Zhuajiu
//
//  Created by smartrookie on 16/9/9.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+(instancetype)shareDB
{
    static DataSource *dataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[DataSource alloc] initWithName:@"com.qiqingnan.zhuajiu"];
    });
    return dataSource;
}


-(void)addItem:(NSString *)item
{
    if (!item) {
        return;
    }
    NSArray *old = (NSArray *)[self objectForKey:@"data"];
    if ([old containsObject:item]) {
        return;
    } else {
        NSMutableArray *new = [NSMutableArray arrayWithArray:old];
        [new addObject:item];
        [self setObject:new forKey:@"data"];
    }
}

-(void)deleteItem:(NSString *)item
{
    NSArray *old = (NSArray *)[self objectForKey:@"data"];
    if ([old containsObject:item]) {
        NSMutableArray *new = [NSMutableArray arrayWithArray:old];
        [new removeObject:item];
        [self setObject:new forKey:@"data"];
    } else {
        return;
    }
}
@end
