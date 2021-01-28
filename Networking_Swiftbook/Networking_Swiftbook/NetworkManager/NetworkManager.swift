//
//  NetworkManager.swift
//  Networking_Swiftbook
//
//  Created by Eugene St on 20.01.2021.
//

import Foundation
import UIKit

class NetworkManager {
    
    static func fetchData(completion: @escaping ([Course]) -> Void ) {
        
        let baseURL = "https://swiftbook.ru//wp-content/uploads/api/"

        let coursesPath = baseURL + "api_courses"
        
        guard let url = URL(string: coursesPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let courses = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    completion(courses)
                }
            } catch let error {
                print("Error serialization -", error.localizedDescription)
            }
            
        }.resume()
    }
    
    static func getRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error! while working with the task. \(error.localizedDescription)")
            }
            
            guard let response = response, let data = data else { return }
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    static func postRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            print("Invalid URL")
            return
        }
        
        let userData = ["Course": "Networking", "Lesson": "GET and POST Requests"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, let response = response else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }
            
            
        }.resume()
    }
    
    static func downloadImage(completion: @escaping (UIImage) -> Void) {
        let path = "https://i.imgur.com/R04FIan.png"
        guard let url = URL(string: path) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    static func uploadImage() {
        
        let image = UIImage(named: "Dataart")!
        let httpHeaders = ["Authorization": "Client-ID 1bd22b9ce396a4c"]
        guard let properties = ImageProperties(image: image, forKey: "image") else { return }
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = properties.data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response else { return }
            print(response)
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
