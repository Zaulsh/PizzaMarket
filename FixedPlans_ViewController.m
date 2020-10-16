//
//  FixedPlans_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/15/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "FixedPlans_ViewController.h"
#import "FixedDetail_ViewController.h"
#import "SWRevealViewController.h"
#import "Login_ViewController.h"
#import "StringConstants.h"

@interface FixedPlans_ViewController (){
    NSString * page_str;
    NSArray *chapters;
    NSArray *results ;
    NSString*  name;
    NSString *  msg;
    NSString *status;
   }

@end

@implementation FixedPlans_ViewController
@synthesize ProductID_array,indi_view,indicator;
- (void)viewDidLoad {
    [super viewDidLoad];
    indi_view.hidden=YES;
    indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
    indicator.startAnimating;
  name=[self get_shareddata:@"ID"];
    NSLog(@"nameeee %@",name);
//    SWRevealViewController *revealViewController = self.revealViewController;
//    
//    if ( revealViewController )
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
//        
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//        
//    }

    page_str=@"0";
    [self show];
    //[self.tableview reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)show{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_plans", BASE_URL]];
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:url];
    [rq setHTTPMethod:@"POST"];
    NSString *post = [NSString stringWithFormat:@"&PNO=%@&plantype=%@",page_str,@"2"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    [rq setHTTPBody:postData];
    [rq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:rq queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             NSError *parseError = nil;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
             NSLog(@"Server Response (we want to see a 200 return code) %@",response);
                
            results = [dictionary valueForKey:@"Productlist"];
             
             NSLog(@"Count %d", results.count);
             _FixedplanID_array=[[NSMutableArray alloc]init];
             _FixedplanName_array = [[NSMutableArray alloc]init];
             _FixedplanImage_array =[[NSMutableArray alloc]init];
             _FixedplanDescription_array=[[NSMutableArray alloc]init];
             _FixedplanPrice_array=[[NSMutableArray alloc]init];
             _SubscriptionName_array=[[NSMutableArray alloc]init];
             _ProductName_array=[[NSMutableArray alloc]init];
             _ProductPrice_array=[[NSMutableArray alloc]init];
             ProductID_array=[[NSMutableArray alloc]init];
//             _suppName_array=[[NSMutableArray alloc]init];
//             _typeName_array=[[NSMutableArray alloc]init];
             
             for (NSDictionary *groupDic in results) {
                 
                 
                 NSString *proD_str = [groupDic objectForKey:@"FixedplanID"];
                 NSLog(@"   >>>>>>,,,,fixedplan,,, %@",proD_str);
                 [_FixedplanID_array addObject:proD_str];
                 
                 NSString *proI_str = [groupDic objectForKey:@"FixedplanName"];
                 NSLog(@"   >>>>>>,,,,description,,, %@",proI_str);
                 [_FixedplanName_array addObject:proI_str];
                 
                 NSString *proF_str = [groupDic objectForKey:@"FixedplanImage"];
                 
                 NSLog(@"   >>>>>>,,,,description,,, %@",proF_str);
                 [_FixedplanImage_array addObject:proF_str];
                 
                 NSString *proN_str = [groupDic objectForKey:@"FixedplanDescription"];
                 NSLog(@"   >>>>>>,,,,description,,, %@",proN_str);
                 [_FixedplanDescription_array addObject:proN_str];
                 
                 NSString *proP_str = [groupDic objectForKey:@"FixedplanPrice"];
                 NSLog(@"   >>>>>>,,,,description,,, %@",proP_str);
                 [_FixedplanPrice_array addObject:proP_str];
                 
                 NSString *sizeN_str = [groupDic objectForKey:@"SubscriptionName"];
                 NSLog(@"   >>>>>>,,,,description,,, %@",sizeN_str);
                 [_SubscriptionName_array addObject:sizeN_str];
                 
//                 chapters = [groupDic valueForKey:@"product"];
//                 NSLog(@"<<<<<<array>>>>>> %@", chapters);
//                 for(NSDictionary *cause in chapters){
//                     NSString *course_str=[cause objectForKey:@"ProductID"];
//                     NSLog(@"   >>>>>>,,,,++++++++++cause name++++++++++++++++++,,, %@",course_str);
//                     [_ProductID_array addObject:course_str];
//                     
//                     NSString *cause_descrip=[cause objectForKey:@"ProductName"];
//                     NSLog(@"   >>>>>>,,,,+++++++++++++++++++++++++++++++(((((((((((((((((((((((((((((((,,, %@",cause_descrip);
//                     [_ProductName_array addObject:cause_descrip];
//                     
//                     NSString *causeImage_str=[cause objectForKey:@"ProductPrice"];
//                     NSLog(@"   >>>>>>,,,,****************************************************,,, %@",causeImage_str);
//                     [_ProductPrice_array addObject:causeImage_str];
//                     
//                     
//                 }

                 
//                 NSString *suppN_str = [groupDic objectForKey:@"SupplierName"];
//                 NSLog(@"   >>>>>>,,,,description,,, %@",suppN_str);
//                 [_suppName_array addObject:suppN_str];
//                 
//                 NSString *typeN_str = [groupDic objectForKey:@"TypeName"];
//                 NSLog(@"   >>>>>>,,,,description,,, %@",typeN_str);
//                 [_typeName_array addObject:typeN_str];
                 
                 
                 [self.tableview reloadData];
             
                 
                 
             }
             NSLog(@"dictionary %@",dictionary);
         }
         else if ([data length] == 0 && error == nil){
             NSLog(@"no data returned");
              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //no data, but tried
         }
         else if (error != nil)
         {
             NSLog(@"there was a download error");
              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //couldn't download
             
         }
     }];
    
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     tableView.separatorColor = [UIColor clearColor];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-4  tablearray  >> > > > > > > %@",_FixedplanImage_array);
    return [_FixedplanName_array count];
    return [_FixedplanPrice_array count];
    return [_FixedplanImage_array count];
    return [_SubscriptionName_array count];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    
    NSLog(@"   >>>>>>,,,,,,, >>>   str-5  [self.tablearray objectAtIndex:indexPath.row]  >> > > > > > > %@",[_FixedplanImage_array objectAtIndex:indexPath.row]);
    
    
    
    
    UILabel *lbl=(UILabel *)[cell viewWithTag:1];
    
    
    NSString * ssss1=[_FixedplanName_array objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    lbl.text=[NSString stringWithFormat:@"%@",ssss1];
    UILabel *lbl1=(UILabel *)[cell viewWithTag:2];
    
    
    NSString * ssss2=[_FixedplanPrice_array objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    lbl1.text=[NSString stringWithFormat:@"%@",ssss2];
    
    
    UIImageView *img=(UIImageView *)[cell viewWithTag:100];
    
    NSString *ssss3=[_FixedplanImage_array objectAtIndex:indexPath.row];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        img.image = [UIImage imageWithData:data];
    }];
    UIButton *  btn=(UIButton *)[cell viewWithTag:400];
    [btn addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    
    // NSString * ssss2=[proName_array objectAtIndex:indexPath.row];
    // NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    // lbl.text=[NSString stringWithFormat:@"%@",ssss1];
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *myDict = [results objectAtIndex:indexPath.row];
    NSArray *myArray = [myDict objectForKey:@"product"];
       NSLog(@"please: %@",myArray);
        for(NSDictionary *cause in myArray){
        NSString *course_str=[cause objectForKey:@"ProductID"];
        NSLog(@"   >>>>>>,,,,++++++++++cause name++++++++++++++++++,,, %@",course_str);
        [ProductID_array addObject:course_str];
        NSLog(@"   >>>>>>,,,,++++++++++_ProductID_array name++++++++++++++++++,,, %@",ProductID_array);
        NSString *cause_descrip=[cause objectForKey:@"ProductName"];
        NSLog(@"   >>>>>>,,,,+++++++++++++++++++++++++++++++(((((((((((((((((((((((((((((((,,, %@",cause_descrip);
        [_ProductName_array addObject:cause_descrip];
        
        NSString *causeImage_str=[cause objectForKey:@"ProductPrice"];
        NSLog(@"   >>>>>>,,,,****************************************************,,, %@",causeImage_str);
        [_ProductPrice_array addObject:causeImage_str];
        
        
    }
    
        NSString *ss3=[self.FixedplanDescription_array objectAtIndex:indexPath.row];
        NSLog(@"+++++++++++description+++++++++++%@",ss3);
    
    //html to plain text
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:ss3];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        ss3 = [ss3 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    ss3 = [ss3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"html %@",ss3);

    
    FixedDetail_ViewController *fv=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FixedDetail_ViewController"];
    fv.proID_array=ProductID_array;
    fv.proName_array=_ProductName_array;
    fv.proPrice_array=_ProductPrice_array;
    fv.proDescrip_array=ss3;
     [self.navigationController pushViewController:fv animated:NO];

    
}
-(void)subscribe{
    indi_view.hidden=NO;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@check_subscription", BASE_URL]];
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:url];
    [rq setHTTPMethod:@"POST"];
    NSString *post = [NSString stringWithFormat:@"&userid=%@",name];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    [rq setHTTPBody:postData];
    [rq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:rq queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             NSError *parseError = nil;
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
             NSLog(@"Server Response (we want to see a 200 return code) %@",response);
             NSMutableArray *groups = [[NSMutableArray alloc] init];
             indi_view.hidden=YES;
                   msg = [dictionary valueForKey:@"msg"];
             //
                          NSLog(@"Count %@", results);
             status = [dictionary valueForKey:@"status"];
             //
             NSLog(@"Count %@", status);

             
             
             
             
             //  }
             NSLog(@"dictionary %@",dictionary);
         }
         else if ([data length] == 0 && error == nil){
             indi_view.hidden=YES;
             NSLog(@"no data returned");
             [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //no data, but tried
         }
         else if (error != nil)
         {
             indi_view.hidden=YES;
             NSLog(@"there was a download error");
             [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
             //couldn't download
             
         }
     }];



}
-(IBAction)subscribe:(id)sender{
    [self subscribe];
     if (name==(id) [NSNull null] || [name length]==0 || [name isEqualToString:@""]) {
         Login_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
         
         //    //    after_reg1.data=usr1;
         [self.navigationController pushViewController:after_reg1 animated:NO];
         
     }else if([status isEqualToString:@"0"]){
          [self alertStatus:msg :@"" :0];
     }else if ([status isEqualToString:@"1"]){
         
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
