//
//  CommentParser.swift
//  Dai-Hentai
//
//  Created by DDavid on 12/7/20.
//  Copyright © 2020 DaidoujiChen. All rights reserved.
//

import Foundation

class CommentParser {
    var domain: String {
        ExCookie.isExist() ? "https://exhentai.org" : "https://e-hentai.org"
    }
    
    func getCommentList(hentaiInfo: HentaiInfo, completion: @escaping ([HentaiComment]) -> Void) {
        requestCommentWithHentaiInfo(hentaiInfo: hentaiInfo) { (data, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            
        }
    }
    
    func requestCommentWithHentaiInfo(hentaiInfo: HentaiInfo, completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "\(domain)/g/\(hentaiInfo.gid ?? "")/\(hentaiInfo.token ?? "")"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, error)
        }
    }
    
    func parseCommentHtml(data: Data) {
        
    }
}
