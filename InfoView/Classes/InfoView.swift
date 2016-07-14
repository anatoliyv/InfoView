//
//  InfoView.swift
//  Pods
//
//  Created by Anatoliy Voropay on 5/11/16.
//
//

import UIKit

/**
 Position of arrow in a view
 
 - Parameter None:                      View will be without arrow
 - Parameter Automatic:                 We will try to select most suitable position
 - Parameter Left, Right, Top, Bottom:  Define view side that will contain an errow
 */
public enum InfoViewArrowPosition {
    case None
    case Automatic
    case Left, Right, Top, Bottom
}

/**
 Appearance animation
 
 - Parameter None:              View will appear without animation
 - Parameter FadeIn:            FadeIn animation will happen
 - Parameter FadeInAndScale:    FadeIn and Scale animation will happen
 */
public enum InfoViewAnimation {
    case None
    case FadeIn
    case FadeInAndScale
}

/**
 Delegate that can handle events from InfoView appearance.
 */
@objc public protocol InfoViewDelegate {
    optional func infoViewWillShow(view: InfoView)
    optional func infoViewDidShow(view: InfoView)
    optional func infoViewWillHide(view: InfoView)
    optional func infoViewDidHide(view: InfoView)
}

/**
 View to show small text information blocks with arrow pointed to another view. 
 In most cases it will be a button that was pressed.
 
 **Simple appearance**

 ```
 let infoView = InfoView(text: "Your information here")
 infoView.show(onView: view, centerView: button)
 ```
 
 **Delegation**
 
 You can set a delegate and get events when view ill appear/hide:
 
 ```
 infoView.delegate = self
 
 // In your delegate class
 func infoViewDidShow(view: InfoView) {
     print("Now visible")
 }
 ```
 
 **Customization**
 
 Set arrow position:
 ```
 infoView.arrowPosition = .Left
 ```
 
 Set animation:
 ```
 infoView.animation = InfoViewAnimation.None                // Without animation
 infoView.animation = InfoViewAnimation.FadeIn              // FadeIn animation
 infoView.animation = InfoViewAnimation.FadeInAndScale      // FadeIn and Scale animation
 ```
 
 Set custom font:
 ```
 infoView.font = UIFont(name: "AvenirNextCondensed-Regular", size: 16)
 ```
 
 Set custom text color:
 ```
 infoView.textColor = UIColor.grayColor()
 ```
 
 Set custom background color:
 ```
 infoView.backgroundColor = UIColor.blackColor()
 ```

 Set custom layer properties:
 ```
 infoView.layer.shadowColor = UIColor.whiteColor().CGColor
 infoView.layer.cornerRadius = 15
 infoView.layer.shadowRadius = 5
 infoView.layer.shadowOffset = CGPoint(x: 2, y: 2)
 infoView.layer.shadowOpacity = 0.5
 ```
 
 **Auto hide**
 
 Hide InfoView after delay automatically

 ```
 infoView.hideAfterDelay = 2
 ```
 */
public class InfoView: UIView {

    /// Arrow position
    public var arrowPosition: InfoViewArrowPosition = .Automatic

    /// Animation
    public var animation: InfoViewAnimation = .FadeIn

    /// InfoViewDelegate delegate
    public weak var delegate: InfoViewDelegate?

    /// Text message
    public var text: String?

    /// Autohide after delay
    public var hideAfterDelay: CGFloat? {
        didSet {
            if let hideAfterDelay = hideAfterDelay {
                timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(hideAfterDelay), target: self, selector: #selector(InfoView.hide), userInfo: nil, repeats: false)
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }

    /// Text padding
    public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    /// Text label font
    public var font: UIFont?

    /// Text label color
    public var textColor: UIColor?

    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        self.backgroundView.insertSubview(label, aboveSubview: self.placeholderView)
        return label
    }()

    private lazy var placeholderView: PlaceholderView = {
        let placeholderView = PlaceholderView()
        placeholderView.color = self.backgroundColor
        self.backgroundView.addSubview(placeholderView)
        return placeholderView
    }()

    private lazy var backgroundView: BackgroundView = {
        let backgroundView = BackgroundView()
        backgroundView.backgroundColor = .clearColor()
        backgroundView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        backgroundView.delegate = self
        return backgroundView
    }()

    override public var autoresizingMask: UIViewAutoresizing {
        didSet {
            placeholderView.autoresizingMask = autoresizingMask
            label.autoresizingMask = autoresizingMask
        }
    }

    private weak var onView: UIView?
    private weak var centerView: UIView?
    private var timer: NSTimer?

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeAppearance()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeAppearance()
    }

