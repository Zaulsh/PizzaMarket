//
//  HistoryController.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIButton *menubtn;
    IBOutlet UITableView *table;
    IBOutlet UILabel *nolbl;
}

@end
