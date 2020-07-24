//
//  BaseCanvasViewController.swift
//  InfiniteCanvas
//
//  Created by Simon Støvring on 20/07/2020.
//

import UIKit
import PencilKit

final class CanvasViewController: UIViewController {
    private let contentView = CanvasView()
    private let toolPicker = PKToolPicker()
    private var haveScrolledToInitialOffset = false
    private let canvasSize = CGSize(width: 1000000, height: 1000000)

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.canvasView.delegate = self
        contentView.canvasView.contentSize = canvasSize
        contentView.editButton.addTarget(self, action: #selector(toggleDrawing), for: .touchUpInside)
        toolPicker.addObserver(contentView.canvasView)
        toolPicker.addObserver(self)
        endDrawing()
        layoutArrows()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToInitialContentOffsetIfNecessary()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateCanvasBottomOffset()
    }
}

private extension CanvasViewController {
    @objc private func toggleDrawing() {
        if contentView.canvasView.isFirstResponder {
            endDrawing()
        } else {
            beginDrawing()
        }
    }

    private func beginDrawing() {
        contentView.canvasView.becomeFirstResponder()
        toolPicker.setVisible(true, forFirstResponder: contentView.canvasView)
        contentView.editButton.setTitle("Done", for: .normal)
        updateCanvasBottomOffset()
        layoutArrows()
    }

    private func endDrawing() {
        contentView.canvasView.resignFirstResponder()
        toolPicker.setVisible(false, forFirstResponder: contentView.canvasView)
        contentView.editButton.setTitle("Start Drawing", for: .normal)
        updateCanvasBottomOffset()
        layoutArrows()
    }

    private func scrollToInitialContentOffsetIfNecessary() {
        if !haveScrolledToInitialOffset {
            let canvasView = contentView.canvasView
            let centerOffsetX = (canvasView.contentSize.width - canvasView.frame.width) / 2
            let centerOffsetY = (canvasView.contentSize.height - canvasView.frame.height) / 2
            canvasView.contentOffset = CGPoint(x: centerOffsetX, y: centerOffsetY)
            haveScrolledToInitialOffset = true
        }
    }

    private func layoutArrows() {
        // We get the frame of all strokes in the drawing everytime we layout the arrows,
        // which is everytime the user scrolls around the canvas. For large drawings this
        // could probably be an expensive operation. Maybe this can be improved by inspecting
        // the strokes in -canvasViewDrawingDidChange(_:) and updating a frame as the strokes
        // changes. This possible optimization is left out of this example project.
        let canvasView = contentView.canvasView
        guard let drawingFrame = canvasView.drawing.strokesFrame else {
            contentView.topArrow.isHidden = true
            contentView.leftArrow.isHidden = true
            contentView.bottomArrow.isHidden = true
            contentView.rightArrow.isHidden = true
            return
        }
        let zoomScale = contentView.canvasView.zoomScale
        let arrowSize = CGSize(width: 10, height: 8)
        // The amount that the drawing should be scrolled out of the canvas for the arrows to appear.
        let minimumDistance = 100 * zoomScale
        let topDistance = canvasView.contentOffset.y - drawingFrame.minY * zoomScale
        let leftDistance = canvasView.contentOffset.x - drawingFrame.minX * zoomScale
        let bottomDistance = drawingFrame.maxY * zoomScale - canvasView.contentOffset.y
        let rightDistance = drawingFrame.maxX * zoomScale - canvasView.contentOffset.x
        contentView.topArrow.isHidden = topDistance < minimumDistance
        contentView.leftArrow.isHidden = leftDistance < minimumDistance
        contentView.bottomArrow.isHidden = bottomDistance < (canvasView.frame.height + minimumDistance)
        contentView.rightArrow.isHidden = rightDistance < (canvasView.frame.width + minimumDistance)
        let centerOffsetX = (canvasView.contentSize.width - canvasView.frame.width) / 2
        let centerOffsetY = (canvasView.contentSize.height - canvasView.frame.height) / 2
        let topPreferredX = (drawingFrame.midX * zoomScale - centerOffsetX) - (canvasView.contentOffset.x - centerOffsetX) + arrowSize.width / 2
        let topX = min(max(topPreferredX, 0), canvasView.frame.width - arrowSize.width)
        let leftPreferredY = (drawingFrame.midY * zoomScale - centerOffsetY) - (canvasView.contentOffset.y - centerOffsetY) + arrowSize.height / 2
        let leftMinY = view.safeAreaInsets.top + arrowSize.width
        let leftMaxY = canvasView.frame.height - view.safeAreaInsets.bottom - arrowSize.height - arrowSize.width
        let leftY = min(max(leftPreferredY, leftMinY), leftMaxY)
        let rightX = canvasView.frame.width - arrowSize.width
        let bottomY = canvasView.frame.height - canvasView.safeAreaInsets.bottom - arrowSize.height
        contentView.topArrow.frame = CGRect(x: topX, y: view.safeAreaInsets.top, width: arrowSize.width, height: arrowSize.height)
        contentView.leftArrow.frame = CGRect(x: 0, y: leftY, width: arrowSize.height, height: arrowSize.width)
        contentView.bottomArrow.frame = CGRect(x: topX, y: bottomY, width: arrowSize.width, height: arrowSize.height)
        contentView.rightArrow.frame = CGRect(x: rightX, y: leftY, width: arrowSize.height, height: arrowSize.width)
        contentView.topArrow.setNeedsDisplay()
        contentView.leftArrow.setNeedsDisplay()
        contentView.bottomArrow.setNeedsDisplay()
        contentView.rightArrow.setNeedsDisplay()
    }

    private func updateCanvasBottomOffset() {
        if traitCollection.horizontalSizeClass == .compact {
            let frame = toolPicker.frameObscured(in: contentView)
            contentView.canvasBottomOffset = frame.height
        } else {
            contentView.canvasBottomOffset = 0
        }
        contentView.updateConstraintsIfNeeded()
        contentView.layoutIfNeeded()
    }
}

extension CanvasViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        layoutArrows()
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        layoutArrows()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutArrows()
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}

extension CanvasViewController: PKToolPickerObserver {
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        updateCanvasBottomOffset()
    }
}