    public convenience init(text: String, delegate: InfoViewDelegate) {
        self.init(text: text, arrowPosition: .Automatic, animation: .FadeIn, delegate: delegate)
    }

    public convenience init(text: String) {
        self.init(text: text, arrowPosition: .Automatic, animation: .FadeIn, delegate: nil)
    }

    public init(text: String, arrowPosition: InfoViewArrowPosition, animation: InfoViewAnimation, delegate: InfoViewDelegate?) {
        super.init(frame: CGRect.zero)

        self.text = text
        self.animation = animation
        self.arrowPosition = arrowPosition
        self.delegate = delegate

        customizeAppearance()
    }

    // MARK: Appearance

    public func show(onView view: UIView, centerView: UIView) {
        self.onView = view
        self.centerView = centerView

        var (suitableRect, suitableOffset) = self.suitableRect()
        var labelRect = CGRect(x: suitableRect.origin.x + textInsets.left, y: suitableRect.origin.y + textInsets.top, width: suitableRect.width - textInsets.left - textInsets.right, height: suitableRect.height - textInsets.bottom - textInsets.top)

        switch correctArrowPosition() {
        case .Left:
            labelRect.size.width -= PlaceholderView.Constants.TriangleSize.height
            labelRect.origin.x += PlaceholderView.Constants.TriangleSize.height

        case .Right:
            labelRect.size.width -= PlaceholderView.Constants.TriangleSize.height
            labelRect.origin.x -= PlaceholderView.Constants.TriangleSize.height
            suitableRect.origin.x -= PlaceholderView.Constants.TriangleSize.height

        case .Top:
            labelRect.size.height -= PlaceholderView.Constants.TriangleSize.height
            labelRect.origin.y += PlaceholderView.Constants.TriangleSize.height

        case .Bottom:
            labelRect.size.height -= PlaceholderView.Constants.TriangleSize.height
            labelRect.origin.y -= PlaceholderView.Constants.TriangleSize.height
            suitableRect.origin.y -= PlaceholderView.Constants.TriangleSize.height

        default:
            break
        }

        backgroundView.frame = view.bounds

        placeholderView.frame = suitableRect
        placeholderView.triangleOffset = suitableOffset
        placeholderView.arrowPosition = correctArrowPosition()
        placeholderView.color = backgroundColor
        placeholderView.layer.cornerRadius = self.layer.cornerRadius
        placeholderView.layer.shadowColor = self.layer.shadowColor
        placeholderView.layer.shadowRadius = self.layer.shadowRadius
        placeholderView.layer.shadowOffset = self.layer.shadowOffset
        placeholderView.layer.shadowOpacity = self.layer.shadowOpacity
        placeholderView.alpha = 0

        label.frame = labelRect
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment()
        label.alpha = 0

        view.addSubview(backgroundView)
        animateAppearance()
    }

    func hide() {
        timer?.invalidate()
        timer = nil
        
        animateDisappearance()
    }

    // MARK: Animation

    private func animateAppearance() {
        delegate?.infoViewWillShow?(self)

        switch self.animation {
        case .FadeInAndScale:
            placeholderView.transform = scaleTransform(placeholderView.transform)
            label.transform = scaleTransform(label.transform)
        default:
            break
        }

        UIView.animateWithDuration(duration(), animations: {
            self.label.alpha = 1
            self.placeholderView.alpha = 1

            switch self.animation {
            case .FadeInAndScale:
                self.placeholderView.transform = CGAffineTransformIdentity
                self.label.transform = CGAffineTransformIdentity
            default:
                break
            }
        }, completion: { (complete) in
            self.delegate?.infoViewDidShow?(self)
        })
    }

