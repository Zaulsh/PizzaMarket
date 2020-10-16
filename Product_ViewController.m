//
//  Product_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/24/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "Product_ViewController.h"
#import "ProductDetail_ViewController.h"
#import "SWRevealViewController.h"
#import "AddCart_ViewController.h"
#import "Featured_ViewController.h"
#import "ContactUs_ViewController.h"
#import "SubscriptionController.h"
#import "Payment_ViewController.h"
#import "HistoryController.h"
#import "FAQ_ViewController.h"
#import "Login_ViewController.h"
#import "AboutUs_ViewController.h"
#import "MBProgressHUD.h"
#import "DBManager.h"
#import "MenuCell.h"
#import "ItemCell.h"
#import "FilterCell.h"
#import "UIView+Toast.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "StringConstants.h"

@interface Product_ViewController ()<MBProgressHUDDelegate>{
    int page_str;
    NSString *searchString;
    NSString *badSearchString;
    NSMutableArray *proName_array;
    NSString *cartacount_str;
    NSMutableArray *menulist,*menuimg,*array;
    MBProgressHUD *HUD;
    NSMutableArray *newArray,*filterary,*results;
    NSInteger numberOfTableRow;
    NSString *cid,*str;
    NSTimer *searchTimer;
    NSURLSessionDataTask *fetchProductsTask;
    BOOL keyboardIsShowing;
}

@property (nonatomic, strong) DBManager *dbManager;
//@property (nonatomic, strong) NSArray *arrPeopleInfo;

@end

@implementation Product_ViewController
@synthesize cart_label;

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.shouldInitiallyFocusSearchField = NO;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];

    keyboardIsShowing = NO;
    
    cart_label.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"addquant"]];

  //  cartacount_str=[self get_shareddata:@"noti_count"];
   // cart_label.text=cartacount_str;
    NSLog(@"carttt %@",cartacount_str);
    results =[[NSMutableArray alloc]init];
    filterary=[[NSMutableArray alloc]init];
    menuvw.hidden =YES;
    filtervw.hidden =YES;
   // [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    [disbtn addTarget:self action:@selector(disbtn:) forControlEvents:UIControlEventTouchUpInside];
    [filterbtn addTarget:self action:@selector(filterbtn:) forControlEvents:UIControlEventTouchUpInside];
    [fcancel addTarget:self action:@selector(fcancel:) forControlEvents:UIControlEventTouchUpInside];

    searchTextField.delegate = self;

    cid=@"";
    
    menulist=[[NSMutableArray alloc]initWithObjects:@"Inicio",@"Entregas",@"Produtos",@"Carrinho",@"Histórico",@"FAQ",@"Contacte-nos",@"Sobre Nós",@"Sair",nil];
    menuimg=[[NSMutableArray alloc]initWithObjects:@"icon_home.png",@"my_order.png",@"icon_product.png",@"icon_cart.png",@"order_history.png",@"icon_faq.png",@"icon_contact.png",@"icon_aboutUs.png",@"Logout Rounded Up-48.png", nil];
    
    array = [[NSMutableArray alloc] init];

    email.text=[self get_shareddata:@"Login"];
    
    name.text=[self get_shareddata:@"Name"];

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]){
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
    //        [self.sidebarButton setTarget: self.revealViewController];
    //        [self.sidebarButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }

        [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [menubtn addTarget:self action:@selector(showLoginController:) forControlEvents:UIControlEventTouchUpInside];
        
    }
  //  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self.tableview reloadData];
    page_str=0;
    cid=@"13";
    [self show];
    [self loadData];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];
    if(results.count>0){
        self.tableview.hidden=NO;
    }else{
        self.tableview.hidden=YES;
        
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

    searchbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    searchbtn.alpha = 0.5;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
   // numberOfTableRow = 100;

  //  [self setAllElementofArrayToZero];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self loadData];
    cart_label.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"addquant"]];
    [self wallet];

    if (_shouldInitiallyFocusSearchField) {
        [searchTextField becomeFirstResponder];
        _shouldInitiallyFocusSearchField = NO;
    } else {
        [searchTextField resignFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [self.view endEditing:YES];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)keyboardDidShow:(NSNotification *)notification {
    if (keyboardIsShowing) {
        return;
    }

    CGSize originalSize = _tableview.frame.size;
    CGPoint origin = _tableview.frame.origin;

    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    [_tableview setFrame:CGRectMake(origin.x, origin.y, originalSize.width, originalSize.height - keyboardHeight)];

    keyboardIsShowing = YES;
}

-(void)keyboardWillHide:(NSNotification *)notification {
    if (!keyboardIsShowing) {
        return;
    }
    CGSize originalSize = _tableview.frame.size;
    CGPoint origin = _tableview.frame.origin;

    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

    [_tableview setFrame:CGRectMake(origin.x, origin.y, originalSize.width, originalSize.height + keyboardHeight)];

    keyboardIsShowing = NO;
}

-(void)showLoginController:(id)sender{
    Login_ViewController  *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
    [self.navigationController pushViewController:event animated:NO];
}

- (IBAction)searchButtonPressed:(id)sender {
    [searchTextField becomeFirstResponder];
}

-(void)wallet{
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@get_wallet", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@",[self get_shareddata:@"ID"]];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          [HUD hide:YES];
                                                          
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"returnDictionary = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      
                                                                      NSString *wall=[NSString stringWithFormat:@"%@",[userdetails valueForKey:@"total"]];
                                                                      [self sharedata:@"wallet" :wall];
                                                                      
                                                                      
                                                                      //    walletstr.text=[NSString stringWithFormat:@"Saldo : %@€",[userdetails valueForKey:@"total"]];
                                                                      
                                                                  }
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              //   [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              //  [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    
    [dataTask resume];
    
}

