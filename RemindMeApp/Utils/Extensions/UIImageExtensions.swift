//
//  UIImageExtensions.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import UIKit

extension UIImage {
    func resizeTo(_ newSize: CGFloat) -> UIImage {
        let size = CGSize(width: newSize, height: newSize)
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        
        return image.withRenderingMode(renderingMode)
    }
}
