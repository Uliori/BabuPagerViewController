//
//  ViewController.swift
//  BabuPagerViewController
//
//  Created by BABUKUMA on 5/23/15.
//  Copyright (c) 2015 babukuma. All rights reserved.
//

import UIKit

class ViewController: BabuPagerViewController, BabuPagerViewControllerDataSource {
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
        
        // Header
        let headerLabel = UILabel(frame: CGRectMake(0, 20, CGRectGetWidth(self.headerView!.frame), CGRectGetHeight(self.headerView!.frame)))
        headerLabel.text = "BabuPagerViewController"
        headerLabel.textAlignment = .Center
        headerLabel.textColor = UIColor.blackColor()
        headerLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize() + 4)
        self.headerView?.addSubview(headerLabel)
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
}
