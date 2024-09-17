//
//  SearchViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 7/31/24.
//

import UIKit

class SearchViewController: UIViewController {

	let logoImageView = UIImageView()
	let usernameTextField = GFTextField()
	let callToActionButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
	
	var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		configureLogoImageView()
		configureUsernameTextField()
		configureCallToActionButton()
		createDismissKeyboardTapGesture()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
		usernameTextField.text = ""
	}
	
	@objc func pushFollowerList() {
		guard isUsernameEntered else {
			DispatchQueue.main.async {
				self.presentGFAlert(title: "Empty Username", message: "Please enter a username. We need to know who to look for. 😀", buttonTitle: "OK")
			}
			return
		}
		
		usernameTextField.resignFirstResponder()
		
		let followerListViewController = FollowerListViewController(username: usernameTextField.text!)
		navigationController?.pushViewController(followerListViewController, animated: true)
	}
	
	private func createDismissKeyboardTapGesture() {
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tap)
	}
	
	private func configureLogoImageView() {
		view.addSubview(logoImageView)
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		logoImageView.image = UIImage(resource: .ghLogo)

		let topConstraint: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
		NSLayoutConstraint.activate([
			logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraint),
			logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			logoImageView.heightAnchor.constraint(equalToConstant: 200),
			logoImageView.widthAnchor.constraint(equalToConstant: 200)
		])
	}
	
	private func configureUsernameTextField() {
		view.addSubview(usernameTextField)
		usernameTextField.delegate = self
		
		NSLayoutConstraint.activate([
			usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
			usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			usernameTextField.heightAnchor.constraint(equalToConstant: 50)
		])
	}
	
	private func configureCallToActionButton() {
		view.addSubview(callToActionButton)
		callToActionButton.addTarget(self, action: #selector(pushFollowerList), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
			callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			callToActionButton.heightAnchor.constraint(equalToConstant: 50)
		])
	}
	
}


extension SearchViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		pushFollowerList()
		return true
	}
}

#Preview {
	SearchViewController()
}
