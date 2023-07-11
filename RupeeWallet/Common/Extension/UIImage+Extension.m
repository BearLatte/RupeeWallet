//
//  UIImage+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSData *)compressImageToMaxLength:(NSInteger)maxLength {
    NSInteger tempMaxLength = maxLength;
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if(data.length <= maxLength) {
        return UIImageJPEGRepresentation(self, compression);
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    
    for(NSInteger i = 0; i < 6; i++) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < tempMaxLength * 0.9) {
            min = compression;
        } else if (data.length > tempMaxLength) {
            max = compression;
        } else {
            break;
        }
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    
    if(data.length < tempMaxLength) { return  data; }
    
    NSInteger lastDataLength = 0;
    
    while (data.length > tempMaxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)tempMaxLength / (CGFloat)data.length;
        RWLog(@"Ratio = %f", ratio);
        CGSize size = CGSizeMake(resultImage.size.width * sqrtf(ratio), resultImage.size.height * sqrtf(ratio));
        UIGraphicsBeginImageContext(size);
        
        [resultImage drawInRect: CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

@end
