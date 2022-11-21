//
//  UIView+Geometry.swift
//  ReciteWords
//
//  Created by marco on 2022/2/26.
//

import UIKit

/*
 * UIView Geometry
 */
extension UIView {
    
    var left: CGFloat {
        get{
            return frame.origin.x
        }
        set{
            var newFrame = frame
            newFrame.origin.x = newValue
            frame = newFrame
        }
    }
    
    var right: CGFloat {
        get{
            return frame.origin.x + frame.size.width
        }
        set{
            var newFrame = frame
            newFrame.origin.x = newValue - frame.size.width
            frame = newFrame
        }
    }
    
    var top: CGFloat {
        get{
            return frame.origin.y
        }
        set{
            var newFrame = frame
            newFrame.origin.y = newValue
            frame = newFrame
        }
    }
    
    var bottom: CGFloat {
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            var newFrame = frame
            newFrame.origin.y = newValue - frame.size.height
            frame = newFrame
        }
    }
    
    var width: CGFloat {
        get{
            return frame.size.width
        }
        set{
            var newFrame = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
    }
    
    var height: CGFloat {
        get{
            return frame.size.height
        }
        set{
            var newFrame = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
    }
    
    var centerX: CGFloat {
        get{
            return center.x
        }
        set{
            var newCenter = center
            newCenter.x = newValue
            center = newCenter
        }
    }
    
    var centerY: CGFloat {
        get{
            return center.y
        }
        set{
            var newCenter = center
            newCenter.y = newValue
            center = newCenter
        }
    }
    
    var origin: CGPoint {
        get{
            return frame.origin
        }
        set{
            var newFrame = frame
            newFrame.origin = newValue
            frame = newFrame
        }
    }
    
    var size: CGSize {
        get{
            return frame.size
        }
        set{
            var newFrame = frame
            newFrame.size = newValue
            frame = newFrame
        }
    }
}
