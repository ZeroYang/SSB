#import <QuartzCore/QuartzCore.h>
#import "SBMenuItem.h"
#import "AppDelegate.h"
//#import "Utils.h"
//#import "Storage.h"

#import "AppViewController.h"

@interface SBMenuItem ()
@property (nonatomic) CGPoint offsetFromTouchToOriginalMenuItemCenter;
@end

#define REMOVE_BTN_WIDTH (40)

@implementation SBMenuItem

@synthesize delegate;
@synthesize preCenter;
@synthesize appData;
@synthesize control;

#pragma mark - UI actions

- (void)clickItem:(id)sender
{
    if ([delegate isHolding]) {
        return;
    }
    
    if (isInEditingMode) {
        // fix ios 5 Gesture bug
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
            if ([sender respondsToSelector:@selector(locationInView:)]) {
                CGPoint point = [sender locationInView:self];
                CGRect frame = CGRectMake(0, 0, REMOVE_BTN_WIDTH, REMOVE_BTN_WIDTH);
                if (CGRectContainsPoint(frame, point)) {
                    [self removeButtonClicked:sender];
                    return;
                }
            }
        }
        
        [delegate disableEditingMode];
        return;
    }
    
    if (isAddBtn) {

    } else {
        AppViewController *app = [[AppViewController alloc] initWithNibName:nil bundle:nil];
        app.appData = appData;
        [control.navigationController pushViewController:app animated:NO];
    }
}

- (void)pressedLong:(UILongPressGestureRecognizer *)sender
{
    if ([delegate isHolding] && NO == isHolding) {
        // double tag press protect
        return;
    }
    
    if (isAddBtn) {
        return;
    }
    
    CGPoint point = [sender locationInView:self.superview];
    CGPoint newCenter;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if (!isInEditingMode) {
                [delegate enableEditingMode];
            }
            [self enableHolding];
            
            self.offsetFromTouchToOriginalMenuItemCenter = CGPointMake(point.x - self.center.x,
                                                               point.y - self.center.y);
            break;
        case UIGestureRecognizerStateChanged:
            newCenter.x = point.x - self.offsetFromTouchToOriginalMenuItemCenter.x;
            newCenter.y = point.y - self.offsetFromTouchToOriginalMenuItemCenter.y;
            self.center = newCenter;
            [delegate checkMove:self.tag point:point];
            break;
        case UIGestureRecognizerStateEnded:
            // check point,and find a place to locate
            [self disableHolding];
            break;
        default:
            break;
    }
}

- (void)removeButtonClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:[NSString stringWithFormat:@"删除%@", appData.name]
						  message:@"您确定要删除吗？"
						  delegate:self
						  cancelButtonTitle:@"确认"
						  otherButtonTitles:@"取消", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [delegate removeFromSpringboard:self.tag];
    }
}

#pragma mark - Custom Methods

- (void)removeFromSuperviewWithAnimate
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                0,
                                0);
        self.removeButton.frame = CGRectMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)enableHolding
{
    if ([delegate isHolding]) {
        return;
    }
    
    [delegate startHolding];
    isHolding = YES;
    // record for reset
    preCenter = self.center;
    [self.superview bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
                         self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         self.alpha = 0.8;
					 }
					 completion:nil];
}

- (void)disableHolding
{
    // editing -> holding, time is small
    longPress.minimumPressDuration = 0.2;
    if (!isHolding) {
        // double tag press protect for wrong set center
        return;
    }
    [delegate stopHolding];
    isHolding = NO;
    
    [UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
                         // reset to right position
                         self.center = preCenter;
                         self.transform = CGAffineTransformMakeScale(0.8, 0.8);
                         self.alpha = 1.0;
					 }
					 completion:nil];
}

- (void)enableEditing
{
    if (isInEditingMode == YES) {
        return;
    }
    
    // put item in editing mode
    isInEditingMode = YES;
    
    // make the remove button visible
    self.removeButton.hidden = NO;
    
    [UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
                         if (isAddBtn) {
                             self.hidden = YES;
                         } else {
                             self.transform = CGAffineTransformMakeScale(0.8, 0.8);
                             self.alpha = 1.0;
                         }
					 }
					 completion:nil];
}

