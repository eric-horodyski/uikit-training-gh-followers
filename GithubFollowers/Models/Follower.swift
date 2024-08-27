//
//  Follower.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/8/24.
//

import Foundation

struct Follower: Codable, Hashable {
	var login: String
	var avatarUrl: String
}
