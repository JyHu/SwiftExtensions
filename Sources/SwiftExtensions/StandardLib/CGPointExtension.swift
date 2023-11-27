//
//  File.swift
//  
//
//  Created by Jo on 2023/9/10.
//

import Foundation

public extension CGPoint {
    
    /// 计算以self为起点到point为最大终点区间中满足需求的最大正方形rect
    /// 如：
    /// let p1 = CGPoint(1, 1)
    /// let p2 = CGPoint(8, 5)
    /// let square = p1.closestSquare(to: p2)
    ///
    /// 此时square为 CGRect(1, 1, 4, 4)
    ///
    func closestSquare(to point: CGPoint, maxSize: CGSize? = nil) -> CGRect {
        /// 获取一个有效的终点
        func getEndPoint() -> CGPoint {
            /// 如果设置了最大尺寸，那么就不允许终点在矩形外
            if let maxSize {
                return CGPoint(
                    x: point.x < 0 ? 0 : (point.x > maxSize.width ? maxSize.width : point.x),
                    y: point.y < 0 ? 0 : (point.y > maxSize.height ? maxSize.height : point.y)
                )
            } else {
                return point
            }
        }
        
        let vep = getEndPoint()
        let length = min(abs(self.x - vep.x), abs(self.y - vep.y))
        let vx = point.x < self.x ? self.x - length : self.x
        let vy = point.y < self.y ? self.y - length : self.y
        return CGRect(x: vx, y: vy, width: length, height: length)
    }
}
