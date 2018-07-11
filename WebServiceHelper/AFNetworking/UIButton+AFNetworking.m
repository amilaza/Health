//
//  UIButton+AFNetworking.m
//  GetWithIt!
//
//  Created by Apoorve Tyagi on 9/25/13.
//  Copyright (c) 2013 Halosys Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "UIButton+AFNetworking.h"

static char TAG_ACTIVITY_INDICATOR_BUTTON;


#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
@interface AFButtonImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

#pragma mark -

static char kAFImageRequestOperationObjectKey;

@interface UIButton (_AFNetworking)
@property (readwrite, nonatomic, retain, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
@end

@implementation UIButton (_AFNetworking)
@dynamic af_imageRequestOperation;
@end

#pragma mark -

@implementation UIButton (AFNetworking)

- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR_BUTTON);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR_BUTTON, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)createActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle) activityStyle {
    
    if ([self activityIndicator] == nil) {
//        [self setBackgroundColor:[UIColor lightGrayColor]];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityStyle];
        [self.activityIndicator setColor:[UIColor clearColor]];
        self.activityIndicator.autoresizingMask = UIViewAutoresizingNone;
        
        //calculate the correct position
        float width = self.activityIndicator.frame.size.width;
        float height = self.activityIndicator.frame.size.height;
        float x = (self.frame.size.width / 2.0) - width/2;
        float y = (self.frame.size.height / 2.0) - height/2;
        self.activityIndicator.frame = CGRectMake(x, y, width, height);
        
        self.activityIndicator.hidesWhenStopped = YES;
        [self addSubview:self.activityIndicator];
    }
    
    [self.activityIndicator startAnimating];
    
}

- (void)removeActivityIndicator {
    if ([self activityIndicator]) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [[self activityIndicator] removeFromSuperview];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage forState:state success:nil failure:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [self setBackgroundImageWithURLRequest:request placeholderImage:placeholderImage forState:state success:nil failure:nil];
}

- (void)setBackgroundImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                      forState:(UIControlState)state
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    
    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        [self setBackgroundImage:cachedImage forState:state];
        self.af_imageRequestOperation = nil;
        
        if (success) {
            success(nil, nil, cachedImage);
        }
    } else {
        [self setBackgroundImage:placeholderImage forState:state];
        
        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                [self setBackgroundImage:responseObject forState:state];
                self.af_imageRequestOperation = nil;
            }
            
            if (success) {
                success(operation.request, operation.response, responseObject);
            }
            
            [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                self.af_imageRequestOperation = nil;
            }
            
            if (failure) {
                failure(operation.request, operation.response, error);
            }
            
        }];
        
        self.af_imageRequestOperation = requestOperation;
        
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}


- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                      forState:(UIControlState)state
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    
    
    [self createActivityIndicatorWithStyle:UIActivityIndicatorViewStyleGray];

    
    [self cancelImageRequestOperation];
    
    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        [self removeActivityIndicator];

        [self setImage:cachedImage forState:state];
        self.af_imageRequestOperation = nil;
        
        if (success) {
            [self removeActivityIndicator];

            success(nil, nil, cachedImage);
        }
    } else {
        [self setImage:placeholderImage forState:state];
        
        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                [self removeActivityIndicator];

                [self setImage:responseObject forState:state];
                self.af_imageRequestOperation = nil;
            }
            
            if (success) {
                [self removeActivityIndicator];

                success(operation.request, operation.response, responseObject);
            }
            
            [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                self.af_imageRequestOperation = nil;
            }
            
            if (failure) {
                failure(operation.request, operation.response, error);
            }
            
        }];
        
        self.af_imageRequestOperation = requestOperation;
        
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    
    if (!_af_imageRequestOperationQueue) {
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:8];
    }
    
    return _af_imageRequestOperationQueue;
}

+ (AFButtonImageCache *)af_sharedImageCache {
    static AFButtonImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[AFButtonImageCache alloc] init];
    });
    
    return _af_imageCache;
}

#pragma mark -

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

@end

#pragma mark -

static inline NSString * AFButtonImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFButtonImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
	return [self objectForKey:AFButtonImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:AFButtonImageCacheKeyFromURLRequest(request)];
    }
}

@end

#endif
