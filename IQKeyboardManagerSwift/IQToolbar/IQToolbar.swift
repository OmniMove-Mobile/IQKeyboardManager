//
//  IQToolbar.swift
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-20 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/** @abstract   IQToolbar for IQKeyboardManager.    */
@available(iOSApplicationExtension, unavailable)
@objc open class IQToolbar: UIToolbar, UIInputViewAudioFeedback {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    private func initialize() {

        sizeToFit()

        autoresizingMask = .flexibleWidth
        self.isTranslucent = true
        self.barTintColor = nil

        let positions: [UIBarPosition] = [.any, .bottom, .top, .topAttached]

        for position in positions {

            self.setBackgroundImage(nil, forToolbarPosition: position, barMetrics: .default)
            self.setShadowImage(nil, forToolbarPosition: .any)
        }

        // Background color
        self.backgroundColor = nil
    }

    /**
     Previous bar button of toolbar.
     */
    private var privatePreviousBarButton: IQBarButtonItem?
    @objc open var previousBarButton: IQBarButtonItem {
        get {
            if privatePreviousBarButton == nil {
                privatePreviousBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
            }
            return privatePreviousBarButton!
        }

        set (newValue) {
            privatePreviousBarButton = newValue
        }
    }

    /**
     Next bar button of toolbar.
     */
    private var privateNextBarButton: IQBarButtonItem?
    @objc open var nextBarButton: IQBarButtonItem {
        get {
            if privateNextBarButton == nil {
                privateNextBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
            }
            return privateNextBarButton!
        }

        set (newValue) {
            privateNextBarButton = newValue
        }
    }

    /**
     Title bar button of toolbar.
     */
    private var privateTitleBarButton: IQTitleBarButtonItem?
    @objc open var titleBarButton: IQTitleBarButtonItem {
        get {
            if privateTitleBarButton == nil {
                privateTitleBarButton = IQTitleBarButtonItem(title: nil)
                privateTitleBarButton?.accessibilityLabel = "Title"
                privateTitleBarButton?.accessibilityIdentifier = privateTitleBarButton?.accessibilityLabel
            }
            return privateTitleBarButton!
        }

        set (newValue) {
            privateTitleBarButton = newValue
        }
    }

    /**
     Done bar button of toolbar.
     */
    private var privateDoneBarButton: IQBarButtonItem?
    @objc open var doneBarButton: IQBarButtonItem {
        get {
            if privateDoneBarButton == nil {
                privateDoneBarButton = IQBarButtonItem(title: nil, style: .done, target: nil, action: nil)
            }
            return privateDoneBarButton!
        }

        set (newValue) {
            privateDoneBarButton = newValue
        }
    }

    /**
     Fixed space bar button of toolbar.
     */
    private var privateFixedSpaceBarButton: IQBarButtonItem?
    @objc open var fixedSpaceBarButton: IQBarButtonItem {
        get {
            if privateFixedSpaceBarButton == nil {
                privateFixedSpaceBarButton = IQBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            }
            privateFixedSpaceBarButton!.isSystemItem = true
            privateFixedSpaceBarButton!.width = 6

            return privateFixedSpaceBarButton!
        }

        set (newValue) {
            privateFixedSpaceBarButton = newValue
        }
    }

    @objc override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFit = super.sizeThatFits(size)
        sizeThatFit.height = 44
        return sizeThatFit
    }

    @objc override open var tintColor: UIColor! {

        didSet {
            if let unwrappedItems = items {
                for item in unwrappedItems {
                    item.tintColor = tintColor
                }
            }
        }
    }

    @objc open var enableInputClicksWhenVisible: Bool {
        return true
    }
}

@available(iOSApplicationExtension, unavailable)
@objc final class IQKeyboardToolbarView: UIView, UIInputViewAudioFeedback {

    private enum Layout {
        static let toolbarHeight: CGFloat = 44
        static let minimumButtonWidth: CGFloat = 44
        static let horizontalPadding: CGFloat = 8
        static let interItemSpacing: CGFloat = 6
        static let titleSpacing: CGFloat = 12
    }