-(void)sharedata:(NSString*)key :(NSString*)value{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    
    const NSString *currentLevel = value;
    [preferences setValue:currentLevel forKey:currentLevelKey];
    
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    NSLog(@"key =====: %@", key);
    NSLog(@"value =====: %@", value);
    if (!didSave)
    {
        value=@"";
        //  Couldn't save (I've never seen this happen in real world testing)
    }
    
}

- (void)setAllElementofArrayToZero
{
    for(int i = 0;i < numberOfTableRow ;i++)
    {
        [array addObject:[NSNumber numberWithInteger:1]];
    }
}

-(void)menubtn:(id)sender{
    menuvw.hidden=NO;
}
-(void)disbtn:(id)sender{
    menuvw.hidden=YES;
}
-(void)filterbtn:(id)sender{
    filtervw.hidden=NO;
    [self filterdet];
}
-(void)fcancel:(id)sender{
    filtervw.hidden=YES;
}
-(NSString *)get_shareddata:(NSString *)key{
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    NSString *currentLevel=@"";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        
        //  Doesn't exist.
        //        Doctor_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Doctor_ViewController"];
        //
        //        //    after_reg1.data=usr1;
        //        [self.navigationController pushViewController:after_reg1 animated:NO];
        
    }
    else
    {
        //  Get current level
        currentLevel = [preferences stringForKey:currentLevelKey];
    }
    return currentLevel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filterdet{
    
    filterary=[[NSMutableArray alloc]init];
    HUD.labelText =@"A carregar...";
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@get_categories", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&PNO=0"];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          
                                                          [HUD hide:YES];
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"returnDictionary = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      NSMutableDictionary *special = [[NSMutableDictionary alloc]init];
                                                                      [special setValue:@"13" forKey:@"CategoryID"];
                                                                      [special setValue:@"Mostrar tudo" forKey:@"CategoryName"];

                                                                    
                                                                      NSMutableArray *ary=[[NSMutableArray alloc]init];
                                                                      [ary addObject:special];
                                                                      NSLog(@"ar: %@",ary);
                                                                      NSArray *arry = [userdetails valueForKey:@"Categorylist"];
                                                                      [filterary addObjectsFromArray:arry];
                                                                      [filterary addObjectsFromArray:ary];

                                                                      [filtertbl reloadData];
                                                                      if(filterary.count>0){
                                                                        filtertbl.hidden=NO;
                                                                      }else{
                                                                          filtertbl.hidden=YES;
                                                                          
                                                                      }
                                                                      
                                                                  }
