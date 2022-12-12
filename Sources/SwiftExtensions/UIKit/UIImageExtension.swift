//
//  File.swift
//
//
//  Created by Jo on 2022/10/30.
//

#if canImport(UIKit)

import UIKit

public extension UIImage {
    func textAttachment(with offsetCreator: (() -> CGPoint)? = nil) -> NSTextAttachment {
        if #available(iOS 13.0, *) {
            let attachment = NSTextAttachment(image: self)
            attachment.bounds = CGRect(origin: .zero, size: size)
            return attachment
        } else {
            let attachment = NSTextAttachment()
            attachment.image = self
            attachment.bounds = CGRect(origin: .zero, size: size)
            return attachment
        }
    }
}

public extension UIImage {
    func cropped(to rect: CGRect) -> NSUIImage {
        guard let imageRef = cgImage?.cropping(to: rect) else { return NSUIImage() }
        return NSUIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    func resized(to newSize: CGSize) -> NSUIImage {
        let scaledSize = newSize.applying(.init(scaleX: 1 / scale, y: 1 / scale))
        return UIGraphicsImageRenderer(size: scaledSize).image { _ in
            draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }
    
    func pixelColor(at point: CGPoint) -> NSUIColor? {
        let size = cgImage.map { CGSize(width: $0.width, height: $0.height) } ?? self.size
        guard point.x >= 0, point.x < size.width, point.y >= 0, point.y < size.height,
              let data = cgImage?.dataProvider?.data,
              let pointer = CFDataGetBytePtr(data) else { return nil }
        
        let pixelData = Int((size.width * point.y) + point.x) * 4
        
        return NSUIColor(
            R: Int(pointer[pixelData]),
            G: Int(pointer[pixelData + 1]),
            B: Int(pointer[pixelData + 2]),
            alpha: Double(Int(pointer[pixelData + 3]))
        )
    }
}

#endif
