//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Алексей Тиньков on 03.09.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = onboardingPagesTitle.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        pageControl.pageIndicatorTintColor = .ypGray
        return pageControl
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.textColor = .ypWhite.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        //button.tintColor = .ypWhite.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        button.backgroundColor = .ypBlack.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStartButton()
        setupPageControl()
    }
    
    @objc private func startButtonTapped() {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true)
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        dataSource = self
        delegate = self
        let onboardingPagesViewController = OnboardingPagesViewController(with: 0)
        setViewControllers([onboardingPagesViewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupStartButton() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let onboardingPagesViewController = viewController as? OnboardingPagesViewController  else { return nil }
        var pageIndex = onboardingPagesViewController.pageIndex
        if pageIndex == 0 { return nil }
        pageIndex -= 1
        let newOnboardingPagesViewController = OnboardingPagesViewController(with: pageIndex)
        return newOnboardingPagesViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let onboardingPagesViewController = viewController as? OnboardingPagesViewController  else { return nil }
        var pageIndex = onboardingPagesViewController.pageIndex
        if pageIndex >= onboardingPagesTitle.count - 1 { return nil }
        pageIndex += 1
        let newOnboardingPagesViewController = OnboardingPagesViewController(with: pageIndex)
        return newOnboardingPagesViewController
    }
    
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let onboardingPagesViewController = pageViewController.viewControllers?.first as? OnboardingPagesViewController {
            pageControl.currentPage = onboardingPagesViewController.pageIndex
        }
    }
}
