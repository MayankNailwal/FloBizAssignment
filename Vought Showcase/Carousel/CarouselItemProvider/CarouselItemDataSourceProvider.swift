//
//  CarouselItemDataSourceProvider.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import Foundation

class CarouselItemDataSourceProvider: CarouselItemDataSourceProviderType { //protocol that returns carousel items
    func items() -> [CarouselItem] {
        return [
            ButcherCarouselItem(),
            FrenchieCarouselItem(),
            HughieCarouselItem(),
            MMCarouselItem(),
        ]
    }
}
