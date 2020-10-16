//
//  ItemCell.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 22/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIView *vw,*plsvw;
@property(nonatomic,strong)IBOutlet UIButton *plusbtn,*minbtn,*addcart,*delbtn;
@property(nonatomic,strong)IBOutlet UIImageView *img;
@property(nonatomic,strong)IBOutlet UILabel *name,*count,*price,*price1,*total;
@end
