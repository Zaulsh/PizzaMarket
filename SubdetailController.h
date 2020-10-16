//
//  SubdetailController.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubdetailController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    IBOutlet UIButton *backbtn;
    IBOutlet UICollectionView *collection;
    IBOutlet UILabel *nolbl;
}

@end
