//
//  BabuPagerViewController.swift
//  BabuPagerViewController
//
//  Created by BABUKUMA on 5/23/15.
//  Copyright (c) 2015 babukuma. All rights reserved.
//

import UIKit

// MARK: - BabuPagerViewControllerDataSource
public protocol BabuPagerViewControllerDataSource {
    /// Asks the data source to return the number of items in page view
    func numberOfPagerItem() -> Int
    /// Asks the pager item
    func pagerItemViewController(index: Int) -> UIViewController
    /// Asks the data source for the title of the tab
    func titleForTab(index: Int) -> String
}

// MARK: - BabuPagerViewControllerDelegate
public protocol BabuPagerViewControllerDelegate {
    /// Calls before a gesture-driven transition begins.
    func pagerViewController(pagerViewController: BabuPagerViewController, willTransitionToViewController: AnyObject)
    /// Calls after a gesture-driven transition completes.
    func pagerViewController(pagerViewController: BabuPagerViewController, didFinishAnimating finished: Bool)
}

// MARK: - BabuPagerViewController
@IBDesignable
public class BabuPagerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    /// BabuPagerViewControllerDataSource
    public var dataSource:BabuPagerViewControllerDataSource! {
        didSet {
            // make viewControllers
            self.makeViewControllers()
            // make tabs
            self.makeTabs()
        }
    }
    
    /// BabuPagerViewControllerDelegate
    public var delegate:BabuPagerViewControllerDelegate?
    
    // MARK: - Header view
    /// Header view
    @IBOutlet public var headerView:UIView?
    
    // MARK: - Tab view
    @IBOutlet public var tabView:UIView?
    /// labels of tabs
    public var tabLabels:[UILabel]?
    /// if true, the page items are between the header and the tab
    @IBInspectable public var tabIsBottom:Bool = false
    /// text color of activated tab view
    @IBInspectable public var tabActivatedTextColor: UIColor = UIColor.blackColor()
    /// text color of inactivated tab view
    @IBInspectable public var tabInactivatedTextColor: UIColor = UIColor.darkGrayColor()
    /// font size of tab view
    @IBInspectable public var tabFontSize: CGFloat = UIFont.labelFontSize()
    /// use bold text if activated tab view
    @IBInspectable public var tabUseActivatedBoldText: Bool = true
    // height of tab view
    private var tabHeight:CGFloat = 0
    
    // font of activated tab view
    private var _tabActivatedFont: UIFont!
    // font of inactivated tab view
    private var _tabInactivatedFont: UIFont!
    private var _tabWidth:CGFloat!
    
    // MARK: - UIPageViewController
    /// UIPageViewController
    public var pageViewController:UIPageViewController!
    
    // viewControllers
    var _viewControllers:[UIViewController]?

    // MARK: - view controller lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var headerHeight:CGFloat = 0
        
        // Header
        if let headerView = self.headerView {
            headerHeight = CGRectGetHeight(headerView.frame) + headerView.frame.origin.y
        }
        
        // Tab
        if let tabView = self.tabView {
            self.tabHeight = CGRectGetHeight(tabView.frame)
            
            if self.tabUseActivatedBoldText {
                self._tabActivatedFont = UIFont.boldSystemFontOfSize(self.tabFontSize)
            } else {
                self._tabActivatedFont = UIFont.systemFontOfSize(self.tabFontSize)
            }
            self._tabInactivatedFont = UIFont.systemFontOfSize(self.tabFontSize)
            
            self._tabWidth = self.view.frame.width / 3
        }
        
        // UIPageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        if let tabView = self.tabView {
            if self.tabIsBottom {
                self.pageViewController.view.frame = CGRectMake(0, headerHeight, CGRectGetWidth(self.view.frame), tabView.frame.origin.y - (headerHeight + self.topLayoutGuide.length))
            } else {
                headerHeight = tabView.frame.origin.y + self.tabHeight
                self.pageViewController.view.frame = CGRectMake(0, headerHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - headerHeight + self.topLayoutGuide.length)
            }
        } else {
            self.pageViewController.view.frame = CGRectMake(0, headerHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - headerHeight + self.topLayoutGuide.length)
        }
        
        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - UIPageViewControllerDataSource
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllers = self._viewControllers {
            //let index = find(viewControllers, viewController) //anyArrays.indexOfObject(viewController)
            if let index = find(viewControllers, viewController) {
                if index == 0 {
                    return nil
                } else {
                    return viewControllers[index - 1]
                }
            }
        }
        
        return nil
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllers = self._viewControllers {
            if let index = find(viewControllers, viewController) {
                if index == viewControllers.count - 1 {
                    return nil
                } else {
                    return viewControllers[index + 1]
                }
            }
        }
        
        return nil
    }
    
    // to hide UIPageControl
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // to hide UIPageControl
    public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - UIPageViewControllerDelegate
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if let viewControllers = self._viewControllers {
            if let pageViewControllers = pageViewController.viewControllers as? [UIViewController] {
                if let currentIndex = find(viewControllers, pageViewControllers[0]) {
                    self.animateTabs(currentIndex)
                }
            }
        }
    }
    
    public func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        if let delegate = self.delegate {
            delegate.pagerViewController(self, willTransitionToViewController: pendingViewControllers[0])
        }
    }
    
    // MARK: - BabuPagerViewController initialize
    private func makeViewControllers() {
        let count = self.dataSource.numberOfPagerItem()
        var viewControllers:[UIViewController] = []
        
        for index in 0..<count {
            viewControllers.append(self.dataSource.pagerItemViewController(index))
        }
        
        self._viewControllers = viewControllers
        
        self.pageViewController.setViewControllers(
            [viewControllers[0]],
            direction: .Forward,
            animated: false,
            completion: nil)
    }
    
    private func makeTabs() {
        if let tabView = self.tabView {
            let count = self.dataSource.numberOfPagerItem()
            var tabs:[UILabel] = []
            
            for index in 1...count {
                let x:CGFloat = CGFloat(index) * self._tabWidth
                var frame = CGRectMake(x, 0, self._tabWidth, self.tabHeight)
                let tab = UILabel(frame: frame)
                tab.text = self.dataSource.titleForTab(index - 1)
                if index == 1 {
                    tab.font = self._tabActivatedFont
                    tab.textColor = self.tabActivatedTextColor
                } else {
                    tab.font = self._tabInactivatedFont
                    tab.textColor = self.tabInactivatedTextColor
                }
                tab.textAlignment = .Center
                tab.backgroundColor = UIColor.clearColor()
                tab.tag = index
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                tapRecognizer.numberOfTapsRequired = 1
                tab.addGestureRecognizer(tapRecognizer)
                tab.userInteractionEnabled = true
                
                tabs.append(tab)
                tabView.addSubview(tab)
            }
            
            self.tabLabels = tabs
        }
    }
    
    // MARK: - BabuPagerViewController
    private func animateTabs(currentIndex:Int) {
        if let tabs = self.tabLabels {
            var firstPosition:CGFloat = CGFloat(1 - currentIndex) * self._tabWidth
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                //
                var index:CGFloat = 0
                for tab:UIView in tabs {
                    //println("[\(index)] -> \(firstPosition + (index * self._tabWidth))")
                    tab.frame.origin.x = firstPosition + (index * self._tabWidth)
                    
                    index++
                }
            }, completion: {(finished) in
                var index = 0
                for tab:UILabel in tabs {
                    if index == currentIndex {
                        tab.font = self._tabActivatedFont
                        tab.textColor = self.tabActivatedTextColor
                    } else {
                        tab.font = self._tabInactivatedFont
                        tab.textColor = self.tabInactivatedTextColor
                    }
                    
                    index++
                }
                
                if let delegate = self.delegate {
                    delegate.pagerViewController(self, didFinishAnimating: finished)
                }
            })
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if let viewControllers = self._viewControllers, tappedView = sender.view {
            let tappedIndex = tappedView.tag - 1
            
            if let pageViewControllers = pageViewController.viewControllers as? [UIViewController] {
                if let index = find(viewControllers, pageViewControllers[0]) {
                    if index > tappedIndex {
                        if let delegate = self.delegate {
                            delegate.pagerViewController(self, willTransitionToViewController: viewControllers[tappedIndex])
                        }
                        
                        self.pageViewController.setViewControllers(
                            [viewControllers[tappedIndex]],
                            direction: .Reverse,
                            animated: true,
                            completion: { (finished) in
                                self.animateTabs(tappedIndex)
                        })
                    } else if index < tappedIndex {
                        if let delegate = self.delegate {
                            delegate.pagerViewController(self, willTransitionToViewController: viewControllers[tappedIndex])
                        }
                        
                        self.pageViewController.setViewControllers(
                            [viewControllers[tappedIndex]],
                            direction: .Forward,
                            animated: true,
                            completion: { (finished) in
                                self.animateTabs(tappedIndex)
                        })
                    }
                }
            }
        }
    }
    
    /// return index of current page
    public func currentIndex() -> Int {
        if let viewControllers = self._viewControllers, pageViewControllers = pageViewController.viewControllers as? [UIViewController] {
            if let index = find(viewControllers, pageViewControllers[0]) {
                return index
            }
        }
        
        return -1
    }
}

