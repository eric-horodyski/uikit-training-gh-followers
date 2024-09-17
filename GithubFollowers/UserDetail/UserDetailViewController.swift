//
//  UserInfoViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/21/24.
//

import UIKit

protocol UserDetailViewControllerDelegate: AnyObject {
	func didRequestFollowers(for username: String)
}

class UserDetailViewController: GFDataLoadingViewController {
	let headerView = UIView()
	let itemViewOne = UIView()
	let itemViewTwo = UIView()
	let dateLabel = GFBodyLabel(textAlignment: .center)
	
	var childViews: [UIView] = []
	var username: String!
	weak var delegate: UserDetailViewControllerDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureViewController()
		layoutUI()
		getUserDetail()
	}
	
	private func configureViewController() {
		view.backgroundColor = .systemBackground
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
		navigationItem.rightBarButtonItem = doneButton
	}
	
	private func getUserDetail() {
		Task {
			do {
				let user = try await NetworkManager.shared.getUserDetail(for: username)
				configureUIElements(with: user)
			} catch {
				if let error = error as? GFError {
					presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
				} else {
					presentDefaultError()
				}
			}
		}
	}
	
	private func addChildView(childView: UIViewController, to containerView: UIView) {
		addChild(childView)
		containerView.addSubview(childView.view)
		childView.view.frame = containerView.bounds
		childView.didMove(toParent: self)
	}
	
	@objc private func dismissViewController() {
		dismiss(animated: true)
	}
	
	private func configureUIElements(with user: User) {
		self.addChildView(childView: UserDetailHeaderViewController(user: user), to: self.headerView)
		self.addChildView(childView: RepoDetailViewController(user: user, delegate: self), to: self.itemViewOne)
		self.addChildView(childView: FollowerDetailViewController(user: user, delegate: self), to: self.itemViewTwo)
		self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
	}
	
	private func layoutUI() {
		let padding: CGFloat = 20
		let itemHeight: CGFloat = 140
		
		childViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
		
		for childView in childViews {
			view.addSubview(childView)
			childView.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
				childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
			])
		}
		
		NSLayoutConstraint.activate([
			headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			headerView.heightAnchor.constraint(equalToConstant: 180),
			itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
			itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
			itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
			itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
			dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
			dateLabel.heightAnchor.constraint(equalToConstant: 18)
		])
	}
}

extension UserDetailViewController: RepoDetailViewControllerDelegate {
	func didTapGithubProfile(for user: User) {
		guard let url = URL(string: user.htmlUrl) else {
			DispatchQueue.main.async {
				self.presentGFAlert(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "OK")
			}
			return
		}
		
		presentSafariViewController(with: url)
	}
}

extension UserDetailViewController: FollowerDetailViewControllerDelegate {
	func didTapGetFollowers(for user: User) {
		guard user.followers != 0 else {
			DispatchQueue.main.async {
				self.presentGFAlert(title: "No Followers", message: "This user has no followers.", buttonTitle: "OK")
			}
			return
		}
		
		delegate.didRequestFollowers(for: user.login)
		dismissViewController()
	}
}
