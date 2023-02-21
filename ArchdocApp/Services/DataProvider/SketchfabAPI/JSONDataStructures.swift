//
//  SketchfabAPIDataStructures.swift
//  ArchdocApp
//
//  Created by tixomark on 1/31/23.
//

import Foundation

// MARK: - Access Token Data Type
// SketchfabAPI response to https://sketchfab.com/oauth2/token/
struct AccessToken: Codable {
    let accessToken: String?
    let expiresIn: Int?
    let tokenType, scope, refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
        case refreshToken = "refresh_token"
    }
}

//MARK: - Model Download Links Type
// SketchfabAPI response to https://api.sketchfab.com/v3/models/{uid}/download
struct DownloadURL: Codable {
    let url: String
    let size, expires: Int
}
typealias FileDownloadURLs = [String: DownloadURL]

// MARK: - User's List of Models Type
// SketchfabAPI response to https://api.sketchfab.com/v3/me/models
struct MyModels: Codable {
    let models: [Model]?
    
    enum CodingKeys: String, CodingKey {
        case models = "results"
    }
}

struct Model: Codable {
    let uid: String?
    let tags: [Tag]?
    let viewerURL: String?
    let isProtected: Bool?
    let categories: [Category]?
    let publishedAt: String?
    let likeCount, commentCount, viewCount, vertexCount: Int?
    let user: SFUser?
    let isDownloadable: Bool?
    let animationCount: Int?
    let name: String?
    let soundCount: Int?
    let isAgeRestricted: Bool?
    let uri: String?
    let faceCount: Int?
    let createdAt: String?
    let thumbnails: Thumbnails?
    let embedURL: String?
    let archives: [String: Archive]?

    enum CodingKeys: String, CodingKey {
        case uid, tags
        case viewerURL = "viewerUrl"
        case isProtected, categories, publishedAt, likeCount, commentCount, viewCount, vertexCount, user, isDownloadable, animationCount, name, soundCount, isAgeRestricted, uri, faceCount, createdAt, thumbnails
        case embedURL = "embedUrl"
        case archives
    }
}

struct Archive: Codable {
    let faceCount, textureCount, size, vertexCount: Int?
    let textureMaxResolution: Int?
}

struct Category: Codable {
    let uri, uid, name, slug: String?
}

struct Tag: Codable {
    let slug, uri: String?
}

struct Thumbnails: Codable {
    let images: [Image]?
}

struct Image: Codable {
    let url: String?
    let width: Int?
    let uid: String?
    let height, size: Int?
}

struct SFUser: Codable {
    let username, profileURL, account, displayName: String?
    let uid, uri: String?
    let avatar: Avatar?

    enum CodingKeys: String, CodingKey {
        case username
        case profileURL = "profileUrl"
        case account, displayName, uid, uri, avatar
    }
}

struct Avatar: Codable {
    let images: [Image]?
    let uid, uri: String?
}



