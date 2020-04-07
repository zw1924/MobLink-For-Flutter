#import "MoblinkPlugin.h"

#import <MobLinkPro/MobLink.h>

#import <MobLinkPro/MLSDKScene.h>
#import <MOBFoundation/MOBFoundation.h>
#import <MobLinkPro/IMLSDKRestoreDelegate.h>
#import <MOBFoundation/MobSDK+Privacy.h>
typedef NS_ENUM(NSUInteger, MLSDKPluginMethod) {
    MLSDKPluginMethodGetMobId,
    MLSDKPluginMethodRestoreScene,
    MLSDKPluginMethodUploadPrivacyPermissionStatus,
    MLSDKPluginMethodSetAllowShowPrivacyWindow,
    MLSDKPluginMethodGetPrivacyPolicy,
    MLSDKPluginMethodSetPrivacyUI
};


@interface MoblinkPlugin() <IMLSDKRestoreDelegate>

@property (strong, nonatomic) NSDictionary *methodMap;

@property (copy, nonatomic) FlutterResult restoreResult;

@end

@implementation MoblinkPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"com.yoozoo.mob/moblink"
                                     binaryMessenger:[registrar messenger]];
    MoblinkPlugin *instance = [[MoblinkPlugin alloc] init];
    
    instance.methodMap = @{
        @"getMobId" : @(MLSDKPluginMethodGetMobId),
        @"restoreScene" : @(MLSDKPluginMethodRestoreScene),
        @"getPrivacyPolicy":@(MLSDKPluginMethodGetPrivacyPolicy),
        @"uploadPrivacyPermissionStatus":@(MLSDKPluginMethodUploadPrivacyPermissionStatus),
        @"setPrivacyUI":@(MLSDKPluginMethodSetPrivacyUI),
        @"setAllowShowPrivacyWindow":@(MLSDKPluginMethodSetAllowShowPrivacyWindow),
    };
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSNumber *methodType = self.methodMap[call.method];
    
    if (methodType)
    {
        switch (methodType.intValue)
        {
            case MLSDKPluginMethodGetMobId:
            {
                [self _getMobIdWithArgs:call.arguments result:result];
                break;
            }
            case MLSDKPluginMethodRestoreScene:
            {
                [self _restoreScene:result];
                break;
            }
            case MLSDKPluginMethodGetPrivacyPolicy:{
                [self _getPrivacyPolicy:call.arguments result:result];
            }
                break;
            case MLSDKPluginMethodSetAllowShowPrivacyWindow:{
                [self _setAllowShowPrivacyWindow:call.arguments result:result];
            }
                break;
            case MLSDKPluginMethodSetPrivacyUI:{
                [self _setPrivacyUI:call.arguments result:result];
            }
                break;
            case MLSDKPluginMethodUploadPrivacyPermissionStatus:{
                [self _uploadPrivacyPermissionStatus:call.arguments result:result];
            }
                break;
            default:
            {
                NSAssert(NO, @"The method requires an implementation ！");
                break;
            }
        }
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}

// 获取mobid
- (void)_getMobIdWithArgs:(NSDictionary *)args result:(FlutterResult)result
{
    MLSDKScene *scene = [MLSDKScene sceneForPath:args[@"path"] params:args[@"params"]];
    
    [MobLink getMobId:scene result:^(NSString *mobid, NSString *domain, NSError *error) {
        
        if (mobid)
        {
            NSDictionary *dic = @{
                @"mobid" : mobid,
                @"domain" : domain?:[NSNull null]
            };
            result(dic);
        }
        if (error)
        {
            NSDictionary *dic = @{
                @"error" : [self _covertError:error]
            };
            result(dic);
        }
    }];
}
- (void)_uploadPrivacyPermissionStatus:(NSDictionary *)args result:(FlutterResult)result{
    [MobSDK uploadPrivacyPermissionStatus:[args[@"status"]boolValue] onResult:^(BOOL success) {
        result(@{@"success":@(success)});
    }];
}

- (void)_setAllowShowPrivacyWindow:(NSDictionary *)args result:(FlutterResult)result{
    [MobSDK setAllowShowPrivacyWindow:[args[@"show"]boolValue]];
    result(@1);
}

- (void)_getPrivacyPolicy:(NSDictionary *)args result:(FlutterResult)result{
    [MobSDK getPrivacyPolicy:args[@"type"] compeletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        result(@{
            @"data":@{@"data":(data[@"content"]?:[NSNull null])},
            @"error":error?@{@"error":@"获取失败"}:[NSNull null]
        });
    }];
}

- (void)_setPrivacyUI:(NSDictionary *)args result:(FlutterResult)result{
    UIColor *color = nil;
    NSMutableArray *colors = [NSMutableArray array];
    NSString *colorString = args[@"backColor"];
    if ([colorString isKindOfClass:[NSNumber class]]) {
        color = [MOBFColor colorWithRGB:[colorString integerValue]];
    }
    
    NSArray *colorsNumber = args[@"oprationButtonColors"];
    if ([colorsNumber isKindOfClass:[NSArray class]]) {
        for (NSNumber *number in colorsNumber) {
            id colorElement = [MOBFColor colorWithRGB:[number integerValue]];
            if (colorElement) {
                [colors addObject:colorElement];
            }
        }
    }
    [MobSDK setPrivacyBackgroundColor:color operationButtonColor:colors];
    result(nil);
}
// 监听还原
- (void)_restoreScene:(FlutterResult)result
{
    [MobLink setDelegate:self];
    
    self.restoreResult = result;
}

- (id)_covertError:(NSError *)error
{
    if (error)
    {
        return @{@"code":@(error.code),@"userInfo":error.userInfo?:@{}};
    }
    
    return [NSNull null];
}


- (void)IMLSDKWillRestoreScene:(MLSDKScene *)scene Restore:(void (^)(BOOL, RestoreStyle))restoreHandler
{
    NSString *path = scene.path;
    NSString *mobid = scene.mobid;
    NSString *rawURL = scene.rawURL;
    NSString *className = scene.className;
    NSDictionary *params = scene.params;
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    if (path)
    {
        [mDic addEntriesFromDictionary:@{@"path" : path}];
    }
    if (mobid)
    {
        [mDic addEntriesFromDictionary:@{@"mobid" : mobid}];
    }
    if (rawURL)
    {
        [mDic addEntriesFromDictionary:@{@"rawURL" : rawURL}];
    }
    if (className)
    {
        [mDic addEntriesFromDictionary:@{@"className" : className}];
    }
    if (params)
    {
        [mDic addEntriesFromDictionary:@{@"params" : params}];
    }
    
    if (self.restoreResult)
    {
        self.restoreResult(mDic);
    }
    
    restoreHandler(NO, MLDefault);
}

@end
