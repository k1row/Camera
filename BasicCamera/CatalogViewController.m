//
//  CatalogViewController.m
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/07/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CatalogViewController.h"

@interface CatalogViewController ()

@end

@implementation CatalogViewController
@synthesize imageView = _imageView;
@synthesize tableView = _tableView;
@synthesize filter = _filter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"world" ofType:@"png"];
                      
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    self.filter = [[FilterController alloc] initWithImage:image AndView:self.imageView];
    
    NSArray *supportedFilters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    LOG(@"iOS supports %@",[supportedFilters description]);
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#define FILTERS1 [NSArray arrayWithObjects:@"Origin",@"Pro?",@"Country?",@"Diana?",@"Amaro?",nil]
#define FILTERS2 [NSArray arrayWithObjects:@"Sepia 1.0",@"Sepia 0.5",@"MonoChrome",@"ColorControl",@"RadialGradient",@"Vignette",@"Vibrance",@"BurnBlend",@"HueAdjust", nil]

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
            return [FILTERS1 count];
            break;
        case 1:
            return [FILTERS2 count];
            break;
            
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NormalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    
    // Configure the cell...
    
    switch (indexPath.section) {
        case 0:
                cell.textLabel.text = [FILTERS1 objectAtIndex:indexPath.row];
            break;
        case 1:
                cell.textLabel.text = [FILTERS2 objectAtIndex:indexPath.row];
            break;

    }
    
    

    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Original";
            break;
        default:
            return @"BuildIn";
            break;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = nil;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self.filter doOrigin];
                    break;
                case 1:
                    [self.filter doPro];
                    break;
                case 2:
                    [self.filter doCountory];
                    break;
                case 3:
                    [self.filter doDiana];
                    break;
                case 4:
                    [self.filter doAmaro];
                    break;

            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.filter doSepia:1.0];
                    break;
                case 1:
                    [self.filter doSepia:0.5];
                    break;
                case 2:
                    [self.filter doMonoChrome];
                    break;
                case 3:
                    [self.filter doColorControl];
                    break;
                case 4:
                    [self.filter doRadialGradient];
                    break;
                case 5:
                    [self.filter doVignette];
                    break;
                case 6:
                    [self.filter doVibrance];
                    break;
                case 7:
                    [self.filter doBurnBlend];
                    break;
                case 8:
                    [self.filter doHueAdjust:0.5];
                    break;
                default:
                    break;
            }
            break;
    }
    
      


        
}



@end
