//
//  Confirmation_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 12/1/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "Confirmation_ViewController.h"
#import "ThankYou_ViewController.h"
@interface Confirmation_ViewController ()
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end

@implementation Confirmation_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = NO;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
 //   [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
}
- (IBAction)pay {
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"39.95"];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Awesome saws";
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    // payment.shippingAddress = @"US"; // a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    NSError *error;
    if ([confirmation length] > 0 && error == nil){
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:confirmation options:0 error:&parseError];
        // NSLog(@"Server Response (we want to see a 200 return code) %@",response);
        NSLog(@"dictionary %@",dictionary);
        NSDictionary *  results = [dictionary valueForKey:@"response"];
        NSLog(@"results %@",dictionary);
        //
        //        //NSMutableArray *    donationID_array=[[NSMutableArray alloc]init];
        //
        //        //  for (NSDictionary *groupDic in results) {
        //        indi_view.hidden=YES;
        //        [self alertStatus:@"Login Successfully" :@"" :0];
        //
        NSString * donationCat_str = [results objectForKey:@"id"];
        
        NSLog(@"   >>>>>>,,,,category,,, %@",donationCat_str);
        //        const NSString *currentLevel1= donationCat_str;
        //        [preferences1 setValue:currentLevel1 forKey:currentLevelKey1];
        //
        //        //  Save to disk
        //        const BOOL didSave1 = [preferences1 synchronize];
        //        NSLog(@"key =====: %@", currentLevelKey1);
        //        NSLog(@"value =====: %@", currentLevel1);
        //
        NSString *ID_str=[results objectForKey:@"state"];
        NSLog(@"emailll %@",ID_str);
        //        NSString *inStr2 = [NSString stringWithFormat: @"%@", ID_str];
        //        NSLog(@"key =====: %@",inStr2);
        //        [self sharedata:@"ID" :inStr2];
        //
        //
        //
        //        if (!didSave1)
        //        {
        //            //                        value=@"";
        //            //  Couldn't save (I've never seen this happen in real world testing)
        //        }
        //
        //
        //        // [donationID_array addObject:donationCat_str];
        //        //    }
        //
        //    }
        //    else if ([data length] == 0 && error == nil){
        //        NSLog(@"no data returned");
        //
        //        [self alertStatus:@"username or password" :@"invalid" :0];
        //        indi_view.hidden=YES;
        //        //no data, but tried
        //    }
        //    else if (error != nil)
        //    {
        //        NSLog(@"there was a download error");
        //        indi_view.hidden=YES;
        //        [self alertStatus:@"Network error" :@"" :0];
        //        //couldn't download
        //
        //    }
    }
    ThankYou_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ThankYou_ViewController"];
    
    //    after_reg1.data=usr1;
    [self.navigationController pushViewController:after_reg1 animated:NO];
    
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
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
