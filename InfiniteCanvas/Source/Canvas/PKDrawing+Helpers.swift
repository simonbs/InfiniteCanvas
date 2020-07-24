//
//  PKDrawing+Helpers.swift
//  InfiniteCanvas
//
//  Created by Simon Støvring on 20/07/2020.
//

import PencilKit

extension PKDrawing {
    var strokesFrame: CGRect? {
        guard !strokes.isEmpty else {
            return nil
        }
        var minPoint = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
        var maxPoint = CGPoint(x: 0, y: 0)
        for stroke in strokes {
            let renderBounds = stroke.renderBounds
            if renderBounds.minX < minPoint.x {
                minPoint.x = floor(renderBounds.minX)
            }
            if renderBounds.minY < minPoint.y {
                minPoint.y = floor(renderBounds.minY)
            }
            if renderBounds.maxX > maxPoint.x {
                maxPoint.x = ceil(renderBounds.maxX)
            }
            if renderBounds.maxY > maxPoint.y {
                maxPoint.y = ceil(renderBounds.maxY)
            }
        }
        return CGRect(x: minPoint.x, y: minPoint.y, width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y)
    }
}
