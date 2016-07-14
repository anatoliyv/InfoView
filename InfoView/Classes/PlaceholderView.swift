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

    var color: UIColor? = UIColor.clear()
    var triangleOffset: CGPoint = CGPoint.zero

    var arrowPosition: InfoViewArrowPosition = .automatic {
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
        isOpaque = false
        backgroundColor = UIColor.clear()
        clipsToBounds = false
        layer.masksToBounds = false
    }

    override func draw(_ rect: CGRect) {
        let corner: CGFloat = layer.cornerRadius
        let triangle = Constants.TriangleSize
        let triangleRadius = Constants.TriangleRadius
        let edges = UIEdgeInsets(top: (arrowPosition == .top ? triangle.height : 0),
                                 left: (arrowPosition == .left ? triangle.height : 0),
                                 bottom: (arrowPosition == .bottom ? triangle.height : 0),
                                 right: (arrowPosition == .right ? triangle.height : 0))
        let context = UIGraphicsGetCurrentContext()

        context?.clear(rect)

        if let color = color {
            context?.setFillColor(color.cgColor)
        }

        //
        // DRAW ROUND CORNER BORDER
        //

        context?.beginPath()
        context?.moveTo(x: corner + edges.left, y: edges.top)

        if arrowPosition == .top {
            context?.addLineTo(x: (rect.maxX - triangle.width) / 2 + triangleOffset.x, y: edges.top)
            context?.addArc(x1: rect.maxX / 2 + triangleOffset.x, y1: 0,
                                   x2: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y2: edges.top,
                                   radius: triangleRadius)
            context?.addLineTo(x: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y: edges.top)
        }

        context?.addLineTo(x: rect.maxX - corner - edges.right, y: edges.top)
        context?.addQuadCurveTo(cpx: rect.maxX - edges.right, cpy: edges.top,
                                     endingAtX: rect.maxX - edges.right, y: corner + edges.top)

        if arrowPosition == .right {
            context?.addLineTo(x: rect.maxX - edges.right, y: (rect.maxY - triangle.width) / 2 + triangleOffset.y)
            context?.addArc(x1: rect.maxX, y1: rect.maxY / 2 + triangleOffset.y,
                                   x2: rect.maxX - edges.right, y2: (rect.maxY + triangle.width) / 2 + triangleOffset.y,
                                   radius: triangleRadius)
            context?.addLineTo(x: rect.maxX - edges.right, y: (rect.maxY + triangle.width) / 2 + triangleOffset.y)
        }

        context?.addLineTo(x: rect.maxX - edges.right, y: rect.maxY - corner - edges.bottom)
        context?.addQuadCurveTo(cpx: rect.maxX - edges.right, cpy: rect.maxY - edges.bottom,
                                     endingAtX: rect.maxX - corner - edges.right, y: rect.maxY - edges.bottom)

        if arrowPosition == .bottom {
            context?.addLineTo(x: (rect.maxX - triangle.width) / 2 + triangleOffset.x, y: rect.maxY - edges.bottom)
            context?.addArc(x1: rect.maxX / 2 + triangleOffset.x, y1: rect.maxY,
                                   x2: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y2: rect.maxY - edges.bottom,
                                   radius: triangleRadius)
            context?.addLineTo(x: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y: rect.maxY - edges.bottom)
        }

        context?.addLineTo(x: corner + edges.left, y: rect.maxY - edges.bottom)
        context?.addQuadCurveTo(cpx: 0 + edges.left, cpy: rect.maxY - edges.bottom,
                                     endingAtX: edges.left, y: rect.maxY - corner - edges.bottom)

        if arrowPosition == .left {
            context?.addLineTo(x: edges.left, y: (rect.maxY + triangle.width) / 2 + triangleOffset.y)
            context?.addArc(x1: 0, y1: rect.maxY / 2 + triangleOffset.y,
                                   x2: edges.left, y2: (rect.maxY - triangle.width) / 2 + triangleOffset.y,
                                   radius: triangleRadius)
            context?.addLineTo(x: edges.left, y: (rect.maxY - triangle.width) / 2 + triangleOffset.y)
        }

        context?.addLineTo(x: edges.left, y: corner + edges.top)
        context?.addQuadCurveTo(cpx: edges.left, cpy: edges.top,
                                     endingAtX: corner + edges.left, y: edges.top)
        
        context?.closePath()
        context?.fillPath()
    }
}
