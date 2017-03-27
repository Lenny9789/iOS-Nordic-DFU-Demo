//
//  JBButton.swift
//  JBButton
//
//  Created by Jérôme Boursier on 17/06/2016.
//  Copyright © 2016 Jérôme Boursier. All rights reserved.
//

import UIKit

/**
 *  Delegate protocol
 *  Method(s) fired by the `button` on notable event(s)
 */
@objc public protocol JBButtonDelegate: AnyObject {
    /**
     Method to handle the tap on the `button` equivalent to the known `touchUpInside` action
     
     - parameter sender: the current `button` tapped
     */
    @objc optional func didTapOnButton(_ sender: JBButton!)
}

/// The configurable button
@IBDesignable
open class JBButton: UIView {
    
    /// Delegate typed as the `ConfigurableButtonDelegate` protocol
    open weak var delegate: JBButtonDelegate?
    
    /// Workaround: Xcode doesn't allow us to connect any protocol based delegate.
    @IBOutlet fileprivate weak var ibDelegate: AnyObject? {
        get { return delegate }
        set { delegate = newValue as? JBButtonDelegate }
    }
    
    /// Inspectable: text to be displayed
    @IBInspectable open var title: String? = "Hit me!"
    /// Inspectable: color of the text
    @IBInspectable open var titleColor: UIColor = UIColor.black
    /// Inspectable: alignment of the text. Treat as `NSTextAlignment.<alignment>.rawValue`
    @IBInspectable open var titleAlignment: Int = 1
    
    /// Inspectable: image to be displayed
    @IBInspectable open var image: UIImage?
    /// Inspectable: color of the image, if rendered as template
    @IBInspectable open var imageColor: UIColor = UIColor.black
    /// Inspectable: rendering mode of the image
    /// - 0 for `.Original`
    /// - 1 for `.Template`
    @IBInspectable open var imageRenderingMode: Int {
        get {
            return self.renderingMode.rawValue
        }
        set(idx) {
            self.renderingMode = RenderingMode(rawValue: idx) ?? .original
        }
    }
    /// Inspectable: position of the image in the button
    /// - 0 for `.Top`
    /// - 1 for `.Bottom`
    /// - 2 for `.Left`
    /// - 3 for `.Right`
    /// - 4 for `.Centered`
    @IBInspectable open var imagePosition: Int {
        get {
            return self.positionValue.rawValue
        }
        set(idx) {
            self.positionValue = Position(rawValue: idx) ?? .top
            self.originalPosition = positionValue
        }
    }
    
    /**
     Enum representing the rendering modes of the image
     
     - original: draws the image as is
     - template: templatizes the image
     */
    internal enum RenderingMode: Int {
        case original = 0
        case template = 1
    }
    /// Selected rendering mode of the image
    internal var renderingMode = RenderingMode.original
    
    /**
     Enum representing the positions of the image
     
     - Top:      above the label
     - Bottom:   underneath the label
     - Left:     to the left of the label
     - Right:    to the right of the label
     - Centered: centered, no label
     */
    internal enum Position: Int {
        case top = 0
        case bottom = 1
        case left = 2
        case right = 3
        case centered = 4
    }
    /// Selected position of the image
    internal var positionValue = Position.top
    
    /// Inspectable: corner radius of the button
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    /// Inspectable: border width of the button
    @IBInspectable open var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    /// Inspectable: border color of the button
    @IBInspectable open var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    /// Inspectable: padding of the button
    @IBInspectable open var padding: CGFloat = 0.0 {
        didSet {
            self.customPadding = (fabs(self.padding) > CGFloat(FLT_EPSILON) && self.padding > CGFloat(FLT_EPSILON) ? self.padding : 0.0)
        }
    }
    
    /// Inspectable: determines whether the button should highlight on tap
    @IBInspectable open var highlight: Bool = true
    /// Original background color of the button
    internal var originalBackgroundColor: UIColor? = UIColor.white
    /// Selected padding of the button
    internal var customPadding: CGFloat = 0.0
    /// Label of the title inside the button
    internal(set) var titleLabel: UILabel? = UILabel(frame: CGRect.zero)
    /// Image view inside the button
    fileprivate(set) var imageView: UIImageView? = UIImageView(frame: CGRect.zero)
    /// Font of the text
    internal var customFont: UIFont? = UIFont.systemFont(ofSize: 15)
    
    // MARK:- Animation properties
    
    /// Custom touches began animations - user defined
    open var customTouchesBeganAnimations: CAAnimationGroup?
    /// Custom touches ended animations - user defined
    open var customTouchesEndedAnimations: CAAnimationGroup?
    /// Custom loading animations - user defined
    open var customLoadingAnimations: CAAnimationGroup?
    
    // MARK:- Loading properties
    
    /// Determines whether the title should be hidden while the loading animation is performing
    open var hideTitleOnLoad: Bool = false
    /// Original position of the image
    internal var originalPosition: Position = .top
    /// Loading state of the button
    /// - `true` if the button is loading
    /// - `false` otherwise
    internal(set) open var isLoading: Bool = false
    /// Default loader
    fileprivate var defaultLoader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    /// Custom loader, as a replacment of the default loader - user defined
    internal var customLoader: UIView? = nil
    /// Custom loader start animating block
    internal var customLoaderStart: ((Void) -> ())? = nil
    /// Custom loader stop animating block
    internal var customLoaderStop: ((Void) -> ())? = nil
    
    
    // MARK:- Init
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialization()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    //internal var borderView: UIView! = UIView()
    
    /**
     Private custom convenient initializer
     */
    fileprivate func initialization() {
        if self.backgroundColor == nil {
            self.backgroundColor = UIColor.white
        }
        
        self.originalBackgroundColor = self.backgroundColor
        
        if self.imageView != nil {
            self.defaultLoader.center = (self.imageView?.center)!
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        self.titleLabel?.text = self.title
        self.titleLabel?.textAlignment = NSTextAlignment(rawValue: NSInteger(self.titleAlignment)) ?? .center
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = self.cornerRadius > 0
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
    }
    
    /**
     Sets the font of the title
     
     - parameter font: the font to apply to the title
     */
    open func setTitleFont(_ font: UIFont) {
        self.customFont = font
        self.setNeedsDisplay()
    }
    
    /**
     Set the title, if it needs to be changed in some ways
     
     - parameter title: the font to apply to the title
     */
    open func setTitleText(_ title: String) {
        self.title = title
        self.setNeedsDisplay()
    }
}
