//
//  DataSource.h
//  Zhuajiu
//
//  Created by smartrookie on 16/9/9.
//  Copyright © 2016年 smartrookie. All rights reserved.
//

#import "YYCache.h"

@interface DataSource : YYCache

+ (instancetype)shareDB;

- (void)addItem:(NSString *)item;
- (void)deleteItem:(NSString *)item;

@end
