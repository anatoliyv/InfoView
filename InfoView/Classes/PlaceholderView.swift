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

    var color: UIColor? = UIColor.clear
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

    fileprivate func customize() {
        isOpaque = false
        backgroundColor = UIColor.clear
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
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.clear(rect)

        if let color = color {
            context.setFillColor(color.cgColor)
        }

        //
        // DRAW ROUND CORNER BORDER
        //

        context.beginPath()
        context.move(to: CGPoint(x: corner + edges.left, y: edges.top))

        if arrowPosition == .top {
            context.addLine(to: CGPoint(x: (rect.maxX - triangle.width) / 2 + triangleOffset.x, y: edges.top))
            context.addArc(tangent1End: CGPoint(x: (rect.maxX / 2 + triangleOffset.x), y: 0), tangent2End: CGPoint(x: ((rect.maxX + triangle.width) / 2 + triangleOffset.x), y: edges.top), radius: triangleRadius)
            context.addLine(to: CGPoint(x: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y: edges.top))
        }

        context.addLine(to: CGPoint(x: rect.maxX - corner - edges.right, y: edges.top))
        context.addQuadCurve(to: CGPoint(x: rect.maxX - edges.right, y: corner + edges.top), control: CGPoint(x: rect.maxX - edges.right, y: edges.top))

        if arrowPosition == .right {
            context.addLine(to: CGPoint(x: rect.maxX - edges.right, y: (rect.maxY - triangle.width) / 2 + triangleOffset.y))
            context.addArc(tangent1End: CGPoint(x: rect.maxX,y: rect.maxY / 2 + triangleOffset.y), tangent2End: CGPoint(x: rect.maxX - edges.right,y: (rect.maxY + triangle.width) / 2 + triangleOffset.y), radius: triangleRadius)
            context.addLine(to: CGPoint(x: rect.maxX - edges.right, y: (rect.maxY + triangle.width) / 2 + triangleOffset.y))
        }

        context.addLine(to: CGPoint(x: rect.maxX - edges.right, y: rect.maxY - corner - edges.bottom))
        context.addQuadCurve(to: CGPoint(x: rect.maxX - corner - edges.right, y: rect.maxY - edges.bottom), control: CGPoint(x: rect.maxX - edges.right, y: rect.maxY - edges.bottom))

        if arrowPosition == .bottom {
            context.addLine(to: CGPoint(x: (rect.maxX - triangle.width) / 2 + triangleOffset.x, y: rect.maxY - edges.bottom))
            context.addArc(tangent1End: CGPoint(x: rect.maxX / 2 + triangleOffset.x, y: rect.maxY), tangent2End: CGPoint(x: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y: rect.maxY - edges.bottom), radius: triangleRadius)
            context.addLine(to: CGPoint(x: (rect.maxX + triangle.width) / 2 + triangleOffset.x, y: rect.maxY - edges.bottom))
        }

        context.addLine(to: CGPoint(x: corner + edges.left, y: rect.maxY - edges.bottom))
        context.addQuadCurve(to: CGPoint(x: edges.left, y: rect.maxY - corner - edges.bottom), control: CGPoint(x: 0 + edges.left, y: rect.maxY - edges.bottom))

        if arrowPosition == .left {
            context.addLine(to: CGPoint(x: edges.left, y: (rect.maxY + triangle.width) / 2 + triangleOffset.y))
            context.addArc(tangent1End: CGPoint(x: 0, y: rect.maxY / 2 + triangleOffset.y), tangent2End: CGPoint(x: edges.left, y: (rect.maxY - triangle.width) / 2 + triangleOffset.y), radius: triangleRadius)
            context.addLine(to: CGPoint(x: edges.left, y: (rect.maxY - triangle.width) / 2 + triangleOffset.y))
        }

        context.addLine(to: CGPoint(x: edges.left, y: corner + edges.top))
        context.addQuadCurve(to: CGPoint(x: corner + edges.left, y: edges.top), control: CGPoint(x: edges.left, y: edges.top))

        context.closePath()
        context.fillPath()
    }
 }