- (void)disableEditing
{
    // back to normal, restore to big longPress
    longPress.minimumPressDuration = 0.5;
    
    [UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
                         if (isAddBtn) {
                             self.hidden = NO;
                         } else {
                             self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             self.alpha = 1.0;
                         }
					 }
					 completion:nil];
    
    self.removeButton.hidden = YES;
    isInEditingMode = NO;
}

// statusImage retina in initResourceOfCard
- (void)initStatusImage
{
}

#pragma mark - Initialization

- (void)initResourceOfApp
{
    // initResourceOfCard will call from time to time
    if (imageIcon ) {
        imageIcon  = nil;
    }
    if (stausImage) {
        stausImage = nil;
    }
    
    if (appData ) {
        isAddBtn = NO;
        isRemovable = YES;

        imageIcon  = [UIImage imageNamed:appData.icon];
        if (!imageIcon ) {
            imageIcon  = [UIImage imageNamed:@"defaultimg.png"];
        }
        [self initStatusImage];
    } else {
        isAddBtn = YES;
        imageIcon  = [UIImage imageNamed:@"addcard.png"];
    }
}

- (id)initWithApp:(AppData  *)app
{
    self = [super initWithFrame:CGRectMake(0, 0, MENUITEM_WIDTH + DELETE_BTN_OFFSET, MENUITEM_HEIGHT + DELETE_BTN_OFFSET)];
    if (self) {

        isRemovable = NO;
        appData  = app;
        [self initResourceOfApp];
        self.backgroundColor = [UIColor clearColor];
        isInEditingMode = NO;
        
        // place a clickable button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(DELETE_BTN_OFFSET, DELETE_BTN_OFFSET, MENUITEM_WIDTH, MENUITEM_HEIGHT)];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self
                   action:@selector(clickItem:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(pressedLong:)];
        // normal -> holding mode, longPress time is big
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
        
        if (isRemovable) {
            // place a remove button on top right corner for removing item from the board
            UIImage *delImage = [UIImage imageNamed:@"card_delete.png"];
            self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            // make click range large
            [self.removeButton setFrame:CGRectMake(0, 0, REMOVE_BTN_WIDTH, REMOVE_BTN_WIDTH)];
            // image size 26,26
            [self.removeButton setImageEdgeInsets:UIEdgeInsetsMake(26 - REMOVE_BTN_WIDTH, 26 - REMOVE_BTN_WIDTH, 0.0, 0.0)];
            [self.removeButton setImage:delImage forState:UIControlStateNormal];
            [self.removeButton setImage:delImage forState:UIControlStateDisabled];
            self.removeButton.backgroundColor = [UIColor clearColor];
            [self.removeButton addTarget:self
                             action:@selector(removeButtonClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
            self.removeButton.tag = self.tag;
            self.removeButton.hidden = YES;
            [self addSubview:self.removeButton];
        }
        
        infoLine = [UIImage imageNamed:@"card_info_bar_line.png"];
        // must retian to avoid crash,autorelease object is dengrous
        backGroundImage = [UIImage imageNamed:@"card_BG.png"];
    }
    return self;
}


# pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    //[self initResourceOfApp];
    
    [backGroundImage drawAtPoint:CGPointMake(DELETE_BTN_OFFSET, DELETE_BTN_OFFSET)];
    
    // draw background
    CGFloat backHeight = MENUITEM_HEIGHT;
    if (!isAddBtn) {
        backHeight -= MENUITEM_YUE_HEIGHT;
    }
    [imageIcon  drawInRect:CGRectMake(1 + DELETE_BTN_OFFSET, 1 + DELETE_BTN_OFFSET, MENUITEM_WIDTH - 2, backHeight - 2)];
    if (isAddBtn) {
        return;
    }
    
    if (appData.name) {
        [[UIColor whiteColor] set];
        //add shadow
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGColorRef blcolor = [[UIColor colorWithRed:0x2e/255.0 green:0x2e/255.0 blue:0x2e/255.0 alpha:1.0] CGColor];
        CGContextSetShadowWithColor(context, CGSizeMake(1.0f, 1.0f), 1.0f, blcolor);
        [appData .name drawAtPoint:CGPointMake(5 + DELETE_BTN_OFFSET, 5 + DELETE_BTN_OFFSET) withFont:[UIFont systemFontOfSize:14]];
        //end of shadow
        CGContextRestoreGState(context);
    }
    
}


@end
