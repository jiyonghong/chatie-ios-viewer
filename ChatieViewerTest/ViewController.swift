//
//  ViewController.swift
//  ChatieViewerTest
//
//  Created by redice on 04/12/2018.
//  Copyright © 2018 Jiyong Hong. All rights reserved.
//

import UIKit
import WebKit
import Lightbox
import SwiftyJSON


class ViewController: UIViewController {
    var webView: WKWebView!
    
    var userStatus: UserStatus!
    var lastRead: [Int]!
    var episodeDetail: EpisodeDetail?
    
    var tapCount: Int = 0
    var remainTap: Int!
    
    var isFinished: Bool = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userStatus = UserStatus(data: JSON([
            "isSubscribed": false,
            "lastSceneIndex": 1,
            "lastChatIndex": 3,
            "remainTap": 4,
            ]))
        
        self.lastRead = [
            self.userStatus.lastSceneIndex,
            self.userStatus.lastChatIndex
        ]
        
        self.remainTap = self.userStatus.remainTap
        
        self.getEpisodeDetail() {
            self.loadWebView()
        }
        
        LightboxConfig.PageIndicator.enabled = false
        LightboxConfig.CloseButton.text = "닫기"
        LightboxConfig.hideStatusBar = false
    }
    
    func getEpisodeDetail(completion: () -> ()) {
        self.episodeDetail = EpisodeDetail(json: JSON([
            "id": 1,
            "title": "Test Episode 1",
            "storyTitle": "Test Story 1",
            "episodeCount": 9,
            "order": 2,
            "url": "https://efinder-staging.s3.amazonaws.com/chatie/chatie_episode_files/5c45abd8-b082-40f9-be14-b7d8a2c1f21d.chatie?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJTZDGVES7DK5SW2Q%2F20181207%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Date=20181207T071354Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=18608f4c3b88d9706786948cb8febe1cc274bc67720690256a83c8d8c90f3e4f"
            ]))
        
        completion()
    }
    
    func loadWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "chatie")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: configuration)
        self.webView.scrollView.bounces = false
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
        
        //        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        //        webView.loadFileURL(url, allowingReadAccessTo: url)
        
        let url = URL(string: "http://192.168.1.12:8080")!
        self.webView.load(URLRequest(url: url))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let body: [String: Any] = message.body as! [String: Any]
        let command = body["command"] as? String
        
        switch command {
        case "initialized":
            self.loadDataIntoViewer(episodeDetail: self.episodeDetail!)
            break
        case "tap":
            guard let sceneIndex = body["sceneIndex"] as? Int,
                let chatIndex = body["chatIndex"] as? Int else {
                    return
            }
            
            if self.userStatus.isSubscribed {
                self.lastRead = [sceneIndex, chatIndex]
                self.tapCount += 1
                break
            }
            
            print(sceneIndex, chatIndex, self.lastRead, self.remainTap)
            
            if self.remainTap - 1 < 0
                && (sceneIndex == self.lastRead[0] && chatIndex == self.lastRead[1])
            {
                // TODO: show subscription modal
                print("show subscription modal")
                break
            }
            
            self.lastRead = [sceneIndex, chatIndex]
            self.tapCount += 1
            if !self.userStatus.isSubscribed {
                self.remainTap -= 1
            }
            
            break
        case "viewMedia":
            guard let url = body["url"] as? String,
                let type = body["type"] as? String else {
                return
            }
            
            if type == "image" {
                self.showImageFullscreen(imageURL: URL(string: url)!)
            } else if type == "video" {
                self.showVideoFullscreen(videoURL: URL(string: url)!)
            }
            break
        case "finish":
            if self.isFinished {
                return
            }
            
            self.isFinished = true
            
            print("finish")
            break
        default: break
        }
    }
    
    func loadDataIntoViewer(episodeDetail: EpisodeDetail) {
        // TODO: simplify
        let data = [
            "id": episodeDetail.id,
            "title": episodeDetail.title,
            "storyTitle": episodeDetail.storyTitle,
            "order": episodeDetail.order,
            "url": episodeDetail.url,
            "isSubscribed": self.userStatus.isSubscribed,
            "sceneIndex": self.userStatus.lastSceneIndex,
            "chatIndex": self.userStatus.lastChatIndex,
            "remainTap": self.userStatus.remainTap
            ] as [String : Any]
        guard let json = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
            return
        }
        
        let jsonString = String(data: json, encoding: .utf8)!
        
        self.webView.evaluateJavaScript("window.chatieInterface.load(\(jsonString))", completionHandler: { result, error in
        })
    }
    
    
    func showImageFullscreen(imageURL url: URL) {
        let images: [LightboxImage] = [LightboxImage(imageURL: url)]
        
        let modal = LightboxController(images: images)
        modal.pageDelegate = self
        modal.dismissalDelegate = self
        
        self.present(modal, animated: true, completion: nil)
    }
    
    func showVideoFullscreen(videoURL url: URL) {
        let playerController = PlayerViewController(videoURL: url)
    
        self.present(playerController, animated: true, completion: nil)
    }
}


extension ViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}


extension ViewController: LightboxControllerPageDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
}

extension ViewController: LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
}

