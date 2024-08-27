//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/5/24.
//

import UIKit

class FollowerListViewController: UIViewController {
	
	var username: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		
		NetworkManager.shared.getFollowers(for: username, page: 1) { result in
			switch result {
			case .success(let followers):
				print(followers)
			case .failure(let error):
				self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
}
