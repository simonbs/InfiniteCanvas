//
//  CanvasView.swift
//  InfiniteCanvas
//
//  Created by Simon Støvring on 24/07/2020.
//

import UIKit
import PencilKit

final class CanvasView: UIView {
    let canvasView: PKCanvasView = {
        let this = PKCanvasView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.backgroundColor = .systemBackground
        this.minimumZoomScale = 0.25
        this.maximumZoomScale = 1
        this.zoomScale = 1
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        return this
    }()
    let topArrow: ArrowView = {
        let this = ArrowView(direction: .top)
        this.tintColor = .label
        return this
    }()
    let leftArrow: ArrowView = {
        let this = ArrowView(direction: .left)
        this.tintColor = .label
        return this
    }()
    let bottomArrow: ArrowView = {
        let this = ArrowView(direction: .bottom)
        this.tintColor = .label
        return this
    }()
    let rightArrow: ArrowView = {
        let this = ArrowView(direction: .right)
        this.tintColor = .label
        return this
    }()
    let editButton: UIButton = {
        let this = UIButton(type: .system)
        this.translatesAutoresizingMaskIntoConstraints = false
        return this
    }()
    var canvasBottomOffset: CGFloat = 0 {
        didSet {
            if canvasBottomOffset != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    private var canvasBottomConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(canvasView)
        addSubview(topArrow)
        addSubview(leftArrow)
        addSubview(bottomArrow)
        addSubview(rightArrow)
        addSubview(editButton)
    }

    private func setupLayout() {
        canvasView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        canvasView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        canvasBottomConstraint = canvasView.bottomAnchor.constraint(equalTo: bottomAnchor)
        canvasBottomConstraint?.isActive = true

        editButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        editButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
    }

    override func updateConstraints() {
        super.updateConstraints()
        canvasBottomConstraint?.constant = -canvasBottomOffset
    }
}
