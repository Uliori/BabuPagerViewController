//
//  ViewController.swift
//  BabuPagerViewController
//
//  Created by BABUKUMA on 5/23/15.
//  Copyright (c) 2015 babukuma. All rights reserved.
//

import UIKit

class ViewController: BabuPagerViewController, BabuPagerViewControllerDataSource, BabuPagerViewControllerDelegate {
    //var viewControllers:[AnyObject]!
    
    var titles = ["red", "blue", "green", "yellow", "cyan"]
    var headerBgColors = [
        UIColor.redColor(),
        UIColor.blueColor(),
        UIColor.greenColor(),
        UIColor.yellowColor(),
        UIColor.cyanColor()
    ]
    var tabBgColor = [
        UIColor(red: 193/255, green: 0/255, blue: 2/255, alpha: 1.0),
        UIColor(red: 85/255, green: 81/255, blue: 255/255, alpha: 1.0),
        UIColor(red: 0/255, green: 199/255, blue: 0/255, alpha: 1.0),
        UIColor(red: 222/255, green: 222/255, blue: 0/255, alpha: 1.0),
        UIColor(red: 0/255, green: 211/255, blue: 211/255, alpha: 1.0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        self.headerView?.backgroundColor = self.headerBgColors[0]
        self.tabView?.backgroundColor = self.tabBgColor[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - BabuPagerViewControllerDataSource
    func numberOfPagerItem() -> Int {
        return self.titles.count
    }
    
    func titleForTab(index: Int) -> String {
        return self.titles[index]
    }
    
    func pagerItemViewController(index: Int) -> UIViewController {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("pageItem") 
        print("viewController=\(viewController)")
        viewController.title = "Page \(index + 1)"
        return viewController
    }
    
    // MARK: - BabuPagerViewControllerDelegate
    func pagerViewController(pagerViewController: BabuPagerViewController, willTransitionToViewController: AnyObject) {
        print("willTransitionToViewController")
    }
    
    func pagerViewController(pagerViewController: BabuPagerViewController, didFinishAnimating finished: Bool) {
        print("didFinishAnimating")
        let pageIndex = pagerViewController.currentIndex()
        self.headerView?.backgroundColor = self.headerBgColors[pageIndex]
        self.tabView?.backgroundColor = self.tabBgColor[pageIndex]
    }
}
