//
//  PlaceholderView.swift
//  Pods
//
//  Created by Anatoliy Voropay on 5/12/16.
//
//

import UIKit

/**
 PlaceholderView to draw an area with triangle
 */
internal class PlaceholderView: UIView {

    struct Constants {
        static let TriangleSize = CGSize(width: 25, height: 8)
        static let TriangleRadius: CGFloat = 3
    }

    var color: UIColor? = UIColor.clearColor()
    var triangleOffset: CGPoint = CGPoint.zero

    var arrowPosition: InfoViewArrowPosition = .Automatic {
        didSet { setNeedsDisplay() }
    }

    override internal var frame: CGRect {
        didSet { setNeedsDisplay() }
    }

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }

    private func customize() {
        opaque = false
        backgroundColor = UIColor.clearColor()
        clipsToBounds = false
        layer.masksToBounds = false
    }

    override func drawRect(rect: CGRect) {
        let corner: CGFloat = layer.cornerRadius
        let triangle = Constants.TriangleSize
        let triangleRadius = Constants.TriangleRadius
        let edges = UIEdgeInsets(top: (arrowPosition == .Top ? triangle.height : 0),
                                 left: (arrowPosition == .Left ? triangle.height : 0),
                                 bottom: (arrowPosition == .Bottom ? triangle.height : 0),
                                 right: (arrowPosition == .Right ? triangle.height : 0))
        let context = UIGraphicsGetCurrentContext()

        CGContextClearRect(context, rect)

        if let color = color {
            CGContextSetFillColorWithColor(context, color.CGColor)
        }

        //
        // DRAW ROUND CORNER BORDER
        //

        CGContextBeginPath(context)
        CGContextMoveToPoint(context, corner + edges.left, edges.top)

        if arrowPosition == .Top {
            CGContextAddLineToPoint(context, (CGRectGetMaxX(rect) - triangle.width) / 2 + triangleOffset.x, edges.top)
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect) / 2 + triangleOffset.x, 0,
                                   (CGRectGetMaxX(rect) + triangle.width) / 2 + triangleOffset.x, edges.top,
                                   triangleRadius)
            CGContextAddLineToPoint(context, (CGRectGetMaxX(rect) + triangle.width) / 2 + triangleOffset.x, edges.top)
        }

        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - corner - edges.right, edges.top)
        CGContextAddQuadCurveToPoint(context, CGRectGetMaxX(rect) - edges.right, edges.top,
                                     CGRectGetMaxX(rect) - edges.right, corner + edges.top)

        if arrowPosition == .Right {
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - edges.right, (CGRectGetMaxY(rect) - triangle.width) / 2 + triangleOffset.y)
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) / 2 + triangleOffset.y,
                                   CGRectGetMaxX(rect) - edges.right, (CGRectGetMaxY(rect) + triangle.width) / 2 + triangleOffset.y,
                                   triangleRadius)
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - edges.right, (CGRectGetMaxY(rect) + triangle.width) / 2 + triangleOffset.y)
        }

        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - edges.right, CGRectGetMaxY(rect) - corner - edges.bottom)
        CGContextAddQuadCurveToPoint(context, CGRectGetMaxX(rect) - edges.right, CGRectGetMaxY(rect) - edges.bottom,
                                     CGRectGetMaxX(rect) - corner - edges.right, CGRectGetMaxY(rect) - edges.bottom)

        if arrowPosition == .Bottom {
            CGContextAddLineToPoint(context, (CGRectGetMaxX(rect) - triangle.width) / 2 + triangleOffset.x, CGRectGetMaxY(rect) - edges.bottom)
            CGContextAddArcToPoint(context, CGRectGetMaxX(rect) / 2 + triangleOffset.x, CGRectGetMaxY(rect),
                                   (CGRectGetMaxX(rect) + triangle.width) / 2 + triangleOffset.x, CGRectGetMaxY(rect) - edges.bottom,
                                   triangleRadius)
            CGContextAddLineToPoint(context, (CGRectGetMaxX(rect) + triangle.width) / 2 + triangleOffset.x, CGRectGetMaxY(rect) - edges.bottom)
        }

        CGContextAddLineToPoint(context, corner + edges.left, CGRectGetMaxY(rect) - edges.bottom)
        CGContextAddQuadCurveToPoint(context, 0 + edges.left, CGRectGetMaxY(rect) - edges.bottom,
                                     edges.left, CGRectGetMaxY(rect) - corner - edges.bottom)

        if arrowPosition == .Left {
            CGContextAddLineToPoint(context, edges.left, (CGRectGetMaxY(rect) + triangle.width) / 2 + triangleOffset.y)
            CGContextAddArcToPoint(context, 0, CGRectGetMaxY(rect) / 2 + triangleOffset.y,
                                   edges.left, (CGRectGetMaxY(rect) - triangle.width) / 2 + triangleOffset.y,
                                   triangleRadius)
            CGContextAddLineToPoint(context, edges.left, (CGRectGetMaxY(rect) - triangle.width) / 2 + triangleOffset.y)
        }

        CGContextAddLineToPoint(context, edges.left, corner + edges.top)
        CGContextAddQuadCurveToPoint(context, edges.left, edges.top,
                                     corner + edges.left, edges.top)
        
        CGContextClosePath(context)
        CGContextFillPath(context)
    }
}