    private func animateDisappearance() {
        self.delegate?.infoViewWillHide?(self)

        UIView.animateWithDuration(duration(), animations: {
            self.label.alpha = 0
            self.placeholderView.alpha = 0

            switch self.animation {
            case .FadeIn, .None:
                break
            case .FadeInAndScale:
                self.placeholderView.transform = self.scaleTransform(self.placeholderView.transform)
                self.label.transform = self.scaleTransform(self.label.transform)
            }
        }, completion: { (complete) in
            self.backgroundView.removeFromSuperview()
            self.delegate?.infoViewDidHide?(self)
        })
    }

    private func duration() -> NSTimeInterval {
        return animation == .None ? 0 : 0.2
    }

    private func scaleTransform(t: CGAffineTransform) -> CGAffineTransform {
        return CGAffineTransformScale(t, 0.5, 0.5)
    }

    // MARK: Helpers

    /// Return correct arrow position. It will detect correct position for Automatic also.
    private func correctArrowPosition() -> InfoViewArrowPosition {
        if arrowPosition == .Automatic {
            guard let view = onView else { return .Left }
            guard let centerView = centerView else { return .Left }

            let centerRect = view.convertRect(centerView.frame, toView: view)

            let width1 = view.frame.width
            let height1 = centerRect.origin.y

            let width2 = view.frame.width - centerRect.origin.x - centerRect.size.width
            let height2 = view.frame.height

            let width3 = view.frame.width
            let height3 = view.frame.height - centerRect.origin.y - centerRect.size.height

            let width4 = centerRect.origin.x
            let height4 = view.frame.height

            let area1: CGFloat = width1 * height1
            let area2: CGFloat = width2 * height2
            let area3: CGFloat = width3 * height3
            let area4: CGFloat = width4 * height4

            let max: CGFloat = CGFloat(fmaxf(fmaxf(Float(area1), Float(area2)), fmaxf(Float(area3), Float(area4))))

            if max == area1 {
                return .Bottom
            } else if max == area2 {
                return .Left
            } else if max == area3 {
                return .Top
            } else {
                return .Right
            }

        } else {
            return arrowPosition
        }
    }

    private func textAlignment() -> NSTextAlignment {
        switch correctArrowPosition() {
        case .Left: return .Left
        case .Right: return .Right
        case .Top, .Bottom, .Automatic, .None: return .Center
        }
    }

    /// Return customized label with settings
    private func customizedLabel() -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = 0
        return label
    }
}

// MARK: Discover best rect to show view

extension InfoView {

    /// Return maximum allowed rect according to preferences
    private func visibleRect() -> CGRect {
        guard let view = onView else { return CGRect.zero }
        guard let centerView = centerView else { return CGRect.zero }

        let centerRect = view.convertRect(centerView.frame, toView: view)
        var visibleRect = CGRect.zero

        switch correctArrowPosition() {
        case .Left:
            visibleRect = CGRect(origin: CGPoint(x: centerRect.origin.x + centerRect.size.width, y: 0), size: CGSize(width: view.frame.width - centerRect.origin.x - centerRect.size.width, height: view.frame.height))

        case .Right:
            visibleRect = CGRect(origin: CGPoint.zero, size: CGSize(width: centerRect.origin.x, height: view.frame.height))

        case .Bottom:
            visibleRect = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: centerRect.origin.y))

        case .Top:
            visibleRect = CGRect(origin: CGPoint(x: 0, y: centerRect.origin.y + centerRect.size.height), size: CGSize(width: view.frame.width, height: view.frame.height - centerRect.origin.y - centerRect.size.height))

