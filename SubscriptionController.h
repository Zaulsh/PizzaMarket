//
//  SubscriptionController.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIButton *menubtn,*nextbtn,*sback;
    IBOutlet UILabel *nolbl;
    IBOutlet UITableView *table,*subtable;
    IBOutlet UIView *svw;
    
}

@end
