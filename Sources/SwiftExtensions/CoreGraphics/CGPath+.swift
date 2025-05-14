//
//  CGPath+.swift
//  SwiftExtensions
//
//  Created by hujinyou on 2025/5/14.
//

import CoreGraphics

public extension CGPath {
    static func from(points: [CGPoint], closed: Bool = false) -> CGPath? {
        guard !points.isEmpty, points.count >= 2 else { return nil }
        
        let path = CGMutablePath()
        path.move(to: points[0])
        
        for point in points[1...] {
            path.addLine(to: point)
        }
        
        if closed {
            path.addLine(to: points[0])
        }
        
        return path
    }
}

public extension CGMutablePath {
    func insertLine(from fpoint: CGPoint, to tpoint: CGPoint) {
        move(to: fpoint)
        addLine(to: tpoint)
    }
    
    func addHLine(fromX: Double, toX: Double, y: Double) {
        move(to: CGPoint(x: fromX, y: y))
        addLine(to: CGPoint(x: toX, y: y))
    }
    
    func addVLine(fromY: Double, toY: Double, x: Double) {
        move(to: CGPoint(x: x, y: fromY))
        addLine(to: CGPoint(x: x, y: toY))
    }
    
    func connect(points: [CGPoint]) {
        guard !points.isEmpty else { return }
        
        for point in points {
            addLine(to: point)
        }
    }
}
