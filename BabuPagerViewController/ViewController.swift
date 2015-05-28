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
    
    var titles = ["page1", "page2", "page3", "page4", "page5"]
    var bgColors = [
        UIColor.yellowColor(),
        UIColor.redColor(),
        UIColor.brownColor(),
        UIColor.greenColor(),
        UIColor.cyanColor()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
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
        var viewController = self.storyboard!.instantiateViewControllerWithIdentifier("pageItem") as! UIViewController
        viewController.view.backgroundColor = self.bgColors[index]
        return viewController
    }
    
    // MARK: - BabuPagerViewControllerDelegate
    func pagerViewController(pagerViewController: BabuPagerViewController, willTransitionToViewController: AnyObject) {
        println("willTransitionToViewController")
    }
    
    func pagerViewController(pagerViewController: BabuPagerViewController, didFinishAnimating finished: Bool) {
        println("didFinishAnimating")
    }
}
