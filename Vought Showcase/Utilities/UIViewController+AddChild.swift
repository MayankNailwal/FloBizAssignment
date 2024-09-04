//
//  UIViewController+AddChild.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import UIKit

/// Extension on UIViewController
extension UIViewController {
    
    /// Add child view controller to container view
    /// - Parameters:
    ///  - viewController: Child view controller
    ///  - containerView: Container view
    func add(asChildViewController viewController: UIViewController) { // removed container view as we need the images in full screen and not in a contained view inside our VC
        
        //        addChild(viewController)
        //        containerView.addSubview(viewController.view)
        //        viewController.view.frame = containerView.bounds
        //        viewController.view.autoresizingMask = [.flexibleWidth,
        //                                                .flexibleHeight]
        //        viewController.didMove(toParent:
        //                                self)
        
        addChild(viewController)
               viewController.view.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
               view.addSubview(viewController.view)
               viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               viewController.didMove(toParent: self)
               
               // animate the view to slide up from the bottom
        UIView.animate(withDuration: 0.3) {
                   viewController.view.frame = self.view.bounds
               }
    }
}
