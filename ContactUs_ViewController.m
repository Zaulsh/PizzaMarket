//
//  ContactUs_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/21/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//
#import "ContactUs_ViewController.h"

#import "AboutUs_ViewController.h"
#import "SWRevealViewController.h"
#import "Featured_ViewController.h"
#import "Product_ViewController.h"
#import "SubscriptionController.h"
#import "Payment_ViewController.h"
#import "HistoryController.h"
#import "FAQ_ViewController.h"
#import "Login_ViewController.h"
#import "MBProgressHUD.h"
#import "MenuCell.h"
#import "DBManager.h"
#import "StringConstants.h"
@interface ContactUs_ViewController ()<MBProgressHUDDelegate>{
    NSString *name,*email,*mbnum;
    MBProgressHUD *HUD;
    NSMutableArray *menulist,*menuimg;

}
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ContactUs_ViewController
@synthesize name_txt,contact_txt,email_txt,descrip_txt,scrollViewChildDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    menu.delegate=self;
    menu.dataSource=self;
    SWRevealViewController *revealViewController = self.revealViewController;
  //  [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    [disbtn addTarget:self action:@selector(disbtn:) forControlEvents:UIControlEventTouchUpInside];

    emailstr.text=[self get_shareddata:@"Login"];
    
    namestr.text=[self get_shareddata:@"Name"];
    menuvw.hidden=YES;
    
    menulist=[[NSMutableArray alloc]initWithObjects:@"Inicio",@"Entregas",@"Produtos",@"Carrinho",@"Histórico",@"FAQ",@"Contacte-nos",@"Sobre Nós",@"Sair",nil];
    menuimg=[[NSMutableArray alloc]initWithObjects:@"icon_home.png",@"my_order.png",@"icon_product.png",@"icon_cart.png",@"order_history.png",@"icon_faq.png",@"icon_contact.png",@"icon_aboutUs.png",@"Logout Rounded Up-48.png", nil];
    if ( revealViewController )
    {
        //        [self.sidebarButton setTarget: self.revealViewController];
        //        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    
    [callbtn addTarget:self action:@selector(callbtn:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    [scrollViewChildDetail setScrollEnabled:YES];
    [scrollViewChildDetail setContentSize:CGSizeMake(self.view.frame.size.width, 520)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    //hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    email=[self get_shareddata:@"Login"];
    
    name=[self get_shareddata:@"Name"];
    mbnum=[self get_shareddata:@"mobilenum"];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    NSString *str = @"Done";
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStyleDone target:self action: @selector(doneClicked:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexBarButton,doneBtn, nil]];
    
    descrip_txt.inputAccessoryView = keyboardDoneButtonView;
    
    [self wallet];
    // Do any additional setup after loading the view.
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


-(void)menubtn:(id)sender{
   // [descrip_txt resignFirstResponder];
   // menuvw.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)disbtn:(id)sender{
    menuvw.hidden=YES;
}
- (IBAction)doneClicked:(id)sender
{
    [descrip_txt resignFirstResponder];
}
-(void)callbtn:(id)sender{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
   
    NSString *path = [NSString stringWithFormat:@"%@get_contactusnumber", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
  //  NSString *value = [NSString stringWithFormat:@"&PNO=0"];
  //  NSLog(@"value:%@",value);
   // value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
   // [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
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
                                                                      
                                                                      NSString *string = [NSString  stringWithFormat:@"telprompt:%@",[userdetails valueForKey:@"contactno"]];
                                                                    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                                                                      NSLog(@"%@",string);
                                                                      UIApplication *application = [UIApplication sharedApplication];
                                                                      NSURL *URL = [NSURL URLWithString:string];
                                                                      if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
                                                                          
                                                                          [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                                                                              if (success) {
                                                                                  NSLog(@"Opened url");
                                                                              }
                                                                          }];
                                                                      }
                                                                      else{
                                                                          [application openURL:URL];
                                                                      }
                                                                      
                                                                      
                                                                  }
                                                                 
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
-(void)dismissKeyboard {
    [self.name_txt resignFirstResponder];
    [self.contact_txt resignFirstResponder];
    [self.descrip_txt resignFirstResponder];
    [self.email_txt resignFirstResponder];
       
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
-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    
    if([descrip_txt.text isEqualToString:@""]){
        descrip_txt.text=@"Descrição(Tamanho máximo 300)";

    }
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewChildDetail.contentInset = contentInsets;
    self.scrollViewChildDetail.scrollIndicatorInsets = contentInsets;
}
-(void)keyboardWasShown:(NSNotification*)notification
{
    descrip_txt.text=@"";
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.view.frame.origin.x,self.view.frame.origin.y, kbSize.height+100, 0);
    self.scrollViewChildDetail.contentInset = contentInsets;
    self.scrollViewChildDetail.scrollIndicatorInsets = contentInsets;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Send:(id)sender {
    if([descrip_txt.text isEqualToString:@"Descrição(Tamanho máximo 300)"]){
        [self alertStatus:@"unable to insert contact" :@"" :0];

    }else{
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText =@"A carregar...";
        HUD.delegate = self;
        [self.view addSubview:HUD];
        [HUD show:YES];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
       
        NSString *path = [NSString stringWithFormat:@"%@contactus", BASE_URL];
        NSLog(@"%@",path);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:path]];
        [request setHTTPMethod:@"POST"];
        NSLog(@"%@",request);
        
          NSString *value = [NSString stringWithFormat:@"&contactname=%@&contactphone=%@&contactemail=%@&contactmessage=%@",name,mbnum,email,descrip_txt.text];;
          NSLog(@"value:%@",value);
         value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
          value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
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
                                                                      [self alertStatus:message :@"" :0];

                                                                      if([successs isEqualToString:@"1"]){
                                                                          
                                                                          descrip_txt.text=@"Descrição(Tamanho máximo 300)";

                                                                          
                                                                      }
                                                                      
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [menulist count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

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
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.row== 0){
        Featured_ViewController  *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Featured_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    if(indexPath.row == 1){
        SubscriptionController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubscriptionController"];
        [self.navigationController pushViewController:event animated:NO];
    }
    if(indexPath.row== 2){
        Product_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Product_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    if(indexPath.row== 3){
        Payment_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Payment_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    if(indexPath.row== 4){
        HistoryController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HistoryController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    if(indexPath.row== 5){
        FAQ_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FAQ_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    if(indexPath.row== 6){
        ContactUs_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactUs_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    if(indexPath.row== 7){
        AboutUs_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUs_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    if(indexPath.row== 8){
        [self delete];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        Login_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
        
    }
    
    menuvw.hidden=YES;
}
-(void)delete{
    NSString *query = [NSString stringWithFormat:@"delete from CardManager"];
    [self.dbManager executeQuery:query];
}


@end
