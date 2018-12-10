//
//  NetworkUtility.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 02/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation

class NetworkUtility {
    
    static func getFlickerPhotos(latitude:Double,
                                 longitude:Double,
                                 pageNum:Int,
                                 completionHandler : @escaping(_ success:Bool ,_ photos:Photos?,_ errorMessage:String?) -> Void){
        var page:Int{
            if(pageNum != 0){
                let page = min(pageNum, 2500/Constants.FlickrParameterValues.photosPerPage)
                return Int(arc4random_uniform(UInt32(page)) + 1)
            }else{
                return 1
            }
        }
        
        let methodParameters = [Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.photoSearchMethod,
                                Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
                                Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
                                Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.SafeSearch,
                                Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
                                Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.NoJsonCallback,
                                Constants.FlickrParameterKeys.latitiude:"\(latitude)",
            Constants.FlickrParameterKeys.longitude:"\(longitude)",
            Constants.FlickrParameterKeys.radius:Constants.FlickrParameterValues.radius,
            Constants.FlickrParameterKeys.PhotosPerPage:"\(Constants.FlickrParameterValues.photosPerPage)",
            Constants.FlickrParameterKeys.Page:"\(page)"]
        
        let url = getUrlFromParameters(methodParameters as [String : AnyObject])
        let session = URLSession.shared
        let request = URLRequest(url: url)
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    completionHandler(false,nil,"Something went wrong!! Please try again after sometime")
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' and '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            var urlList:[String] = []
            for photoObj in photoArray {
                if  let url = photoObj[Constants.FlickrResponseKeys.MediumURL] as? String{
                    urlList.append(url)
                    print(url)
                }
            }
            let photosObj = Photos(urlList: urlList, pages: photosDictionary[Constants.FlickrResponseKeys.Pages] as! Int)
            completionHandler(true,photosObj,nil)
        }
        // start the task!
        task.resume()
        
    }
    
    private static func getUrlFromParameters (_ parameters: [String:AnyObject]) -> URL{
        var components = URLComponents()
        let withPathExtension = Constants.Flickr.apiPathExtension
        components.scheme = Constants.Flickr.apiScheme
        components.host =  Constants.Flickr.apiHost
        components.path = Constants.Flickr.apiPath + (withPathExtension )
        
        components.queryItems = [URLQueryItem]()
        for (key , value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
}
