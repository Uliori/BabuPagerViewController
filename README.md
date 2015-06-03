# BabuPagerViewController

A horizontal scroll UIPageViewController with tabs.

## Screenshots

![Screenshots_1](https://raw.githubusercontent.com/babukuma/BabuPagerViewController/master/Screenshots/screenshots_1.gif)
![Screenshots_2](https://raw.githubusercontent.com/babukuma/BabuPagerViewController/master/Screenshots/screenshots_2.gif)

## Requirements

Supports iOS 8 and Swift

## Installation

#### 1. You can use CocoaPods
```
pod 'BabuPagerViewController'
```

#### 2. Or you can just copy 'BabuPagerViewController.swift' to your project.

## How to use

#### 1. Make the Subclass of BabuPagerViewController
```swift
class ViewController: BabuPagerViewController, BabuPagerViewControllerDataSource, BabuPagerViewControllerDelegate {
  var titles = ["red", "blue", "green", "yellow", "cyan"]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.dataSource = self
    self.delegate = self

  }

  ...

  // MARK: - BabuPagerViewControllerDataSource
  func numberOfPagerItem() -> Int {
    return self.titles.count
  }

  func titleForTab(index: Int) -> String {
    return self.titles[index]
  }

  func pagerItemViewController(index: Int) -> UIViewController {
    var viewController = self.storyboard!.instantiateViewControllerWithIdentifier("pageItem") as! UIViewController
    viewController.title = self.titles[index]
    return viewController
  }

  // MARK: - BabuPagerViewControllerDelegate
  func pagerViewController(pagerViewController: BabuPagerViewController, willTransitionToViewController: AnyObject) {
    ...
  }

  func pagerViewController(pagerViewController: BabuPagerViewController, didFinishAnimating finished: Bool) {
    // You can get the current index.
    let pageIndex = pagerViewController.currentIndex()
    ...
  }
}
```

#### 2. Connect to headerView on the Storyboard if you need to
![headerView](https://raw.githubusercontent.com/babukuma/BabuPagerViewController/master/Screenshots/headerView.png)

#### 3. Connect to tabView on the Storyboard if you need to
![tabView](https://raw.githubusercontent.com/babukuma/BabuPagerViewController/master/Screenshots/tabView.png)

#### 4. You can select the position of tabView between top and bottom.
![tabViewBottom](https://raw.githubusercontent.com/babukuma/BabuPagerViewController/master/Screenshots/tabViewBottom.png)


## class BabuPagerViewController

### 1. the inspectable values for Storyboard.

![IBInspectable](https://raw.githubusercontent.com/babukuma/BabuPagerViewController/master/Screenshots/IBInspectable.png)
* tabIsBottom : if true, the page items are between header and tab
* tabActivatedTextColor : text color of activated tab view
* tabInactivatedTextColor : text color of inactivated tab view
* tabFontSize : font size of tab view
* tabUseActivatedBoldText : use bold text if activated tab view

### 2. Method
#### func currentIndex() -> Int
return index of current page

## protocol BabuPagerViewControllerDataSource
#### 1. func numberOfPagerItem() -> Int
Asks the data source to return the number of items in page view
```swift
func numberOfPagerItem() -> Int {
    return self.titles.count
}
```

#### 2. func pagerItemViewController(index: Int) -> UIViewController
Asks the pager item
```swift
func pagerItemViewController(index: Int) -> UIViewController {
  var viewController = self.storyboard!.instantiateViewControllerWithIdentifier("pageItem") as! UIViewController
  viewController.title = self.titles[index]
  return viewController
}
```

#### 3. func titleForTab(index: Int) -> String
Asks the data source for the title of the tab
```swift
func titleForTab(index: Int) -> String {
  return self.titles[index]
}
```

## protocol BabuPagerViewControllerDelegate
#### 1. func pagerViewController(pagerViewController: BabuPagerViewController, willTransitionToViewController: AnyObject)
Calls before a gesture-driven transition begins.
```swift
func pagerViewController(pagerViewController: BabuPagerViewController, willTransitionToViewController: AnyObject) {
    println("called willTransitionToViewController")
}
```

#### 2. func pagerViewController(pagerViewController: BabuPagerViewController, didFinishAnimating finished: Bool)
Calls after a gesture-driven transition completes.
```swift
func pagerViewController(pagerViewController: BabuPagerViewController, didFinishAnimating finished: Bool) {
    println("called didFinishAnimating")
    let pageIndex = pagerViewController.currentIndex()
    ...
}
```
