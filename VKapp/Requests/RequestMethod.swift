//
//  RequestMethod.swift
//  VKapp
//
//  Created by Didar on 9/1/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import Foundation

class RequestMethods {
    
    let baseURL = "https://api.vk.com"
    let apiVersion = "5.73"
    
    let getFriends = "/method/friends.get"
    let getRequests = "/method/friends.getRequests"
    let getPhotos = "/method/photos.get"
    let groupSearch = "/method/groups.search"
    let groupsInfo = "/method/groups.getById"
    let newsGet = "/method/newsfeed.get"
    
    let messagesGet = "/method/messages.get"
    let dialogsGet = "/method/messages.getDialogs"
    let historyOfMessagesGet = "/method/messages.getHistory"
    let getUsers = "/method/users.get"
    let sendMessage = "/method/messages.send"
    
    let goPost = "/method/wall.post"
    
    let registrationForPushes = "/method/account.registerDevice"
    let getPushSettings = "/method/account.getPushSettings"
    
    let photoPlaceHolder = "https://vk.com/images/camera_100.png"
    
}