    private static func makeToolbarButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.adjustsImageWhenDisabled = false
        button.adjustsImageWhenHighlighted = false
        button.imageView?.contentMode = .scaleAspectFit
        button.showsTouchWhenHighlighted = false
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.isExclusiveTouch = true
        button.layer.cornerRadius = 0
        button.layer.masksToBounds = true
        return button
    }

    private let topBorderView = UIView()
    private let leadingStackView = UIStackView()
    private let previousButton = makeToolbarButton()
    private let nextButton = makeToolbarButton()
    private let doneButton = makeToolbarButton()
    private let titleLabel = UILabel()

    var previousBarButton: IQBarButtonItem? {
        didSet {
            configure(button: previousButton, with: previousBarButton)
        }
    }

    var nextBarButton: IQBarButtonItem? {
        didSet {
            configure(button: nextButton, with: nextBarButton)
        }
    }

    var doneBarButton: IQBarButtonItem? {
        didSet {
            configure(button: doneButton, with: doneBarButton)
        }
    }

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
            titleLabel.isHidden = titleText?.isEmpty != false
        }
    }

    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont ?? UIFont.systemFont(ofSize: 13)
        }
    }

    var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor ?? defaultSecondaryLabelColor()
        }
    }

    var barStyle: UIBarStyle = .default {
        didSet {
            updateColors()
        }
    }

    var barTintColorOverride: UIColor? {
        didSet {
            updateColors()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: Layout.toolbarHeight)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Layout.toolbarHeight)
    }

    override var tintColor: UIColor! {
        didSet {
            applyTintColor()
        }
    }

    var enableInputClicksWhenVisible: Bool {
        true
    }

    func refreshButtonStates() {
        configure(button: previousButton, with: previousBarButton)
        configure(button: nextButton, with: nextBarButton)
        configure(button: doneButton, with: doneBarButton)
    }

    private func initialize() {
        autoresizingMask = .flexibleWidth
        semanticContentAttribute = .unspecified
        preservesSuperviewLayoutMargins = true
        insetsLayoutMarginsFromSafeArea = false
        frame.size.height = Layout.toolbarHeight
        clipsToBounds = true
        isOpaque = true

        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topBorderView)

        leadingStackView.axis = .horizontal
        leadingStackView.spacing = Layout.interItemSpacing
        leadingStackView.alignment = .center
        leadingStackView.semanticContentAttribute = .spatial
        leadingStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leadingStackView)

        [previousButton, nextButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: Layout.toolbarHeight),
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: Layout.minimumButtonWidth)
            ])
            leadingStackView.addArrangedSubview(button)
        }

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: Layout.toolbarHeight),
            doneButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Layout.minimumButtonWidth)
        ])
        addSubview(doneButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            topBorderView.topAnchor.constraint(equalTo: topAnchor),
            topBorderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 0.5),

            leadingStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalPadding),
            leadingStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalPadding),
            doneButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingStackView.trailingAnchor, constant: Layout.titleSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: doneButton.leadingAnchor, constant: -Layout.titleSpacing)
        ])

        let titleWidthConstraint = titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5)
        titleWidthConstraint.priority = .defaultHigh
        titleWidthConstraint.isActive = true

        updateColors()
        applyTintColor()
    }

    private func updateColors() {
        let isDark = barStyle == .black

        if let overrideColor = barTintColorOverride {
            backgroundColor = overrideColor
        } else if isDark {
            backgroundColor = darkKeyboardBackgroundColor()
        } else {
            backgroundColor = defaultBackgroundColor()
        }

        topBorderView.backgroundColor = isDark ? darkKeyboardSeparatorColor() : defaultSeparatorColor()
        if titleColor == nil {
            titleLabel.textColor = isDark ? UIColor(white: 0.82, alpha: 1.0) : defaultSecondaryLabelColor()
        }
    }

    private func defaultBackgroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondarySystemBackground
        } else {
            return UIColor(white: 0.98, alpha: 1.0)
        }
    }

    private func defaultSeparatorColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return UIColor(white: 0.78, alpha: 1.0)
        }
    }

    private func darkKeyboardBackgroundColor() -> UIColor {
        UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
    }

    private func darkKeyboardSeparatorColor() -> UIColor {
        UIColor(white: 1.0, alpha: 0.12)
    }

    private func defaultSecondaryLabelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            return UIColor.darkGray
        }
    }

    private func applyTintColor() {
        let resolvedTint = tintColor ?? UIColor.systemBlue
        [previousButton, nextButton, doneButton].forEach { button in
            button.tintColor = resolvedTint
            button.setTitleColor(resolvedTint, for: .normal)
            button.setTitleColor(resolvedTint.withAlphaComponent(0.55), for: .disabled)
            button.setBackgroundImage(nil, for: .normal)
            button.setBackgroundImage(nil, for: .highlighted)
            button.setBackgroundImage(nil, for: .disabled)
        }
    }

    private func configure(button: UIButton, with item: IQBarButtonItem?) {
        button.removeTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        guard let item = item else {
            button.isHidden = true
            button.isEnabled = false
            button.setImage(nil, for: .normal)
            button.setTitle(nil, for: .normal)
            button.accessibilityLabel = nil
            button.accessibilityIdentifier = nil
            return
        }

        button.isHidden = false
        button.isEnabled = item.isEnabled
        button.alpha = item.isEnabled ? 1.0 : 0.55
        button.accessibilityLabel = item.accessibilityLabel
        button.accessibilityIdentifier = item.accessibilityIdentifier

        if let image = item.image {
            button.setImage(image, for: .normal)
            button.setTitle(nil, for: .normal)
        } else {
            button.setImage(nil, for: .normal)
            button.setTitle(item.title, for: .normal)
        }

        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        if sender === previousButton, let item = previousBarButton {
            trigger(item: item)
        } else if sender === nextButton, let item = nextBarButton {
            trigger(item: item)
        } else if sender === doneButton, let item = doneBarButton {
            trigger(item: item)
        }
    }

    private func trigger(item: IQBarButtonItem) {
        if let action = item.action {
            UIApplication.shared.sendAction(action, to: item.target, from: item, for: nil)
        }
    }
}
