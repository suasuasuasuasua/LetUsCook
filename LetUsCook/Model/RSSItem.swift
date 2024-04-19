//
//  RSSItem.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/19/24.
//

import Foundation

struct RSSItem {
    // <title>
    let title: String
    
    // <link>
    let link: URL
    
    // <pubDate>
    let date: Date
    
    // <category> many categories here
    let category: Category
    
    // <description>
    let description: String
    
    //           v qualified name
    // <content:encoded>
    // ^ element name
    let content: String
}
