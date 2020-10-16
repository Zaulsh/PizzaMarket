//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ModelManager.h"

@interface SidebarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *menu;
    IBOutlet UILabel *namestr,*emailstr,*walletstr;
    IBOutlet UIView *menuvw;
    IBOutlet UIButton *disbtn;

}

//@property(weak,nonatomic) IBOutlet UIImageView *profileImageView;





@end