//                                                                  else{
//                                                                      [self alertStatus:message :@"" :0];
//
//                                                                  }
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  //   [table reloadData];                                                                             [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
                                                              //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];
    
}
-(void)show{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
   
    NSString *path = [NSString stringWithFormat:@"%@get_products", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&PNO=%d&category=%@",page_str,cid];
    NSString *searchStringCopy;

    if (searchString != NULL) {
        if (badSearchString != nil && [searchString containsString:badSearchString]) {
            NSLog(@"Ignoring search request containing unhelpful string");
            noResultsView.hidden = NO;
            return;
        }
        NSString *trimmedSearchString = [searchString stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        searchStringCopy = trimmedSearchString.copy;

        if ([trimmedSearchString length] > 0) {
            value = [value stringByAppendingString:[NSString stringWithFormat:@"&search_terms=%@", trimmedSearchString]];
        }
    }

    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];

    // If a task is already in progress, cancel it and begin a new task.
    if (fetchProductsTask != NULL) {
        [fetchProductsTask cancel];
    }

    HUD.labelText =@"A carregar...";
    [HUD show:YES];

    fetchProductsTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          
                                                          [HUD hide:YES];
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"returnDictionary = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      
                                                                     NSArray *results1 = [userdetails valueForKey:@"Productlist"];
                                                                      
                                                                      if(results1.count>0){
                                                                      [results addObjectsFromArray:results1];
                                                                      numberOfTableRow = results.count;
                                                                      
                                                                      [self setAllElementofArrayToZero];

                                                                      [self.tableview reloadData];
                                                                      if(results.count>0){
                                                                          self.tableview.hidden=NO;
                                                                          noResultsView.hidden = YES;
                                                                      }else{
                                                                          self.tableview.hidden=YES;
                                                                          noResultsView.hidden = NO;
                                                                      }
                                                                      
                                                                  }
                                                                  }
                                                                  else{
                                                                      if(page_str ==0){
//                                                                          [self alertStatus:message :@"" :0];
                                                                          if (searchStringCopy != nil) {
                                                                              badSearchString = searchStringCopy;
                                                                              noResultsView.hidden = NO;
                                                                          }
                                                                      }
                                                                  }
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  //   [table reloadData];                                                                             [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil && connectionError.code == NSURLErrorCancelled) {
                                                              NSLog(@"The session task was cancelled");
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
                                                              //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [fetchProductsTask resume];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(tableView == menu){
        return 50;
        
    }else if(tableView == filtertbl){
        
         return 50;
    }else{
        //        NSString *lbl=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductName"]];
        //        //  CGFloat dataTextHeight = [self getLabelHeightForIndex:lbl];
        //        UIFont *cellFont = [UIFont fontWithName:@"system" size:12.0];
        //        CGSize constraintSize = CGSizeMake(self.tableview.frame.size.width-15, MAXFLOAT);
        //        CGSize dataTextHeight = [lbl sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        
        return 132;
        
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == menu){
        return [menulist count];
        
    }else if(tableView == filtertbl){
        return [filterary count];
    }else{
        
        return [results count];
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == menu){
        
        menu.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *identifier = @"MenuCell";
        MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.name.text=[menulist objectAtIndex:indexPath.row];
        cell.img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[menuimg objectAtIndex:indexPath.row]]];
        
        
        
        return cell;
        
    }else  if(tableView == filtertbl){
        
        filtertbl.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        static NSString *identifier = @"FilterCell";
        FilterCell *cell = (FilterCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
      cell.name.text=[[filterary objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
        
        
        
        return cell;
        
    }else{
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *identifier = @"ItemCell";
        ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.vw.layer.borderWidth=1;
        cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.vw.layer.cornerRadius=8;
        NSString *ssss1=[[results objectAtIndex:indexPath.row] valueForKey:@"ProductName"];
        cell.name.text=[NSString stringWithFormat:@"%@",ssss1];
        
        NSString *feestr =[NSString stringWithFormat:@"preço : %@€",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"]] ;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:feestr];
        NSRange range = [feestr rangeOfString:@"preço"];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor  lightGrayColor] range:range];
        cell.price.attributedText = attString;
        NSString * ssss2=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"];
        NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
      //  cell.price.text=[NSString stringWithFormat:@"%@€",ssss2];
        
        
//        NSString *ssss3=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductImage"];
//        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//            cell.img.image = [UIImage imageWithData:data];
//        }];
        
        
        NSString *ssss3=[NSString stringWithFormat:@"%@",[[results objectAtIndex:indexPath.row]valueForKey:@"ProductImage"]];
        NSLog(@"img %@",ssss3);
        ssss3  = [ssss3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        ssss3= [ssss3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:ssss3] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"bread_images.jpg"]]];
        
        
        
        cell.plusbtn.tag=indexPath.row;
        [cell.plusbtn addTarget:self action:@selector(increaseItemCount:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.minbtn.tag=indexPath.row;
        [cell.minbtn addTarget:self action:@selector(increaseItemCount1:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.count.text = [NSString stringWithFormat:@"%i",[[array objectAtIndex:indexPath.row] intValue]];
        
        
      //  deleteBtn=(UIButton *)[cell viewWithTag:6];
        cell.addcart.tag=indexPath.row;
        [cell.addcart addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
        
       
        if (indexPath.row == [results count]-1) {
            if (page_str<=[results count]) {
                page_str = page_str + 1;
                
                [self show];
                
            }
        }
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == menu){
       
    }else if(tableView == filtertbl){
        
        
        cid=[NSString stringWithFormat:@"%@",[[filterary objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]];
        
        results= [[NSMutableArray alloc]init];
        page_str=0;
        // A bad search for one filter may be okay for another
        badSearchString = nil;
        [_tableview reloadData];
        [self show];
       
        
        filtervw.hidden=YES;
    }else{
        ProductDetail_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetail_ViewController"];
        
        event.proImage_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductImage"];
        event.proName_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductName"];
        event.proDescrip_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductDescription"];
        event.proPrice_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductPrice"];
        event.proID_str=[[results objectAtIndex:indexPath.row]valueForKey:@"ProductID"];
        
        [self.navigationController pushViewController:event animated:NO];
    }
}


-(void)delete{
    NSString *query = [NSString stringWithFormat:@"delete from CardManager"];
    [self.dbManager executeQuery:query];
}

-(void)increaseItemCount:(UIButton *)sender
{
    // UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    // NSIndexPath *path = [self.tableview indexPathForCell:cell];
    NSInteger str=[[array objectAtIndex:sender.tag] intValue];
    
    if(str >=1){
        
        [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:sender.tag] intValue]+1 ]];
        
        
        
        [self.tableview reloadData];
    }
    
}


-(void)increaseItemCount1:(UIButton *)sender
{
    //    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    //    NSIndexPath *path = [self.tableview indexPathForCell:cell];
    NSInteger str=[[array objectAtIndex:sender.tag] intValue];
    if(str >1){
        [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:sender.tag] intValue]-1]];
        
        [self.tableview reloadData];
    }
    
}

