//
//  SubdescriptionController.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface SubdescriptionController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIButton *back,*sbck,*subbtn,*cancelbtn,*timecancel;
    IBOutlet UILabel *nolbl,*toplbl;
    IBOutlet UITableView *table,*subtable,*timetable;
    IBOutlet UIView *svw,*dvw,*timevw;
    IBOutlet UIButton *datetxt,*timetxt;
    
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong)NSMutableArray *listary;
@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)NSString *indexc;
@end
