//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 03.09.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = [OnboardingPagesViewController(title: "Отслеживайте только\nто, что хотите", imageName: "onboarding_0"),
                                          OnboardingPagesViewController(title: "Даже если это\nне литры воды и йога", imageName: "onboarding_1")
    ]
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        pageControl.pageIndicatorTintColor = .ypGray
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageControl()
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        dataSource = self
        delegate = self
        let onboardingPagesViewController = pages[0]
        setViewControllers([onboardingPagesViewController], direction: .forward, animated: true, completion: nil)
    }
    
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var pageIndex = pages.firstIndex(of: viewController) else { return nil }
        if pageIndex == 0 { return nil }
        pageIndex -= 1
        return pages[pageIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var pageIndex = pages.firstIndex(of: viewController) else { return nil }
        if pageIndex >= pages.count - 1 { return nil }
        pageIndex += 1
        return pages[pageIndex]
    }
    
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = pageViewController.viewControllers?.first,
           let pageIndex = pages.firstIndex(of: viewController) {
            pageControl.currentPage = pageIndex
        }
    }
}
