//
//  ArrowView.swift
//  InfiniteCanvas
//
//  Created by Simon Støvring on 20/07/2020.
//

import UIKit

final class ArrowView: UIView {
    enum Direction {
        case top
        case left
        case bottom
        case right
    }

    private let direction: Direction

    init(direction: Direction) {
        self.direction = direction
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        if let backgroundColor = backgroundColor {
            context?.setFillColor(backgroundColor.cgColor)
            context?.fill(rect)
        }
        if let tintColor = tintColor {
            context?.setFillColor(tintColor.cgColor)
            let path = arrowPath(in: rect)
            context?.addPath(path.cgPath)
            context?.fillPath()
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }
}

private extension ArrowView {
    private func arrowPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        switch direction {
        case .top:
            path.move(to: CGPoint(x: rect.midX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.close()
        case .left:
            path.move(to: CGPoint(x: 0, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.close()
        case .bottom:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.close()
        case .right:
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: rect.minY))
            path.close()
        }
        return path
    }
}
