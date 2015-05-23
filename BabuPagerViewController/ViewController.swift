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
    
    var titles = ["page1", "page2", "page3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        var viewContollers:[UIViewController] = []
        if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("page1") as? UIViewController {
            viewContollers.append(vc)
        }
        if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("page2") as? UIViewController {
            viewContollers.append(vc)
        }
        if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("page3") as? UIViewController {
            viewContollers.append(vc)
        }
        
        self.viewControllers = viewContollers
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
    func numberOfTabs() -> Int {
        return self.titles.count
    }
    
    func titleForTab(index: Int) -> String {
        return self.titles[index]
    }
}
