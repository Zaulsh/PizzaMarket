//
//  FixedDetail_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/24/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "FixedDetail_ViewController.h"
#import "SWRevealViewController.h"
#import "ViewPager_ViewController.h"
#import "AddCart_ViewController.h"
@interface FixedDetail_ViewController (){
    NSString *cartacount_str;
}

@end

@implementation FixedDetail_ViewController
@synthesize proPrice_array,proName_array,proID_array,proDescrip_array,descrip_label,cart_label;
- (void)viewDidLoad {
    [super viewDidLoad];
    cartacount_str=[self get_shareddata:@"noti_count"];
    cart_label.text=cartacount_str;
    NSLog(@"carttt %@",cartacount_str);

    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    descrip_label.text=proDescrip_array;
    [descrip_label sizeToFit];
    //proID_array=[[NSMutableArray alloc]init];
    NSLog(@"hjhjkhkjhkjhkjh %@",proID_array);
    // Do any additional setup after loading the view.
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     tableView.separatorColor = [UIColor clearColor];
//    NSLog(@"   >>>>>>,,,,,,, >>>   str-4  tablearray  >> > > > > > > %@",_FixedplanImage_array);
    return [proName_array count];
    return [proPrice_array count];
//    return [_FixedplanImage_array count];
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    
    
    NSLog(@"   >>>>>>,,,,,,, >>>   str-5  [self.tablearray objectAtIndex:indexPath.row]  >> > > > > > > %@",[proPrice_array objectAtIndex:indexPath.row]);
    
    
    
    
    UILabel *lbl=(UILabel *)[cell viewWithTag:1];
    
    
    NSString * ssss1=[proName_array objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    lbl.text=[NSString stringWithFormat:@"%@",ssss1];
    UILabel *lbl1=(UILabel *)[cell viewWithTag:2];
    
    
    NSString * ssss2=[proPrice_array objectAtIndex:indexPath.row];
    NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    lbl1.text=[NSString stringWithFormat:@"%@",ssss2];
    
//
//    UIImageView *img=(UIImageView *)[cell viewWithTag:100];
//    
//    NSString *ssss3=[_FixedplanImage_array objectAtIndex:indexPath.row];
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        img.image = [UIImage imageWithData:data];
//    }];
//    
    //    btn=(UIButton *)[cell viewWithTag:4];
    //    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    lbl2=(UILabel *)[cell viewWithTag:5];
    //    lbl2.text = [NSString stringWithFormat:@"%i", self.counter];
    
    // NSString * ssss2=[proName_array objectAtIndex:indexPath.row];
    // NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss1);
    // lbl.text=[NSString stringWithFormat:@"%@",ssss1];
    
    
    
    return cell;
    
}
- (IBAction)back:(id)sender {
    
    ViewPager_ViewController *after_login= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPager_ViewController"];
    
    
    [self.navigationController pushViewController:after_login animated:NO];
    
    
}
-(IBAction)cartView:(id)sender{
    AddCart_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCart_ViewController"];
    
    //    //    after_reg1.data=usr1;
    [self.navigationController pushViewController:after_reg1 animated:NO];
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