- (void)saveInfo:(UIButton *)sender {
   [self loadData1];
 
    NSString *s1= [[results objectAtIndex:sender.tag]valueForKey:@"ProductID"];
  //  NSLog(@"aaaaaaaaaa %@",s1);
    BOOL isTheObjectThere = [newArray containsObject:s1];
    NSLog(@"bool %s", isTheObjectThere ? "true" : "false");
    //     NSIndexPath *path = [NSIndexPath indexPathForRow:deleteBtn.tag inSection:0];
    //    NSLog(@"nameeeee %@",ssss1);
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    
    NSString *query;
    //if (self.recordIDToEdit == -1) {
    if (isTheObjectThere == false) {
        query = [NSString stringWithFormat:@"insert into CardManager values(null, '%@', '%@', '%@', '%@', '%@')", [[results objectAtIndex:sender.tag]valueForKey:@"ProductID"],[[results objectAtIndex:sender.tag]valueForKey:@"ProductName"],[[results objectAtIndex:sender.tag]valueForKey:@"ProductImage"], [NSString stringWithFormat:@"%i",[[array objectAtIndex:sender.tag] intValue]],[[results objectAtIndex:sender.tag]valueForKey:@"ProductPrice"]];
        
    }
    //        }
    else{
        
        NSString *count=[NSString stringWithFormat:@"SELECT ProQuantity FROM CardManager WHERE ProductID ='%@'",[[results objectAtIndex:sender.tag]valueForKey:@"ProductID"]];
        [self.dbManager executeQuery:count];
        NSArray   *info = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:count]];
        NSLog(@"%@",info);
        int num=0;
        for (NSDictionary *result in info) {
            NSArray *aa=result;
            NSLog(@"reultttt %@",aa);
            for (int i=0;i<[aa count];i++){
                
                NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                     [aa objectAtIndex:i]] ;
                NSLog(@"temp%@",tmpObject);
                int j=[tmpObject intValue];
                num=num+j;
                tmpObject=nil;
            }
            
        }
        NSString *quan=[NSString stringWithFormat:@"%i",[[array objectAtIndex:sender.tag] intValue]];
        int c=num+[quan intValue];
        
        query = [NSString stringWithFormat:@"update CardManager set ProQuantity='%d' where ProductID='%@'",c,[[results objectAtIndex:sender.tag]valueForKey:@"ProductID"]];
        NSLog(@"%@",query);
        
      
    }
    
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    [array replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInteger:1]];
    [self.tableview reloadData];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        
    }
    else{
        NSLog(@"Could not execute the query.");
        
    }
    [self loadData];
    
    
}

