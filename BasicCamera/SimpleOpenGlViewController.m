//
//  SimpleOpenGlViewController.m
//  BasicCamera
//
//  Created by k16 on 12/07/27.
//
//

#import "SimpleOpenGlViewController.h"


@interface SimpleOpenGlViewController ()

@end

@implementation SimpleOpenGlViewController

@synthesize gl = _gl;


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
    
    self.gl = [[SimpleOpenGL alloc] initWithCoder:nil];
    [self.gl startAnimation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
