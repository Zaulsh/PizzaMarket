//
//  AppDelegate.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/15/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+(AppDelegate *)sharedAppDelegate;

- (void)login;


@end

