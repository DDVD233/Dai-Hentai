//
//  Menu.h
//  e-Hentai
//
//  Created by DaidoujiChen on 2015/4/24.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiStorage.h"
#import "MenuItem.h"

DaiStorageArrayConverter(MenuItem)

@interface Menu : DaiStorage

@property (nonatomic, strong) MenuItemArray *items;

@end
