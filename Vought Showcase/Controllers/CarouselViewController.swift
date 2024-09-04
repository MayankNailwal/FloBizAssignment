//
//  CarouselViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import UIKit


final class CarouselViewController: UIViewController {
    
    /// Container view for the carousel
    @IBOutlet private weak var containerView: UIView!


    private var segmentedProgressBar: SegmentedProgressBar!
    /// Page view controller for carousel
    private var pageViewController: UIPageViewController?
    
    /// Carousel items
    private var items: [CarouselItem] = []
    
    /// Current item index
    private var currentItemIndex: Int = 0 {
        didSet {
            if oldValue != currentItemIndex {  // avoid recursive loop
                print("did set run")
                segmentedProgressBar.delegate?.segmentedProgressBarChangedIndex(index: currentItemIndex)
            }
        }
    }

    
       private var isPaused = false

    /// Initializer
    /// - Parameter items: Carousel items
    public init(items: [CarouselItem]) {
        //now populated with boys character
        self.items = items
        super.init(nibName: "CarouselViewController", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupSegmentedProgressBar()
            setupPageViewController()
            setupGestures()
            startSegmentedProgressBarAnimation()
        }
    
    
    private func setupSegmentedProgressBar() {
        segmentedProgressBar = SegmentedProgressBar(numberOfSegments: items.count)
        segmentedProgressBar.delegate = self
        view.addSubview(segmentedProgressBar)
        segmentedProgressBar.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 7)
        
        // set the z position to ensure its on top of other views
        segmentedProgressBar.layer.zPosition = 1
    }


    
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        pageViewController?.setViewControllers([getController(at: currentItemIndex)], direction: .forward, animated: true)

        if let scrollView = pageViewController?.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.isScrollEnabled = false
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
        
        add(asChildViewController: pageViewController!)
    }

    
    
    private func setupGestures() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
                swipeDownGesture.direction = .down
                view.addGestureRecognizer(swipeDownGesture)
        
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
           view.addGestureRecognizer(tapGesture)
           
           let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
           view.addGestureRecognizer(longPressGesture)
       }
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
            if gesture.direction == .down {
                dismissCarouselViewController()
            }
        }
    
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let screenWidth = view.bounds.width
        let midX = screenWidth / 2

        if location.x < midX {
            print("Left tapped")
            previousItem()
        } else {
            print("Right tapped")
            nextItem()
        }
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                pauseSegmentedProgressBar()
            } else if gesture.state == .ended {
                resumeSegmentedProgressBar()
            }
        }

        private func pauseSegmentedProgressBar() {
            isPaused = true
            segmentedProgressBar.isPaused = true
            pageViewController?.view.isUserInteractionEnabled = false
        }
        
        private func resumeSegmentedProgressBar() {
            isPaused = false
            segmentedProgressBar.isPaused = false
            pageViewController?.view.isUserInteractionEnabled = true
        }
       
       private func startSegmentedProgressBarAnimation() {
           segmentedProgressBar.startAnimation()
       }
       
       private func getController(at index: Int) -> UIViewController {
           return items[index].getController()
       }
       
    private func previousItem() {
            let newIndex = max(currentItemIndex - 1, 0)
            let controller = getController(at: newIndex)
            pageViewController?.setViewControllers([controller], direction: .reverse, animated: true, completion: nil)
            currentItemIndex = newIndex
            segmentedProgressBar.rewind()
        }
       
       private func nextItem() {
           let newIndex = min(currentItemIndex + 1, items.count - 1)
           let controller = getController(at: newIndex)
           pageViewController?.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
           currentItemIndex = newIndex
           segmentedProgressBar.skip()
       }
        
    private func dismissCarouselViewController() {
        //animate the view controller sliding down
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }) { _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }


}

// MARK: UIPageViewControllerDataSource methods
extension CarouselViewController: UIPageViewControllerDataSource {
    
    /// Get previous view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            print("swiped")
            // Check if current item index is first item
            // If yes, return last item controller
            // Else, return previous item controller
            if currentItemIndex == 0 {
                return items.last?.getController()
            }
            return getController(at: currentItemIndex-1)
        }

    /// Get next view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
           print("Not swiped")
            // Check if current item index is last item
            // If yes, return first item controller
            // Else, return next item controller
            if currentItemIndex + 1 == items.count {
                return items.first?.getController()
            }
            return getController(at: currentItemIndex + 1)
        }
}

// MARK: UIPageViewControllerDelegate methods
extension CarouselViewController: UIPageViewControllerDelegate {
    
    /// Page view controller did finish animating
    /// - Parameters:
    /// - pageViewController: UIPageViewController
    /// - finished: Bool
    /// - previousViewControllers: [UIViewController]
    /// - completed: Bool
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = items.firstIndex(where: { $0.getController() == visibleViewController }){
                currentItemIndex = index
            }
        }
}


extension CarouselViewController: SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        guard currentItemIndex != index else { return }
        
        let direction: UIPageViewController.NavigationDirection = index > currentItemIndex ? .forward : .reverse
        currentItemIndex = index
        
        let controller = getController(at: currentItemIndex)
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        
        print("Changed to index: \(index)")
    }

    func segmentedProgressBarFinished() {
        print("Segmented progress bar finished")
        dismissCarouselViewController()    }
    
}

