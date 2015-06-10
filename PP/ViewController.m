//
//  ViewController.m
//  PP
//
//  Created by chris dong on 2015-06-05.
//  Copyright (c) 2015 Trader. All rights reserved.
//

#import "ViewController.h"
#import "PayPalPayment.h"
#import "PayPalInvoiceItem.h"

@implementation ViewController

- (void)addLabelWithText:(NSString *)text andButtonWithType:(PayPalButtonType)type withAction:(SEL)action {
    UIButton *button = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:action andButtonType:type];
    [self.view addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLabelWithText:@"Simple Payment" andButtonWithType:BUTTON_294x43 withAction:@selector(simplePayment)];
}

- (void)simplePayment {
    
    //optional, set shippingEnabled to TRUE if you want to display shipping
    //options to the user, default: TRUE
    [PayPal getPayPalInst].shippingEnabled = TRUE;
    
    //optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
    //shipping and tax based on the user's address choice, default: FALSE
    [PayPal getPayPalInst].dynamicAmountUpdateEnabled = TRUE;
    
    //optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
    [PayPal getPayPalInst].feePayer = FEEPAYER_EACHRECEIVER;
    
    //for a payment with a single recipient, use a PayPalPayment object
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.recipient = @"example-merchant-1@paypal.com";
    payment.paymentCurrency = @"USD";
    payment.description = @"Teddy Bear";
    payment.merchantName = @"Joe's Bear Emporium";
    
    //subtotal of all items, without tax and shipping
    payment.subTotal = [NSDecimalNumber decimalNumberWithString:@"10"];
    
    //invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
    payment.invoiceData = [[PayPalInvoiceData alloc] init];
    payment.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithString:@"2"];
    payment.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithString:@"0.35"];
    
    //invoiceItems is a list of PayPalInvoiceItem objects
    //NOTE: sum of totalPrice for all items must equal payment.subTotal
    //NOTE: example only shows a single item, but you can have more than one
    payment.invoiceData.invoiceItems = [NSMutableArray array];
    PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init];
    item.totalPrice = payment.subTotal;
    item.name = @"Teddy";
    [payment.invoiceData.invoiceItems addObject:item];
    
    [[PayPal getPayPalInst] checkoutWithPayment:payment];
}

- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
    NSLog(@"severity: %@", severity);
    NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
    NSLog(@"category: %@", category);
    NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
    NSLog(@"errorId: %@", errorId);
    NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
    NSLog(@"message: %@", message);
}

- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
    NSLog(@"severity: %@", severity);
    NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
    NSLog(@"category: %@", category);
    NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
    NSLog(@"errorId: %@", errorId);
    NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
    NSLog(@"message: %@", message);
}

- (void)paymentCanceled {
    NSLog(@"payment canceled");
}

- (void)paymentLibraryExit {
    NSLog(@"payment lib exit");
}

@end
