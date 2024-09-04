//
//  HughieCarouselItem.swift
//  Vought Showcase
//
//  Created by MAYANK NAILWAL on 03/09/24.
//

import UIKit


final class HughieCarouselItem: CarouselItem { // CarouseItem protocol returns a UIViewController using getController()
    private var viewController: UIViewController?
    
    /// Get controller
    /// - Returns: View controller
    func getController() -> UIViewController {
        // Check if view controller is already created
        // If not, create new view controller
        // else return the existing view controller
        guard let viewController = viewController else {
            viewController = ImageViewController(imageName: "hughei")
            return viewController!
        }
        return viewController
    }
}
