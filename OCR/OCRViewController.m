//
//  OCRViewController.m
//  OCR
//
//  Created by Matthew Teece on 2/13/13.
//  Copyright (c) 2013 Matthew Teece. All rights reserved.
//

#import "OCRViewController.h"
#import "Tesseract.h"

@interface OCRViewController ()

@end

@implementation OCRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *sampleImage = [UIImage imageNamed:@"image_sample.jpg"];
    
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"];
    
    // Test UIImage
    [tesseract setImage:sampleImage];
    [tesseract recognize];    
    NSLog(@"UIImage: %@", [tesseract recognizedText]);
    
    // Test PIX
    PIX *pImg = [Tesseract convertUIImage2Pix:sampleImage];
    [tesseract setPix:pImg];
    [tesseract recognize];
    NSLog(@"PIX: %@", [tesseract recognizedText]);
    
    // Test Otsu Adaptive Binarize
    PIX *pixGray, *pixBin;
    pixGray = pixConvertRGBToGrayFast(pImg);    
    // Binarize
    pixOtsuAdaptiveThreshold(pixGray, 32, 32, 2, 2, 0.1, NULL, &pixBin);    
    [tesseract setPix:pixBin];
    [tesseract recognize];
    NSLog(@"BIN: %@", [tesseract recognizedText]);
    
    // Save binarize result to a bmp file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *binFilePath = [documentsDirectory stringByAppendingPathComponent:@"binOtsuAdaptive.bmp"];
    NSLog(@"%@", binFilePath);
    pixWriteImpliedFormat([binFilePath UTF8String], pixBin, 100, 0);
    
    pixDestroy(&pImg);
    pixDestroy(&pixGray);
    pixDestroy(&pixBin);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
