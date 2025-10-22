//
//  NYTPhotoCaptionView.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/18/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

private let horizontalMargin: CGFloat = 8.0
private let verticalMargin: CGFloat = 7.0

/// A view used to display the caption for a photo.
///
/// This is used by default when no custom caption view is provided.
@MainActor
public class NYTPhotoCaptionView: UIView, NYTPhotoCaptionViewLayoutWidthHinting {
    
    // MARK: - Properties
    
    public let attributedTitle: NSAttributedString?
    public let attributedSummary: NSAttributedString?
    public let attributedCredit: NSAttributedString?
    
    private let textView: UITextView
    private let gradientLayer: CAGradientLayer
    
    public var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet {
            let newValue = ceil(preferredMaxLayoutWidth)
            if abs(oldValue - newValue) > 0.1 {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    // MARK: - Initialization
    
    /// Designated initializer that takes all the caption attributed strings as arguments.
    ///
    /// - Parameters:
    ///   - attributedTitle: The attributed string used as the title. The top string in the caption view.
    ///   - attributedSummary: The attributed string used as the summary. The second from the top string in the caption view.
    ///   - attributedCredit: The attributed string used as the credit. The third from the top string in the caption view.
    public init(attributedTitle: NSAttributedString?, attributedSummary: NSAttributedString?, attributedCredit: NSAttributedString?) {
        self.attributedTitle = attributedTitle
        self.attributedSummary = attributedSummary
        self.attributedCredit = attributedCredit
        self.textView = UITextView(frame: .zero, textContainer: nil)
        self.gradientLayer = CAGradientLayer()
        
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.attributedTitle = nil
        self.attributedSummary = nil
        self.attributedCredit = nil
        self.textView = UITextView(frame: .zero, textContainer: nil)
        self.gradientLayer = CAGradientLayer()
        
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setupTextView()
        updateTextViewAttributedText()
        setupGradient()
    }
    
    // MARK: - Setup
    
    private func setupTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.dataDetectorTypes = []
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.widthAnchor.constraint(equalTo: widthAnchor),
            textView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupGradient() {
        gradientLayer.frame = layer.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.85).cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateTextViewAttributedText() {
        let attributedLabelText = NSMutableAttributedString()
        
        if let title = attributedTitle {
            attributedLabelText.append(title)
        }
        
        if let summary = attributedSummary {
            if attributedTitle != nil {
                attributedLabelText.append(NSAttributedString(string: "\n"))
            }
            attributedLabelText.append(summary)
        }
        
        if let credit = attributedCredit {
            if attributedTitle != nil || attributedSummary != nil {
                attributedLabelText.append(NSAttributedString(string: "\n"))
            }
            attributedLabelText.append(credit)
        }
        
        textView.attributedText = attributedLabelText
    }
    
    // MARK: - UIView Overrides
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(lessThanOrEqualTo: superview.heightAnchor, multiplier: 0.3)
        ])
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        func updateGradientFrame() {
            if #available(iOS 11.0, *) {
                let safeAreaInsets = window?.safeAreaInsets ?? .zero
                let selfBounds = layer.bounds
                gradientLayer.frame = CGRect(
                    x: selfBounds.origin.x - safeAreaInsets.left,
                    y: selfBounds.origin.y + safeAreaInsets.bottom,
                    width: selfBounds.size.width + safeAreaInsets.left + safeAreaInsets.right,
                    height: selfBounds.size.height + safeAreaInsets.bottom
                )
            } else {
                gradientLayer.frame = layer.bounds
            }
        }
        
        updateGradientFrame()
        
        // On iOS 8.x, when this view is height-constrained, neither `self.bounds` nor `self.layer.bounds` reflects the new layout height immediately after `layoutSubviews`. Both of those properties appear correct in the next runloop.
        DispatchQueue.main.async {
            updateGradientFrame()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let contentSize = textView.sizeThatFits(CGSize(width: preferredMaxLayoutWidth, height: .greatestFiniteMagnitude))
        let width = preferredMaxLayoutWidth
        let height = ceil(contentSize.height)
        
        return CGSize(width: width, height: height)
    }
}

