//
//  KDColorPickViewController.m
//  TextEditor
//
//  Created by hxx on 14-4-22.
//  Copyright (c) 2014年 hxx. All rights reserved.
//

#import "KDColorPickViewController.h"

@interface KDColorPickViewController ()
{
    UISlider *_redSlider;
    UISlider *_greenSlider;
    UISlider *_blueSlider;
    UIView *_redView;
    UIView *_greenView;
    UIView *_blueView;
    UIView *_RGBView;
}
@end

@implementation KDColorPickViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect tScreen = [UIScreen mainScreen].bounds;
    CGFloat offsetY = 50;
    CGRect sliderRect = CGRectMake(50, 50, tScreen.size.width -100, 5);
    CGRect labelRect = CGRectMake(20, 40, 30, 20);
    CGRect viewRect = CGRectMake(tScreen.size.width -40, 40, 30, 20);
    _redSlider = [[UISlider alloc] init];
    _greenSlider = [[UISlider alloc] init];
    _blueSlider = [[UISlider alloc] init];
    UILabel *redLabel = [[[UILabel alloc] init] autorelease];
    UILabel *greenLabel = [[[UILabel alloc] init] autorelease];
    UILabel *blueLabel = [[[UILabel alloc] init] autorelease];
    _redView = [[[UIView alloc] init] autorelease];
    _greenView = [[[UIView alloc] init] autorelease];
    _blueView = [[[UIView alloc] init] autorelease];
    [self initSliders:_redSlider rect:sliderRect offset:0];
    [self initSliders:_greenSlider rect:sliderRect offset:offsetY];
    [self initSliders:_blueSlider rect:sliderRect offset:offsetY*2];
    [self initLabels:redLabel rect:labelRect offset:0 text:@"红:"];
    [self initLabels:greenLabel rect:labelRect offset:offsetY text:@"绿:"];
    [self initLabels:blueLabel rect:labelRect offset:offsetY*2 text:@"蓝:"];
    [self initSliderViews:_redView rect:viewRect offset:0 color:[UIColor colorWithRed:_redSlider.value/255.0 green:0.0 blue:0.0 alpha:1.0]];
    [self initSliderViews:_greenView rect:viewRect offset:offsetY color:[UIColor colorWithRed:0.0 green:_greenSlider.value/255.0 blue:0.0 alpha:1.0]];
    [self initSliderViews:_blueView rect:viewRect offset:offsetY*2 color:[UIColor colorWithRed:0.0 green:0.0 blue:_blueSlider.value/255.0 alpha:1.0]];
    _RGBView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, tScreen.size.width, 20)];
    _RGBView.backgroundColor = [UIColor colorWithRed:_redSlider.value/255.0 green:_greenSlider.value/255.0 blue:_blueSlider.value/255.0 alpha:1.0];
    [self.view addSubview:_RGBView];
    
    [_redSlider addTarget:self action:@selector(sliderChanged_red:) forControlEvents:UIControlEventValueChanged];
    [_greenSlider addTarget:self action:@selector(sliderChanged_green:) forControlEvents:UIControlEventValueChanged];
    [_blueSlider addTarget:self action:@selector(sliderChanged_blue:) forControlEvents:UIControlEventValueChanged];
}

- (void)initSliders:(UISlider *)slider rect:(CGRect)sliderRect offset:(CGFloat)offsetY
{
    slider.maximumValue = 255;
    slider.minimumValue = 0;
    slider.value = 255;
    sliderRect.origin.y += offsetY;
    slider.frame = sliderRect;
    [self.view addSubview:slider];
}
- (void)initLabels:(UILabel *)label rect:(CGRect)labelRect offset:(CGFloat)offsetY text:(NSString *)str
{
    labelRect.origin.y +=offsetY;
    label.frame = labelRect;
    label.text = str;
    [self.view addSubview:label];
}
- (void)initSliderViews:(UIView *)view rect:(CGRect)viewRect offset:(CGFloat)offsetY color:(UIColor *)color
{
    viewRect.origin.y +=offsetY;
    view.frame = viewRect;
    view.backgroundColor = color;
    [self.view addSubview:view];
}
- (void)sliderChanged_red:(id)sender
{
    _redView.backgroundColor = [UIColor colorWithRed:_redSlider.value/255.0 green:0.0 blue:0.0 alpha:1.0];
    _RGBView.backgroundColor = [UIColor colorWithRed:_redSlider.value/255.0 green:_greenSlider.value/255.0 blue:_blueSlider.value/255.0 alpha:1.0];
}
- (void)sliderChanged_green:(id)sender
{
    _greenView.backgroundColor = [UIColor colorWithRed:0.0 green:_greenSlider.value/255.0 blue:0.0 alpha:1.0];
    _RGBView.backgroundColor = [UIColor colorWithRed:_redSlider.value/255.0 green:_greenSlider.value/255.0 blue:_blueSlider.value/255.0 alpha:1.0];
}
- (void)sliderChanged_blue:(id)sender
{
    _blueView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:_blueSlider.value/255.0 alpha:1.0];
    _RGBView.backgroundColor = [UIColor colorWithRed:_redSlider.value/255.0 green:_greenSlider.value/255.0 blue:_blueSlider.value/255.0 alpha:1.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
