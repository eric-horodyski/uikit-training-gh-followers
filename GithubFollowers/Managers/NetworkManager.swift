//
//  NetworkManager.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/15/24.
//

import UIKit

class NetworkManager {
	static let shared = NetworkManager()
	private let baseURL = "https://api.github.com/users/"
	let cache = NSCache<NSString, UIImage>()
	let decoder = JSONDecoder()
	
	private init() {
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601
	}
	
	func getFollowers(for username: String, page: Int) async throws -> [Follower] {
		let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
		
		guard let url = URL(string: endpoint) else {
			throw GFError.invalidUsername
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw GFError.invalidResponse
		}
		
		do {
			return try decoder.decode([Follower].self, from: data)
		} catch {
			throw GFError.invalidData
		}
	}
	
	func getUserDetail(for username: String) async throws -> User {
		let endpoint = baseURL + "\(username)"
		
		guard let url = URL(string: endpoint) else {
			throw GFError.invalidUsername
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw GFError.invalidResponse
		}
		
		do {
			return try decoder.decode(User.self, from: data)
		} catch {
			throw GFError.invalidData
		}
	}
	
	func downloadImage(from url: String) async -> UIImage? {
		let key = NSString(string: url)

		if let image = cache.object(forKey: key) { return image }
		guard let url = URL(string: url) else { return nil }
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			guard let image = UIImage(data: data) else { return nil }
			self.cache.setObject(image, forKey: key)
			return image
		} catch {
			return nil
		}
	}
	
}
