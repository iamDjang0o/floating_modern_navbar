#import "FloatingModernNavbarPlugin.h"
#import <UIKit/UIKit.h>

@interface FMNTraitObserver : UIView
@property(nonatomic, copy) void (^onChange)(void);
@end
@implementation FMNTraitObserver
- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.onChange) self.onChange();
}
- (void)safeAreaInsetsDidChange {
  [super safeAreaInsetsDidChange];
  if (self.onChange) self.onChange();
}
- (void)traitCollectionDidChange:(UITraitCollection *)previous {
  [super traitCollectionDidChange:previous];
  if (self.onChange) self.onChange();
}
@end

@interface FloatingModernNavbarPlugin ()
@property(nonatomic, strong) FlutterMethodChannel *channel;
@property(nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic, strong) FMNTraitObserver *observer;
@property(nonatomic, copy) NSDictionary *lastLayout;
@end

@implementation FloatingModernNavbarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FloatingModernNavbarPlugin *plugin = [FloatingModernNavbarPlugin new];
  plugin.registrar = registrar;
  plugin.channel = [FlutterMethodChannel
      methodChannelWithName:@"floating_modern_navbar/layout"
      binaryMessenger:registrar.messenger];
  [registrar addMethodCallDelegate:plugin channel:plugin.channel];
  [registrar publish:plugin];
}
- (NSString *)edge {
  // Compile on older SDKs without guessing enum values or device identifiers.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 270100
  if (@available(iOS 27.1, *)) {
    switch (self.observer.traitCollection.verticalBarEdge) {
      case UIVerticalBarEdgeLeading: return @"left";
      case UIVerticalBarEdgeTrailing: return @"right";
      default: break;
    }
  }
#endif
  return @"bottom";
}
- (NSDictionary *)layout {
  UIView *host = self.observer.superview;
  NSString *edge = [self edge];
  NSMutableDictionary *layout = [@{@"edge": edge,
    @"width": @(host.bounds.size.width), @"height": @(host.bounds.size.height)} mutableCopy];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 270100
  if (@available(iOS 27.1, *)) {
    if (host && ![edge isEqualToString:@"bottom"]) {
      UIRectEdge physicalEdge = [edge isEqualToString:@"left"] ? UIRectEdgeLeft : UIRectEdgeRight;
      UIViewLayoutRegion *region = [UIViewLayoutRegion layoutRegionForBarOnEdge:physicalEdge extent:72];
      CGRect frame = UIEdgeInsetsInsetRect(host.bounds, [host edgeInsetsForLayoutRegion:region]);
      if (!CGRectIsEmpty(frame) && !CGRectIsInfinite(frame) && !CGRectIsNull(frame)) {
        layout[@"bar"] = @{@"x": @(frame.origin.x), @"y": @(frame.origin.y),
          @"width": @(frame.size.width), @"height": @(frame.size.height)};
      }
    }
  }
#endif
  return layout;
}
- (void)publish {
  NSDictionary *layout = [self layout];
  if (![layout isEqualToDictionary:self.lastLayout]) {
    self.lastLayout = layout;
    [self.channel invokeMethod:@"layoutChanged" arguments:layout];
  }
}
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if (![call.method isEqualToString:@"getEdge"] && ![call.method isEqualToString:@"getLayout"]) {
    result(FlutterMethodNotImplemented);
    return;
  }
  UIView *host = self.registrar.viewController.view;
  if (host && self.observer.superview != host) {
    [self.observer removeFromSuperview];
    self.observer = [[FMNTraitObserver alloc] initWithFrame:host.bounds];
    self.observer.userInteractionEnabled = NO;
    self.observer.accessibilityElementsHidden = YES;
    self.observer.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    __weak FloatingModernNavbarPlugin *weakSelf = self;
    self.observer.onChange = ^{ [weakSelf publish]; };
    [host insertSubview:self.observer atIndex:0];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 270100
    if (@available(iOS 27.1, *)) {
      [self.observer registerForTraitChanges:UITraitCollection.systemTraitsAffectingVerticalBarEdge
          withHandler:^(id<UITraitEnvironment> environment, UITraitCollection *previous) {
            [weakSelf publish];
          }];
    }
#endif
  }
  result([call.method isEqualToString:@"getEdge"] ? [self edge] : [self layout]);
}
- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self.observer.onChange = nil;
  [self.observer removeFromSuperview];
  [self.channel setMethodCallHandler:nil];
}
@end
