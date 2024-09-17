//
//  UIView+Extensions.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 9/16/24.
//

import UIKit

extension UIView {
	
	func addSubviews(_ views: UIView...) {
		for view in views { addSubview(view) }
	}
}
