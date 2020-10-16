//
//  Login_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/19/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "Login_ViewController.h"
#import "Registration_ViewController.h"
#import "ViewPager_ViewController.h"
#import "Featured_ViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "StringConstants.h"
@interface Login_ViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@end

@implementation Login_ViewController
@synthesize pass_str,user_str,username_txt,pass_txt,scrollViewChildDetail,forgot_view,forgot_txt;
- (void)viewDidLoad {
    [super viewDidLoad];
    forgot_view.hidden=YES;
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    regbtn.frame=CGRectMake(lbl1.frame.origin.x+lbl1.frame.size.width, regbtn.frame.origin.y, regbtn.frame.size.width, regbtn.frame.size.height);
   
    [scrollViewChildDetail setScrollEnabled:YES];
    [scrollViewChildDetail setContentSize:CGSizeMake(scrollViewChildDetail.frame.size.width, self.view.frame.size.height)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    //hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
  //  scrollViewChildDetail.showsVerticalScrollIndicator
    
    // Do any additional setup after loading the view.
}

-(void)back:(id)sender{
  [[AppDelegate sharedAppDelegate]login];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.username_txt.text=@"";
      self.pass_txt.text=@"";
}
-(void)dismissKeyboard {
    [self.username_txt resignFirstResponder];
    [self.pass_txt resignFirstResponder];
    
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewChildDetail.contentInset = contentInsets;
    self.scrollViewChildDetail.scrollIndicatorInsets = contentInsets;
}
-(void)keyboardWasShown:(NSNotification*)notification
{
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


- (IBAction)Login:(id)sender {
    [username_txt resignFirstResponder];
    [pass_txt resignFirstResponder];
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if([username_txt.text isEqualToString:@""]){
            [self.view makeToast:@"por Introduza o seu email" duration:3.0 position:CSToastPositionBottom];
        //  [self alertStatus:@"por Introduza o seu email" :@"" :0];
    }else if ([emailTest evaluateWithObject:username_txt.text] == NO){
      //  [self alertStatus:@"por Introduza válido email" :@"" :0];

       [self.view makeToast:@"por Introduza válido email" duration:3.0 position:CSToastPositionBottom];
    }else if([pass_txt.text isEqualToString:@""]){
       // [self alertStatus:@"por Introduza a palavra-passe" :@"" :0];

        [self.view makeToast:@"por Introduza a palavra-passe" duration:3.0 position:CSToastPositionBottom];
    }else{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSString *path = [NSString stringWithFormat:@"%@login", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&email=%@&pwd=%@",username_txt.text,pass_txt.text];
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
                                                                      
                                                                      NSDictionary *results = [userdetails valueForKey:@"Userdetails"];
                                                                      NSString *email_str=[results objectForKey:@"email"];
                                                                      NSLog(@"emailll %@",email_str);
                                                                      
                                                                      NSString *inStr = [NSString stringWithFormat: @"%@", email_str];
                                                                      NSLog(@"key =====: %@",inStr);
                                                                      [self sharedata:@"Login" :inStr];
                                                                      
                                                                      NSString *mbnm = [results objectForKey:@"UserMobileNo"];
                                                                      NSLog(@"key =====: %@",inStr);
                                                                      [self sharedata:@"mobilenum" :mbnm];
                                                                      
                                                                      NSString *name_str=[results objectForKey:@"UserFullName"];
                                                                      NSLog(@"emailll %@",name_str);
                                                                      NSString *inStr1 = [NSString stringWithFormat: @"%@", name_str];
                                                                      NSLog(@"key =====: %@",inStr1);
                                                                      [self sharedata:@"Name" :inStr1];
                                                                      
                                                                      NSString *ID_str=[results objectForKey:@"id"];
                                                                      NSLog(@"emailll %@",ID_str);
                                                                      NSString *inStr2 = [NSString stringWithFormat: @"%@", ID_str];
                                                                      NSLog(@"key =====: %@",inStr2);
                                                                      [self sharedata:@"ID" :inStr2];
//                                                                      UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                                                      Featured_ViewController *VC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Featured_ViewController"];
//                                                                      [self.navigationController pushViewController:VC animated:YES];
//                                                                      if([successs isEqualToString:@"1"]){
//                                                                      UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//                                                                      SWRevealViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                                                                      [self.navigationController pushViewController:view animated:YES];
//                                                                      }
                                                                      [[AppDelegate sharedAppDelegate]login];
                                                                   
                                                                  }
                                                                  
                                                                  
                                                                  else{
                                                                      [self alertStatus:message :@"" :0];
                                                                  }

                                                                      //   [table reloadData];                                                                             [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self alertStatus:@"nome de usuário ou senha" :@"inválido" :0];
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

-(IBAction)forgotpassword:(id)sender{
    
    [forgot_txt resignFirstResponder];
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if([forgot_txt.text isEqualToString:@""]){
        [self.view makeToast:@"por Introduza o seu email" duration:3.0 position:CSToastPositionBottom];
        //  [self alertStatus:@"por Introduza o seu email" :@"" :0];
    }else if ([emailTest evaluateWithObject:forgot_txt.text] == NO){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        
        [self.view makeToast:@"por Introduza válido email" duration:3.0 position:CSToastPositionBottom];
    }else{
        
        
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.labelText =@"A carregar...";
            HUD.delegate = self;
            [self.view addSubview:HUD];
            [HUD show:YES];
            
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
          
            NSString *path = [NSString stringWithFormat:@"%@forget_password", BASE_URL];
            NSLog(@"%@",path);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:path]];
            [request setHTTPMethod:@"POST"];
            NSLog(@"%@",request);
            
            NSString *value = [NSString stringWithFormat:@"&email=%@",forgot_txt.text];
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
                                                                            [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                          
                                                                          if([successs isEqualToString:@"1"]){
                                                                              
                                                                              forgot_view.hidden=YES;

                                                                              
                                                                          }
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          //   [table reloadData];
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                      });
                                                                      [HUD hide:YES];
                                                                      
                                                                  }
                                                                  else if ([data length] == 0 && connectionError == nil){
                                                                      NSLog(@"no data returned");
                                                                      [self alertStatus:@"username or password" :@"invalid" :0];
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
        
        
   
  forgot_txt.text=@"";
    }
}
-(IBAction)forgotbtn:(id)sender{
    forgot_view.hidden=NO;
}
-(IBAction)cancel:(id)sender{
    forgot_txt.text=@"";
    forgot_view.hidden=YES;
}
-(IBAction)registration:(id)sender{
    Registration_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Registration_ViewController"];
    
    //    after_reg1.data=usr1;
    [self.navigationController pushViewController:after_reg1 animated:NO];
 
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