-(void)loadData1{
    // Form the query.
    NSArray *arrPeopleInfo=[[NSArray alloc]init];

    newArray=[[NSMutableArray alloc]init];
    NSString *query = @"select ProductID from CardManager";
    
    // Get the results.
    if (arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"ooooo %@",arrPeopleInfo);
    for (NSDictionary *result in arrPeopleInfo) {
        NSArray *aa=result;
        NSLog(@"reultttt %@",aa);
        for (int i=0;i<[aa count];i++){
            
            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:i]];
            NSLog(@"temp%@",tmpObject);
           
            [newArray addObject: tmpObject];
            tmpObject=nil;
        }
        NSLog(@"newww %lu",(unsigned long)newArray.count);
        
    }
    
    
    // Reload the table view.
}
-(void)loadData{
    // Form the query.
    NSArray *arrPeopleInfo=[[NSArray alloc]init];

    int count = 0;
  NSMutableArray  *newArray1=[[NSMutableArray alloc]init];
    NSString *query = @"select ProQuantity from CardManager";
    
    // Get the results.
    if (arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"ooooo %@",arrPeopleInfo);
    for (NSDictionary *result in arrPeopleInfo) {
        NSArray *aa=result;
        NSLog(@"reultttt %@",aa);
        for (int i=0;i<[aa count];i++){
            
            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:i]];
            NSLog(@"temp%@",tmpObject);
            int j=[tmpObject intValue];
            count=count+j;
            tmpObject=nil;
        }
        NSLog(@"newww %lu",(unsigned long)newArray1.count);
        
    }
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"addquant"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    cart_label.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"addquant"]];
    
    // Reload the table view.
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = tag;
        [alertView show];
        
    });
}

-(IBAction)cartView:(id)sender{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]){
        Payment_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Payment_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
    } else {
        [self showLoginController:self];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// MARK: - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.placeholder = @"Pesquise Aqui";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (searchTimer != NULL) {
        [searchTimer invalidate];
    }

    searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.4
                                                  repeats:false
                                                    block:^(NSTimer *timer) {
                                                        searchString = newString;
                                                        NSLog(@"Search string: %@", searchString);
                                                        page_str = 0;
                                                        [results removeAllObjects];
                                                        [_tableview reloadData];
                                                        [self show];
                                                    }];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    searchString = @"";
    textField.text = @"";
    page_str = 0;
    [results removeAllObjects];
    [_tableview reloadData];
    [self show];
    return NO;
}

// MARK: UIGestureRecognizerDelegata methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:filtertbl] || [touch.view isDescendantOfView:_tableview]) {
        return NO;
    }

    return YES;
}

@end
