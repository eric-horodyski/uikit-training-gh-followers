//
//  UserInfoViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/21/24.
//

import UIKit

class UserDetailViewController: UIViewController {
	var username: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
		navigationItem.rightBarButtonItem = doneButton
	}
	
	@objc func dismissVC() {
		dismiss(animated: true)
	}
}
