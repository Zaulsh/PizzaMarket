//
//  MyOrder_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 11/28/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "MyOrder_ViewController.h"
#import "DeliverySchedule_ViewController.h"
#import "SWRevealViewController.h"
#import "StringConstants.h"

@interface MyOrder_ViewController (){
    NSString *userId;
    NSString *msg;
    NSString *status;
    NSMutableArray *name_arr;
    NSMutableArray *qty_arr;
    NSString *OrderNumDelivery;
    NSString *OrCost_str;
    NSString *SubscriptionName;
    NSString *order;
}

@end

@implementation MyOrder_ViewController
@synthesize indicator,indi_view,cost_label,NoDel_label,Subs_label,drawer_btn;
- (void)viewDidLoad {
    [super viewDidLoad];
    indi_view.hidden=YES;
    indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
    indicator.startAnimating;

    userId=[self get_shareddata:@"ID"];
    NSLog(@"nameeee %@",userId);
    [self order];
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [drawer_btn addTarget:self.revealViewController
                   action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.tableview reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)order{
    indi_view.hidden=NO;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@myorder", BASE_URL]];
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:url];
    [rq setHTTPMethod:@"POST"];
    NSString *post = [NSString stringWithFormat:@"&userid=%@",userId];
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
            
             indi_view.hidden=YES;
             msg = [dictionary valueForKey:@"msg"];
             NSLog(@"Count %@", msg);
             status = [dictionary valueForKey:@"status"];
             //
              NSLog(@"Count %@", status);

             
             NSDictionary *   results = [dictionary valueForKey:@"orderdetails"];
             NSLog(@"Count %@", results);
             
             name_arr=[[NSMutableArray alloc]init];
             qty_arr = [[NSMutableArray alloc]init];
             
             OrderNumDelivery =[results objectForKey:@"OrderNumDelivery"];
             NSLog(@"   >>>>>>,,,,fixedplan,,, %@",OrderNumDelivery);
             NoDel_label.text=OrderNumDelivery;

             OrCost_str =[results objectForKey:@"Ordercost"];
             NSLog(@"   >>>>>>,,,,fixedplan,,, %@",OrCost_str);
             cost_label.text=OrCost_str;

             SubscriptionName =[results objectForKey:@"SubscriptionName"];
             NSLog(@"   >>>>>>,,,,fixedplan,,, %@",SubscriptionName);
             Subs_label.text=SubscriptionName;

             order =[results objectForKey:@"OrderID"];
             NSLog(@"   >>>>>>,,,,fixedplan,,, %@",order);
             

              NSDictionary *   product = [results valueForKey:@"product"];
             NSLog(@"producttttttt %@",product);
                           for (NSDictionary *Dicproduct in product) {
                               NSString *Name =[Dicproduct objectForKey:@"ProductName"];
                               NSLog(@"   >>>>>>,,,,fixedplan,,, %@",Name);
                               [name_arr addObject:Name];
                               NSString *Price =[Dicproduct objectForKey:@"Productqty"];
                               NSLog(@"   >>>>>>,,,,fixedplan,,, %@",Price);
                               [qty_arr addObject:Price];
                               

                           }
             NSLog(@"dictionary %@",dictionary);
             [self.tableview reloadData];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    tableView.separatorColor = [UIColor clearColor];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-4  tablearray  >> > > > > > > %@",name_arr);
    return [name_arr count];
    return [qty_arr count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    
    NSLog(@"   >>>>>>,,,,,,, >>>   str-5  [self.tablearray objectAtIndex:indexPath.row]  >> > > > > > > %@",[qty_arr objectAtIndex:indexPath.row]);
    
    
    
    
    UILabel *lbl=(UILabel *)[cell viewWithTag:1];
    
    
    NSString * ssss1=[name_arr objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    lbl.text=[NSString stringWithFormat:@"%@",ssss1];
    
    UILabel *lbl1=(UILabel *)[cell viewWithTag:2];
    
    
    NSString * ssss2=[qty_arr objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    lbl1.text=[NSString stringWithFormat:@"%@",ssss2];
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
 
    
}
-(IBAction)Detail_btn:(id)sender{
    DeliverySchedule_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeliverySchedule_ViewController"];
    
    event.orderid_str=order;
    
    [self.navigationController pushViewController:event animated:NO];

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
