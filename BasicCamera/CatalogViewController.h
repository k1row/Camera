//
//  CatalogViewController.h
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/07/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterController.h"


@interface CatalogViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)FilterController *filter;
@property (strong,nonatomic)IBOutlet UIImageView *imageView;
@property (strong,nonatomic)IBOutlet UITableView *tableView;

@end
