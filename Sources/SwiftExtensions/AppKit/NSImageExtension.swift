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
}

#endif
