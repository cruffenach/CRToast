//
//  CRToast.swift
//  CRToast
//
//  Created by Collin Ruffenach on 11/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    func replaceWidth(newValue : CGFloat) -> CGRect {
        var rect = self
        rect.size.width = newValue
        return rect
    }
    func replaceHeight(newValue : CGFloat) -> CGRect {
        var rect = self
        rect.size.height = newValue
        return rect
    }
    func replaceX(newValue : CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = newValue
        return rect
    }
    func replaceY(newValue : CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = newValue
        return rect
    }
}
/**
`CRToastManager` is the class which manages the creation and display of toasts. Toasts are generated
and queued via the `CRToastManager`
*/

class CRToastManager {
    
    lazy var window : UIWindow = {
        var window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.clearColor()
        window.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight)
        window.windowLevel = UIWindowLevelStatusBar
        window.rootViewController = UIViewController()
        return window
        }()
    
    class var sharedManager : CRToastManager {
        struct Static {
            static let instance : CRToastManager = CRToastManager()
        }
        return Static.instance
    }
    
    var displayQueue : [CRToast] = [CRToast]()
    var options = Dictionary<String, CRToast.Options>()
    var contentViewTypes = Dictionary<String, CRToast.ContentViewType>()
    var showingNotification : Bool {
        return displayQueue.count > 0
    }
    
    private func presentToast(toast : CRToast, completion : ((contentView : UIView) -> ())?) {
        window.hidden = false
        if let viewController = window.rootViewController {
            var contentView = toast.contentView
            contentView.frame = toast.inwardFrame
            viewController.view.addSubview(contentView)
            var statusBarView = toast.statusBarView
            statusBarView.frame = toast.inwardFrame
            viewController.view.addSubview(statusBarView)
            
            switch toast.options.inwardAnimationType {
            case .Linear(let duration):
                UIView.animateWithDuration(
                    duration,
                    animations: { () -> Void in
                        contentView.frame = contentView.frame.replaceX(0).replaceY(0)
                    }) { (_) in if let completionBlock = completion { completionBlock(contentView : contentView) } }
                break
            case .Spring(let damping, let velocity, let duration):
                UIView.animateWithDuration(
                    duration,
                    delay: 0.0,
                    usingSpringWithDamping: damping,
                    initialSpringVelocity: velocity,
                    options: nil,
                    animations: {
                        contentView.frame = contentView.frame.replaceX(0).replaceY(0)
                    }
                    ) { (_) in if let completionBlock = completion { completionBlock(contentView: contentView) } }
                break
            case .Gravity(let magnitude):
                print("")
                break
            }
            
        }
    }
    
    private func dismissToast(toast : CRToast, contentView: UIView, completion : (() -> ())?) {
        if let viewController = window.rootViewController {
            //Dismiss toast
            switch toast.options.outwardAnimationType {
            case .Linear(let duration):
                UIView.animateWithDuration(
                    duration,
                    animations: { () -> Void in
                        contentView.frame = toast.outwardFrame
                    }) { (_) in if let completionBlock = completion { completionBlock() } }
                break
            case .Spring(let damping, let velocity, let duration):
                UIView.animateWithDuration(
                    duration,
                    delay: 0.0,
                    usingSpringWithDamping: damping,
                    initialSpringVelocity: velocity,
                    options: nil,
                    animations: {
                        contentView.frame = toast.outwardFrame
                    }
                    ) { (_) in if let completionBlock = completion { completionBlock() } }
                break
            case .Gravity(let magnitude):
                print("")
                break
            }
            
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    private func displayToast(toast : CRToast) {
        
        if let willAppear = toast.willAppear { willAppear() }
        
        presentToast(toast) { contentView in
            if let didAppear = toast.didAppear { didAppear() }
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(toast.options.duration * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(),
                {
                    if let willDismiss = toast.willDismiss { willDismiss() }
                    self.dismissToast(
                        toast,
                        contentView : contentView
                        ) { () -> () in
                            if let didDismiss = toast.didDismiss { didDismiss() }
                            self.displayQueue.removeAtIndex(0)
                            if let toast = self.displayQueue.first {
                                self.displayToast(toast)
                            }
                    }
                }
            )
        }
    }
    
    private func addToast(toast : CRToast) {
        if !showingNotification {
            displayQueue.append((toast))
            displayToast(toast)
        } else {
            displayQueue.append((toast))
        }
    }
    
    class func showToast(toast : CRToast) {
        self.sharedManager.addToast(toast)
    }
    
    class func kCRToastManagerDefaultOptionsKey() -> String {
        return "kCRToastManagerDefaultOptionsKey";
    }
    
    class func kCRToastManagerDefaultContentViewTypeKey() -> String {
        return "kCRToastManagerDefaultContentViewTypeKey";
    }
    
    //Registering Toast Options
    
    class func optionsForIdentifier(identifier : String) -> CRToast.Options? {
        return self.sharedManager.options[identifier]
    }
    
    class func registerOptions(options : CRToast.Options, identifier : String) {
        self.sharedManager.options[identifier] = options
    }
    
    class func registerOptions(options : CRToast.Options) {
        self.registerOptions(options, identifier: kCRToastManagerDefaultOptionsKey())
    }
    
    class func contentViewTypeForIdentifier(identifier : String) -> CRToast.ContentViewType? {
        return self.sharedManager.contentViewTypes[identifier]
    }
    
    class func registerContentViewType(contentViewType : CRToast.ContentViewType, identifier : String) {
        self.sharedManager.contentViewTypes[identifier] = contentViewType
    }
    
    class func registerContentViewType(contentViewType : CRToast.ContentViewType) {
        self.registerContentViewType(contentViewType, identifier: kCRToastManagerDefaultContentViewTypeKey())
    }
    
    class func generateToast(#optionsIdentifier : String, contentViewTypeIdentifier : String) -> CRToast {
        var options : CRToast.Options
        if let _options =  CRToastManager.sharedManager.options[optionsIdentifier] {
            options = _options
        } else {
            options = CRToast.Options()
        }
        
        var contentViewType : CRToast.ContentViewType
        if let _contentViewType =  CRToastManager.sharedManager.contentViewTypes[contentViewTypeIdentifier] {
            contentViewType = _contentViewType
        } else {
            contentViewType = CRToast.ContentViewType.Default(CRToast.DefaultViewOptions())
        }
        
        return CRToast(
            identifier: NSUUID().UUIDString,
            options : options,
            contentViewType: contentViewType,
            willAppear: nil,
            didAppear: nil,
            willDismiss: nil,
            didDismiss: nil,
            animator: nil
        )
    }
    
    class func generateToast(#optionsIdentifier : String) {
        
    }
    
    class func generateToast(#contentViewTypeIdentifier : String) {
        
    }
    
    class func generateToast(#toastOptions : CRToast.Options) {
        
    }
    
    class func generateToast(#contentViewType : CRToast.ContentViewType) {
        
    }
    
    class func generateToast() -> CRToast {
        return self.generateToast(
            optionsIdentifier : kCRToastManagerDefaultOptionsKey(),
            contentViewTypeIdentifier : kCRToastManagerDefaultContentViewTypeKey()
        )
    }
}

protocol CRToastContentViewProvider {
    var contentViewProvider : CRToast.ContentViewProvider { get }
}

struct CRToast {
    
    //MARK: Definitions
    
    typealias ContentViewProvider = (toast: CRToast, bounds : CGRect) -> UIView
    
    enum ContentViewType {
        case Default(DefaultViewOptions)
        case Custom(ContentViewProvider)
    }
    
    //MARK: - Properties
    
    var identifier : String
    var options : Options
    var contentViewType = ContentViewType.Default(DefaultViewOptions())
    
    var willAppear : (() -> ())? = nil
    var didAppear : (() -> ())? = nil
    var willDismiss : (() -> ())? = nil
    var didDismiss : (() -> ())? = nil
    
    lazy var animator : UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.contentView)
        }()
    
    private var orientation : UIInterfaceOrientation {
        get { return UIApplication.sharedApplication().statusBarOrientation }
    }
    
    private var statusBarAutoAdjustedForOrientation : Bool {
        get { return ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) }
    }
    
    private var width : CGFloat {
        get {
            let mainScreenBounds = UIScreen.mainScreen().bounds
            if  self.statusBarAutoAdjustedForOrientation {
                return CGRectGetWidth(mainScreenBounds)
            }
            
            if UIInterfaceOrientationIsPortrait(orientation) {
                return CGRectGetWidth(mainScreenBounds)
            } else {
                return CGRectGetHeight(mainScreenBounds)
            }
        }
    }
    
    private var statusBarHeight : CGFloat {
        get {
            let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
            if (statusBarAutoAdjustedForOrientation) {
                return CGRectGetHeight(statusBarFrame);
            }
            return (UIInterfaceOrientationIsLandscape(orientation)) ?
                CGRectGetWidth(statusBarFrame) :
                CGRectGetHeight(statusBarFrame);
        }
    }
    
    private var navigationBarHeight : CGFloat {
        get {
            let navigationBarDefaultHeight = 45.0 as CGFloat
            let navigationBariPhoneLandscapeHeight = 33.0 as CGFloat
            if (UIInterfaceOrientationIsPortrait(orientation) ||
                UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
                    return navigationBarDefaultHeight as CGFloat
            } else {
                return navigationBariPhoneLandscapeHeight as CGFloat
            }
        }
    }
    
    private var height : CGFloat {
        get {
            switch options.type {
            case .StatusBar:
                return statusBarHeight
            case .NavigationBar:
                return navigationBarHeight + statusBarHeight
            case .Custom(let preferredHeight):
                return preferredHeight
            }
        }
    }
    
    private func frame(#direction : Direction) -> CGRect {
        var x : CGFloat
        switch direction {
        case .Top, .Bottom:
            x = 0
        case .Left:
            x = -width
        case .Right:
            x = width
        }
        
        var y : CGFloat
        switch direction {
        case .Left, .Right:
            y = 0
        case .Top:
            y = -height
        case .Bottom:
            y = height
        }
        
        return CGRectMake(x, y, width, height)
    }
    
    var inwardFrame : CGRect {
        get { return frame(direction: options.inwardDirection) }
    }
    
    var outwardFrame : CGRect {
        get { return frame(direction: options.outwardDirection) }
    }
    
    private var bounds : CGRect {
        get {
            let inwardFrame = self.inwardFrame
            return CGRect(
                x: 0,
                y: 0,
                width: CGRectGetWidth(inwardFrame),
                height: CGRectGetHeight(inwardFrame)
            )
        }
    }
    
    var contentView : UIView {
        get {
            switch self.contentViewType {
            case .Default(let options):
                return DefaultContentViewProvider(options : options).contentViewProvider(toast: self, bounds: self.bounds)
            case .Custom(let contentProvider):
                return contentProvider(toast: self, bounds: self.bounds)
            }
        }
    }
    
    var statusBarInwardFrame : CGRect {
        get {
            return CGRectZero
        }
    }
    
    var statusBarOutwatdFrame : CGRect {
        get {
            return CGRectZero
        }
    }
    
    var statusBarView : UIView {
        get {
            return UIView()
        }
    }
    
    //MARK: - InteractionType
    
    struct InteractionType : RawOptionSetType {
        typealias RawValue = UInt
        private var value : UInt = 0
        init(_ value: UInt) { self.value = value }
        init(rawValue value: UInt) { self.value = value }
        init(nilLiteral: ()) { self.value = 0 }
        var boolValue: Bool { return self.value != 0 }
        func toRaw() -> UInt { return self.value }
        static var allZeros: InteractionType { return self(0) }
        var rawValue : UInt { return self.value }
        static func fromMask(raw: UInt) -> InteractionType { return self(raw) }
        
        static var None: InteractionType                { return self(0) }
        static var SwipeUp: InteractionType             { return self(0b0000000) }
        static var SwipeDown: InteractionType           { return self(0b0000001) }
        static var SwipeLeft: InteractionType           { return self(0b0000010) }
        static var SwipeRight: InteractionType          { return self(0b0000100) }
        static var TapOnce: InteractionType             { return self(0b0001000) }
        static var TapTwice: InteractionType            { return self(0b0010000) }
        static var TwoFingerTapOnce: InteractionType    { return self(0b0100000) }
        static var TwoFinderTapTwice: InteractionType   { return self(0b1000000) }
        static var Swipe: InteractionType               { return self(SwipeUp.value | SwipeDown.value | SwipeLeft.value | SwipeRight.value) }
        static var Tap: InteractionType                 { return self(TapOnce.value | TapTwice.value | TwoFingerTapOnce.value | TwoFinderTapTwice.value) }
        static var All: InteractionType                 { return self(Swipe.value | Tap.value) }
    }
    
    typealias InteractionResponder = (type : InteractionType) -> ()
    
    //MARK: - Type
    
    enum ToastType : Printable {
        
        case StatusBar
        case NavigationBar(statusBarOnTop : Bool)
        case Custom(height: CGFloat)
        
        var description : String {
            let prefix = "Toast Type "
            switch self {
            case StatusBar:
                return prefix + "Status Bar"
            case NavigationBar(let keepStatusBarOnTop):
                return prefix + "Navigation Bar with keep status bar on top \(keepStatusBarOnTop)"
            case Custom(let height):
                return prefix + "Custom with height: \(height)"
            }
        }
    }
    
    //MARK: - Direction
    
    enum Direction : Printable {
        
        case Top
        case Bottom
        case Left
        case Right
        
        var horizontal : Bool {
            get { return self == Left || self == Right }
        }
        
        var vertical : Bool {
            get { return self == Top || self == Bottom }
        }
        
        var xVector : CGFloat {
            get {
                if vertical {
                    return 0.0
                } else {
                    return self == Left ? 1.0 : -1.0
                }
            }
        }
        
        var yVector : CGFloat {
            get {
                if horizontal {
                    return 0.0
                } else {
                    return self == Top ? 1.0 : -1.0
                }
            }
        }
        
        var gravityDirection : CGVector {
            get { return CGVectorMake(xVector, yVector) }
        }
        
        var description : String {
            let prefix = "Direction "
            switch self {
            case Top:
                return prefix + "Top"
            case Bottom:
                return prefix + "Bottom"
            case Left:
                return prefix + "Left"
            case Right:
                return prefix + "Right"
            }
        }
    }
    
    //MARK: - AnimationType
    
    enum AnimationType : Printable {
        
        case Linear(duration : NSTimeInterval)
        case Spring(damping : CGFloat, velocity : CGFloat, duration : NSTimeInterval)
        case Gravity(magnitude : CGFloat)
        
        var description : String {
            let prefix = "Animation Type "
            switch self {
            case Linear(let duration):
                return prefix + "Linear with duration \(duration)"
            case Spring(let damping, let velocity, let duration):
                return prefix + "Spring with damping \(damping) velocity \(velocity) duration \(duration)"
            case Gravity(let magnitude):
                return prefix + "Gravity with magnitude \(magnitude)"
            }
        }
    }
    
    //MARK: - PresentationType
    
    enum PresentationType : Printable {
        
        case Cover
        case Push
        
        var description : String {
            let prefix = "Presentation Type "
            switch self {
            case Cover:
                return prefix + "Cover"
            case Push:
                return prefix + "Push"
            }
        }
    }
    
    struct Options {
        
        var interactionResponders : [InteractionResponder]? = nil
        
        var duration = 2.0 as NSTimeInterval
        var type = ToastType.NavigationBar(statusBarOnTop: false)
        var presentationType = PresentationType.Cover
        
        var inwardAnimationType = AnimationType.Linear(duration: 0.5)
        var outwardAnimationType = AnimationType.Linear(duration: 0.5)
        
        var inwardDirection = Direction.Top
        var outwardDirection = Direction.Top
        
        private var inGravityDirection : CGVector? {
            get {
                switch inwardAnimationType {
                case .Gravity:
                    return inwardDirection.gravityDirection
                case .Linear, .Spring:
                    return nil
                }
            }
        }
        
        private var outGravityDirection : CGVector? {
            get {
                switch outwardAnimationType {
                case .Gravity:
                    return outwardDirection.gravityDirection
                case .Linear, .Spring:
                    return nil
                }
            }
        }
        
        private var inColisionPoint1 : CGPoint? {
            get {
                switch inwardAnimationType {
                case .Gravity:
                    return CGPoint()
                case .Linear, .Spring:
                    return nil
                }
            }
        }
        
        private var inColisionPoint2 : CGPoint? {
            get {
                switch inwardAnimationType {
                case .Gravity:
                    return CGPoint()
                case .Linear, .Spring:
                    return nil
                }
            }
        }
        
        private var outColisionPoint1 : CGPoint? {
            get {
                switch outwardAnimationType {
                case .Gravity:
                    return CGPoint()
                case .Linear, .Spring:
                    return nil
                }
            }
        }
        
        private var outColisionPoint2 : CGPoint? {
            get {
                switch outwardAnimationType {
                case .Gravity:
                    return CGPoint()
                case .Linear, .Spring:
                    return nil
                }
            }
        }
    }
    
    struct DefaultViewOptions {
        
        // Title Properties
        
        var title : NSString? = nil
        private var titleOptions : Dictionary<String, AnyObject> =
        [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
        ]
        
        var titleFont : UIFont {
            get {
                return titleOptions[NSFontAttributeName as String] as UIFont
            }
            set {
                self.titleOptions[NSFontAttributeName] = newValue
            }
        }
        
        var titleColor : UIColor {
            get {
                return titleOptions[NSForegroundColorAttributeName as String] as UIColor
            }
            set {
                self.titleOptions[NSForegroundColorAttributeName] = newValue
            }
        }
        
        var titleAlignment : NSTextAlignment {
            get {
                var paragraphStyle = self.titleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                return paragraphStyle.alignment
            }
            set {
                var paragraphStyle = self.titleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                var mutableParagraphStyle = paragraphStyle.mutableCopy() as NSMutableParagraphStyle
                mutableParagraphStyle.alignment = newValue
                self.titleOptions[NSParagraphStyleAttributeName] = mutableParagraphStyle
            }
        }
        
        var titleLineSpacing : CGFloat {
            get {
                var paragraphStyle = self.titleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                return paragraphStyle.lineSpacing
            }
            set {
                var paragraphStyle = self.titleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                var mutableParagraphStyle = paragraphStyle.mutableCopy() as NSMutableParagraphStyle
                mutableParagraphStyle.lineSpacing = newValue
                self.titleOptions[NSParagraphStyleAttributeName] = mutableParagraphStyle
            }
        }
        
        var titleNumberOfLines : Int = 1
        
        // Subtitle Properties
        
        var subtitle : NSString? = nil
        private var subtitleOptions : Dictionary<String, AnyObject> =
        [
            NSFontAttributeName : UIFont.systemFontOfSize(12),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
        ]
        
        var subtitleFont : UIFont {
            get {
                return subtitleOptions[NSFontAttributeName as String] as UIFont
            }
            set {
                self.subtitleOptions[NSFontAttributeName] = newValue
            }
        }
        
        var subtitleColor : UIColor {
            get {
                return subtitleOptions[NSForegroundColorAttributeName as String] as UIColor
            }
            set {
                self.subtitleOptions[NSForegroundColorAttributeName] = newValue
            }
        }
        
        var subtitleAlignment : NSTextAlignment {
            get {
                var paragraphStyle = self.subtitleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                return paragraphStyle.alignment
            }
            set {
                var paragraphStyle = self.subtitleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                var mutableParagraphStyle = paragraphStyle.mutableCopy() as NSMutableParagraphStyle
                mutableParagraphStyle.alignment = newValue
                self.subtitleOptions[NSParagraphStyleAttributeName] = mutableParagraphStyle
            }
        }
        
        var subtitleLineSpacing : CGFloat {
            get {
                var paragraphStyle = self.subtitleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                return paragraphStyle.lineSpacing
            }
            set {
                var paragraphStyle = self.subtitleOptions[NSParagraphStyleAttributeName] as NSParagraphStyle
                var mutableParagraphStyle = paragraphStyle.mutableCopy() as NSMutableParagraphStyle
                mutableParagraphStyle.lineSpacing = newValue
                self.subtitleOptions[NSParagraphStyleAttributeName] = mutableParagraphStyle
            }
        }
        
        var subtitleNumberOfLines : Int = 1
        
        //Image
        
        var leftImage : UIImage? = nil
        var rightImage : UIImage? = nil
        
        //Background
        
        var backgroundColor = UIColor.redColor()
    }
    
    struct DefaultContentViewProvider : CRToastContentViewProvider {
        
        var options : DefaultViewOptions
        
        var contentViewProvider : CRToast.ContentViewProvider {
            return {
                (toast: CRToast, bounds : CGRect) -> UIView in
                return DefaultContentView(frame: bounds, options: self.options)
            }
        }
        
        private class DefaultContentView : UIView {
            
            var titleLabel = UILabel()
            var subtitleLabel = UILabel()
            var leftImageView = UIImageView()
            var rightImageView = UIImageView()
            
            var options : DefaultViewOptions = DefaultViewOptions()
            
            func loadOptions() {
                self.backgroundColor = options.backgroundColor
                
                if let title = self.options.title {
                    self.titleLabel.hidden = false
                    self.titleLabel.attributedText = NSAttributedString(
                        string : title,
                        attributes : options.titleOptions
                    )
                    self.titleLabel.sizeToFit()
                } else {
                    self.titleLabel.hidden = true
                }
                
                if let subtitle = self.options.subtitle {
                    subtitleLabel.hidden = false
                    subtitleLabel.attributedText = NSAttributedString(
                        string : subtitle,
                        attributes : options.subtitleOptions
                    )
                    subtitleLabel.sizeToFit()
                } else {
                    subtitleLabel.hidden = true
                }
                
                if let leftImage = self.options.leftImage {
                    leftImageView.hidden = false
                    leftImageView.image = leftImage
                    leftImageView.sizeToFit()
                } else {
                    leftImageView.hidden = true
                }
                
                if let rightImage = self.options.rightImage {
                    rightImageView.image = rightImage
                    rightImageView.sizeToFit()
                    rightImageView.hidden = false
                } else {
                    rightImageView.hidden = true
                }
                
                self.titleLabel.numberOfLines = self.options.titleNumberOfLines
                self.subtitleLabel.numberOfLines = self.options.subtitleNumberOfLines
                
                self.setNeedsLayout()
            }
            
            init(frame: CGRect, options : DefaultViewOptions) {
                super.init(frame: frame)
                self.options = options
                loadOptions()
                self.addSubview(self.titleLabel)
                self.addSubview(self.subtitleLabel)
                self.addSubview(self.leftImageView)
                self.addSubview(self.rightImageView)
            }
            
            override func layoutSubviews() {
                super.layoutSubviews()
                
                let margin : CGFloat = 10.0
                
                func viewHasContent(view : UIView) -> Bool { return (CGRectGetWidth(view.bounds) != 0.0 || CGRectGetHeight(view.bounds) != 0) }
                
                //Layout Left Image
                
                self.leftImageView.frame = self.leftImageView.image != nil ? CGRect(
                    x: margin,
                    y: (CGRectGetHeight(self.bounds)-CGRectGetHeight(self.leftImageView.bounds))/2.0,
                    width: CGRectGetWidth(self.leftImageView.bounds),
                    height: CGRectGetHeight(self.leftImageView.bounds)
                    ) : CGRectZero
                
                //Layout Right Image
                
                self.rightImageView.frame = self.rightImageView.image != nil ? CGRect(
                    x: CGRectGetWidth(self.bounds)-margin-CGRectGetWidth(self.rightImageView.bounds),
                    y: (CGRectGetHeight(self.bounds)-CGRectGetHeight(self.rightImageView.bounds))/2.0,
                    width: CGRectGetWidth(self.rightImageView.bounds),
                    height: CGRectGetHeight(self.rightImageView.bounds)
                    ) : CGRectZero.replaceX(self.bounds.width)
                
                var needMarginBetweenLabels = (viewHasContent(self.titleLabel) && viewHasContent(self.subtitleLabel))
                
                //Labels are layout out displayed with all content up to their specified number of lines and vertically
                //centered in the notification. There is a 10px margin between the title label and subtitle labels if
                //both are configured
                
                let labelContentHeight = CGRectGetHeight(self.titleLabel.bounds) +
                    (needMarginBetweenLabels ? margin : 0.0) +
                    CGRectGetHeight(self.subtitleLabel.bounds)
                
                //The labels are given the full width between the left and right image views minus a 10px margin
                
                let labelWidth = CGRectGetMinX(self.rightImageView.frame)-2*margin-CGRectGetMaxX(self.leftImageView.frame)
                
                self.titleLabel.frame = viewHasContent(self.titleLabel) ? CGRect(
                    x: CGRectGetMaxX(self.leftImageView.frame)+margin,
                    y:(CGRectGetHeight(self.bounds)-labelContentHeight)/2.0,
                    width:labelWidth,
                    height:CGRectGetHeight(self.titleLabel.bounds)
                    ) : CGRectZero
                
                self.subtitleLabel.frame = viewHasContent(self.subtitleLabel) ? CGRect(
                    x: CGRectGetMaxX(self.leftImageView.frame)+margin,
                    y: viewHasContent(self.titleLabel) ?
                        CGRectGetMaxY(self.titleLabel.frame)+margin : (CGRectGetHeight(self.bounds)-labelContentHeight)/2.0,
                    width: CGRectGetMinX(self.rightImageView.frame)-2*margin-CGRectGetMaxX(self.leftImageView.frame),
                    height: CGRectGetHeight(self.subtitleLabel.bounds)
                    ) : CGRectZero
            }
            
            required init(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)
            }
        }
    }
}