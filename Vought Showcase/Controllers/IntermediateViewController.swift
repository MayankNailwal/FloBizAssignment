//
//  IntermediateViewController.swift
//  Vought Showcase
//
//  Created by MAYANK NAILWAL on 04/09/24.
//

import UIKit

import UIKit

class IntermediateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupLabel()
    }
    
    private func setupLabel() {
            let label = UILabel()
            label.text = "Vought Showcase"
            label.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            // adjust text color based on the current user interface style
            if traitCollection.userInterfaceStyle == .dark {
                label.textColor = .white
            } else {
                label.textColor = .black
            }
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func setupButton() {
        let button = FBCustomButton(backgroundColor: .systemGreen, title: "Show Heroes")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showCarousel), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func showCarousel() {
        let carouselItemProvider = CarouselItemDataSourceProvider()
        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
        
        // Present CarouselViewController with bottom-up animation
        presentCarouselViewController(carouselViewController)
    }
    
    private func presentCarouselViewController(_ carouselViewController: CarouselViewController) {
        //add carouselVC as child
        add(asChildViewController: carouselViewController)
        
        //postion carouselVC off screen below
        carouselViewController.view.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
        
        // animate the carousel view controller sliding up
        UIView.animate(withDuration: 0.3, animations: {
            carouselViewController.view.frame = self.view.bounds
        })
    }
}

