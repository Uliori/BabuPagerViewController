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
    /// Ask the pager item
    func pagerItemViewController(index: Int) -> UIViewController
    /// Ask the data source for the title of the tab
    func titleForTab(index: Int) -> String
}

// MARK: - BabuPagerViewController
@IBDesignable
public class BabuPagerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // BabuPagerViewControllerDataSource
    public var dataSource:BabuPagerViewControllerDataSource! {
        didSet {
            // make viewControllers
            self.makeViewControllers()
            // make tabs
            self.makeTabs()
        }
    }
    
    // MARK: - Header view
    /// Header view
    public var headerView:UIView?
    /// height of header view
    @IBInspectable public var headerHeight: CGFloat = 70.0
    /// background color of header view
    @IBInspectable public var headerBackground: UIColor = UIColor.lightGrayColor()
    
    // MARK: - Tab view
    /// height of tab view
    @IBInspectable public var tabHeight: CGFloat = 44.0
    /// background color of tab view
    @IBInspectable public var tabBackground: UIColor = UIColor.lightGrayColor()
    /// text color of actived tab view
    @IBInspectable public var tabActivedTextColor: UIColor = UIColor.blackColor()
    /// text color of inactived tab view
    @IBInspectable public var tabInactivedTextColor: UIColor = UIColor.darkGrayColor()
    /// font size of tab view
    @IBInspectable public var tabFontSize: CGFloat = UIFont.labelFontSize()
    /// use bold text if actived tab view
    @IBInspectable public var tabUseActivedBoldText: Bool = true
    
    // font of actived tab view
    private var _tabActivedFont: UIFont!
    // font of inactived tab view
    private var _tabInactivedFont: UIFont!
    private var _tabWidth:CGFloat!
    private var _tabView:UIView?
    private var _tabs:[UILabel]?
    
    // MARK: - UIPageViewController
    /// UIPageViewController
    public var pageViewController:UIPageViewController!
    
    // viewControllers
    var _viewControllers:[UIViewController]?

    // MARK: - view controller lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Header
        if self.headerHeight > 0 {
            self.headerView = UIView(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), self.headerHeight))
            self.headerView?.backgroundColor = self.headerBackground
            self.view.addSubview(self.headerView!)
        }
        
        // Tab
        self._tabWidth = self.view.frame.width / 3
        if self.tabHeight > 0 {
            if self.tabUseActivedBoldText {
                self._tabActivedFont = UIFont.boldSystemFontOfSize(self.tabFontSize)
            } else {
                self._tabActivedFont = UIFont.systemFontOfSize(self.tabFontSize)
            }
            self._tabInactivedFont = UIFont.systemFontOfSize(self.tabFontSize)
            
            self._tabView = UIView(frame: CGRectMake(0.0, self.headerHeight, CGRectGetWidth(self.view.frame), self.tabHeight))
            self._tabView?.backgroundColor = self.tabBackground
            self.view.addSubview(self._tabView!)
        }
        
        // UIPageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.pageViewController.view.frame = CGRectMake(0, (self.headerHeight + self.tabHeight), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - (self.headerHeight + self.tabHeight) + self.topLayoutGuide.length)
        //self.pageViewController.view.backgroundColor = UIColor.lightGrayColor()
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
    
    // for hiding UIPageControl
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // for hiding UIPageControl
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
        let count = self.dataSource.numberOfPagerItem()
        var tabs:[UILabel] = []
        
        for index in 1...count {
            let x:CGFloat = CGFloat(index) * self._tabWidth
            var frame = CGRectMake(x, 0, self._tabWidth, self.tabHeight)
            let tab = UILabel(frame: frame)
            tab.text = self.dataSource.titleForTab(index - 1)
            if index == 1 {
                tab.font = self._tabActivedFont
                tab.textColor = self.tabActivedTextColor
            } else {
                tab.font = self._tabInactivedFont
                tab.textColor = self.tabInactivedTextColor
            }
            tab.textAlignment = .Center
            tab.backgroundColor = UIColor.clearColor()
            tab.tag = index
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            tapRecognizer.numberOfTapsRequired = 1
            tab.addGestureRecognizer(tapRecognizer)
            tab.userInteractionEnabled = true
            
            tabs.append(tab)
            self._tabView?.addSubview(tab)
        }
        
        self._tabs = tabs
    }
    
    // MARK: - BabuPagerViewController
    private func animateTabs(currentIndex:Int) {
        if let tabs = self._tabs {
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
                        tab.font = self._tabActivedFont
                        tab.textColor = self.tabActivedTextColor
                    } else {
                        tab.font = self._tabInactivedFont
                        tab.textColor = self.tabInactivedTextColor
                    }
                    
                    index++
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
                        self.pageViewController.setViewControllers(
                            [viewControllers[tappedIndex]],
                            direction: .Reverse,
                            animated: true,
                            completion: { (finished) in
                                self.animateTabs(tappedIndex)
                        })
                    } else if index < tappedIndex {
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
}