        default:
            break
        }

        return visibleRect
    }

    /// Return allowed rect for final label according with textInsets
    private func allowedRect(inRect rect: CGRect) -> CGRect {
        let size = CGSize(width: rect.width - textInsets.left - textInsets.right, height: rect.height - textInsets.bottom - textInsets.top)
        let origin = CGPoint(x: rect.origin.x + textInsets.left, y: rect.origin.y + textInsets.top)
        return CGRect(origin: origin, size: size)
    }

    /// Return suitable rect for final label
    private func labelRect(inRect rect: CGRect) -> CGRect {
        var allowedRect = self.allowedRect(inRect: rect)
        allowedRect.size.height = CGFloat.max
        allowedRect.size.width *= ( UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 0.5 : 0.8 )

        let label = customizedLabel()
        label.frame = allowedRect
        label.sizeToFit()
        return label.frame
    }

    /// Return final rect for our placeholderView
    /// CGPoint is offset for triangle
    private func suitableRect() -> (CGRect, CGPoint) {
        guard let view = onView else { return (CGRect.zero, CGPoint.zero) }
        guard let centerView = centerView else { return (CGRect.zero, CGPoint.zero) }

        let visibleRect = self.visibleRect()
        let centerRect = view.convertRect(centerView.frame, toView: view)
        var finalRect = labelRect(inRect: visibleRect)
        var finalOffset = CGPoint.zero

        switch correctArrowPosition() {
        case .Left:
            finalRect.origin.y = centerRect.origin.y + centerView.frame.size.height / 2 - finalRect.size.height / 2
            finalRect.origin.x = visibleRect.origin.x + textInsets.left
            finalRect.size.width += PlaceholderView.Constants.TriangleSize.height

        case .Right:
            finalRect.origin.y = centerRect.origin.y + centerView.frame.size.height / 2 - finalRect.size.height / 2
            finalRect.origin.x = centerRect.origin.x - finalRect.size.width - textInsets.right
            finalRect.size.width += PlaceholderView.Constants.TriangleSize.height

        case .Top:
            finalRect.origin.x = centerRect.origin.x + centerView.frame.size.width / 2 - finalRect.size.width / 2
            finalRect.origin.y = centerRect.origin.y + centerRect.size.height + textInsets.top
            finalRect.size.height += PlaceholderView.Constants.TriangleSize.height

        case .Bottom:
            finalRect.origin.x = centerRect.origin.x + centerView.frame.size.width / 2 - finalRect.size.width / 2
            finalRect.origin.y = centerRect.origin.y - finalRect.size.height - textInsets.bottom
            finalRect.size.height += PlaceholderView.Constants.TriangleSize.height

        default:
            break
        }

        finalRect.origin.x -= textInsets.left
        finalRect.origin.y -= textInsets.top
        finalRect.size.width += textInsets.left + textInsets.right
        finalRect.size.height += textInsets.top + textInsets.bottom

        let borderOffset: CGFloat = 5

        if finalRect.origin.x < 0 {
            finalOffset.x = finalRect.origin.x - borderOffset
            finalRect.origin.x = borderOffset
        } else if finalRect.origin.x + finalRect.size.width > view.frame.width {
            finalOffset.x = (finalRect.origin.x + finalRect.size.width) - view.frame.width + borderOffset
            finalRect.origin.x -= finalOffset.x
        } else if finalRect.origin.y < 0 {
            finalOffset.y = finalRect.origin.y - borderOffset
            finalRect.origin.y = borderOffset
        } else if finalRect.origin.y + finalRect.size.height > view.frame.height {
            finalOffset.y = (finalRect.origin.y + finalRect.size.height) - view.frame.height + borderOffset
            finalRect.origin.y -= finalOffset.y
        }
        
        return (finalRect, finalOffset)
    }
}

// MARK: Appearance customization

extension InfoView {
    private func customizeAppearance() {
        font = .systemFontOfSize(14)
        textColor = .blackColor()
        backgroundColor = .whiteColor()

        layer.cornerRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

extension InfoView: BackgroundViewDelegate {
    func pressedBackgorund(view: BackgroundView) {
        hide()
    }
}
