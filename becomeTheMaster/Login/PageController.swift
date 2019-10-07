//
//  PageViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 22/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class PageController: UIViewController {
    @IBOutlet var pageStackView: UIStackView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var progressBar: UIProgressView!
    var cnt:Float = 0
    var idx:Float = 1
    
    var pageViewController: PageViewController? {
        didSet {
            pageViewController?.pageDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self, action: Selector(("didChangePageControlValue")), for: .valueChanged)
        progressBar.setProgress(idx/cnt, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? PageViewController {
            self.pageViewController = pageViewController
        }
    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        pageViewController?.scrollToNextViewController()
        idx += 1
        if idx >= cnt { idx = cnt }
        progressBar.setProgress(idx/cnt, animated: true)
        if nextButton.title(for: .normal) == "Finish" {
            
            DispatchQueue.main.async {
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTabBackButton(_ sender: UIButton) {
        if pageControl.currentPage == 0 {
            self.dismiss(animated: true, completion: nil)
        }
        pageViewController?.scrollToBackViewController()
        idx -= 1
        if idx <= 0 { idx = 1 }
        progressBar.setProgress(idx/cnt, animated: true)
        
    }
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        pageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
        
    
}


extension PageController: PageViewControllerDelegate {
    
    @objc(pageViewControllerWithPageViewController:didUpdatePageIndex:) func pageViewController(pageViewController: PageViewController,
                                                                                                didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        // Page Controller is Last Page => Go to Sign Up
        if pageControl.currentPage == 4 {
//            pageStackView.isHidden = true
            nextButton.setTitle("Finish", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
            
        }
    }
    
    @objc(pageViewControllerWithPageViewController:didUpdatePageCount:) func pageViewController(pageViewController PageViewController: PageViewController,
                                                                                                didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        cnt = Float(count)
    }
    
}
