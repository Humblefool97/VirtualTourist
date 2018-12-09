//
//  NetworkUtility+Constants.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 02/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation

extension NetworkUtility{
    struct Constants {
        
        // MARK: Flickr
        struct Flickr {
            static let apiScheme = "https"
            static let apiHost = "api.flickr.com"
            static let apiPath = "/services"
            static let apiPathExtension = "/rest"
        }
        
        // MARK: Flickr Parameter Keys
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let Extras = "extras"
            static let Format = "format"
            static let SafeSearch = "safe_search"
            static let NoJSONCallback = "nojsoncallback"
            static let latitiude = "lat"
            static let longitude = "lon"
            static let radius = "radius"
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let photoSearchMethod = "flickr.photos.search"
            static let APIKey = "40c8a64bc3d1c644194b32596d7b790c"
            static let MediumURL = "url_m"
            static let ResponseFormat = "json"
            static let SafeSearch = "1" /* 1 means "yes" */
            static let NoJsonCallback = "1"
            static let radius = "10"
        }
        
        // MARK: Flickr Response Keys
        struct FlickrResponseKeys {
            static let Status = "stat"
            static let Photos = "photos"
            static let Photo = "photo"
            static let Title = "title"
            static let MediumURL = "url_m"
        }
        
        // MARK: Flickr Response Values
        struct FlickrResponseValues {
            static let OKStatus = "ok"
        }
    }
}
