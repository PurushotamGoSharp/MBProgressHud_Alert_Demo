//
//  ViewController.m
//  Login_Demo
//
//  Created by Jenkins on 01/09/16.
//  Copyright © 2016 srinivas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *txtUserName;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)action:(id)sender;

@end

@implementation ViewController
{
    postman * postMan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    postMan = [[postman alloc]init];
    NSLog(@"MBProgessHud Alert Message demo");
   
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)callApi
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@", pBaseUrl,pLoginUrl];
    NSString * parameters = [NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\",\"Password\":\"%@\",\"AppTypeCode\":\"1IBT8U\",\"ApplicableVersionCode\":\"KP18Z7\"}}",_txtUserName.text,_txtPassword.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postMan post:urlString withParameter:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"response: %@",responseObject);
        [self getData:responseObject];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"success");
        [self mbProgress:@"Login Successful"];
    }
          failour:^(NSURLSessionDataTask *operation, NSError *error) {
              NSLog(@"error: %@",[error localizedDescription]);
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              NSLog(@"failour %@", [operation response]);
              NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
              NSLog(@"%@",errResponse);
              
          }];
}

-(void)getData:(NSDictionary *)jsonDictionary
{
    
}




- (IBAction)action:(id)sender
{
    [self.view endEditing:YES];
    if (![self validateLoginFields])
    {
        //  TOAST_MESSAGE(@"Username and Password is required.");
        return;
    }

    
     [self callApi];
}


- (BOOL)validateLoginFields
{
    NSString *userName = self.txtUserName.text;
    NSString *password = self.txtPassword.text;
    BOOL goodToGo = YES;
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    if (userName.length == 0)
    {
        goodToGo = NO;
        [mutableString appendString:@"Email Id is required"];
    }
    
   else if (![self stringIsValidEmail:self.txtUserName.text]&&userName.length!=0)
    {
        goodToGo = NO;
        [mutableString appendString:@"Please enter a valid Email Id"];
    }
    
   if (password.length == 0)
    {
        goodToGo = NO;
        if (mutableString.length>0)
        {
            [mutableString appendString:@"\nPassword is required"];
        }
        else
        {
            [mutableString appendString:@"Password is required"];
        }
    }
    
   if (!goodToGo)
    {
        [self mbProgress:mutableString];
    }
    return goodToGo;
    
}

- (void)mbProgress:(NSString*)message
{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText=message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}


-(BOOL)stringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL decision = [emailTest evaluateWithObject:checkString];
    
    return decision;
}

@end
