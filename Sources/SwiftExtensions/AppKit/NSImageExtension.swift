//
//  File.swift
//
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSImage {
    private class _TextAttchmentCell: NSTextAttachmentCell {
        private var offset: CGPoint = .zero
        
        init(image: NSUIImage, offset: CGPoint?) {
            super.init(imageCell: image)
            
            if let offset = offset {
                self.offset = offset
            }
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func cellBaselineOffset() -> CGPoint {
            offset
        }
    }
    
    func textAttachment(with offsetCreator: (() -> CGPoint)? = nil) -> NSTextAttachment {
        let attachment = NSTextAttachment(data: nil, ofType: nil)
        attachment.attachmentCell = _TextAttchmentCell(image: self, offset: offsetCreator?())
        return attachment
    }
    
    func rotate(with angle: CGFloat) -> NSImage {
        let degree = 360 - angle
        var imageBounds = CGRect(origin: .zero, size: size)
        let boundsPath = NSBezierPath(rect: imageBounds)
        var transform = AffineTransform()
        transform.rotate(byDegrees: degree)
        boundsPath.transform(using: transform)
        
        let rotatedBounds = NSRect(origin: .zero, size: boundsPath.bounds.size)
        let rotatedImage = NSImage(size: rotatedBounds.size)
        
        // Center the image within the rotated bounds
        imageBounds.origin.x = rotatedBounds.midX - imageBounds.width / 2
        imageBounds.origin.y = rotatedBounds.midY - imageBounds.height / 2
        
        // Start a new transform, to transform the image
        let nstransform = NSAffineTransform()
        
        // Move coordinate system to the center
        // (since we want to rotate around the center)
        nstransform.translateX(by: rotatedBounds.width / 2, yBy: rotatedBounds.height / 2)
        
        // Do the rotation
        nstransform.rotate(byDegrees: degree)
        
        // Move coordinate system back to normal (bottom, left)
        nstransform.translateX(by: -rotatedBounds.width / 2, yBy: -rotatedBounds.height / 2)
        
        // Draw the original image, rotated, into the new image
        // Note: This "drawing" is done off-screen.
        rotatedImage.lockFocus()
        nstransform.concat()
        draw(in: imageBounds, from: .zero, operation: .copy, fraction: 1.0)
        rotatedImage.unlockFocus()
        
        return rotatedImage;
    }
    
    /// 缩放图片到指定大小
    /// - Parameters:
    ///   - width: 缩小的宽度，以宽度比例等比缩放
    ///   - roundedCornerRadius: 新图片的圆角半径
    ///   - roundedCornerRate: 新图片半径比例，以缩放后的图片的宽高最小值来算半径
    /// - Returns: 处理后的图片
    func stretch(to width: CGFloat, roundedCornerRadius: CGFloat? = nil, roundedCornerRate: CGFloat? = nil) -> NSImage {
        if size.width == width { return self }
        let height = width * size.height / size.width
        
        func getRadius() -> CGFloat? {
            if let roundedCornerRadius, roundedCornerRadius > 0 {
                return roundedCornerRadius
            }
            
            if let roundedCornerRate, roundedCornerRate <= 0.5 {
                return min(width, height) * roundedCornerRate
            }
            
            return nil
        }
        
        return NSImage(size: NSMakeSize(width, height), flipped: true) { dstRect in
            if let radius = getRadius() {
                NSBezierPath(roundedRect: dstRect, xRadius: radius, yRadius: radius).addClip()
                
            }
            self.draw(in: dstRect)
            return true
        }
    }
    
    /// 圆角处理图片
    func roundedCorner(with radius: CGFloat) -> NSImage {
        if radius < 0 { return self }
        return NSImage(size: size, flipped: true) { dstRect in
            NSBezierPath(roundedRect: dstRect, xRadius: radius, yRadius: radius).addClip()
            self.draw(in: dstRect)
            return true
        }
    }
}

#endif
