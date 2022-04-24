//
//  AttachmentViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit
import AttributedString

class AttachmentViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        // 网络图片链接与占位图
        let url = URL(string: "https://avatars.githubusercontent.com/u/13112992?s=400&u=bb452b153d9d5342877ebd8179b04fbbae41f3d0&v=4")
        let placeholder = UIImage(named: "placeholder")
        
        
        // 创建一些自定义视图控件
        let customView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
        customView.backgroundColor = .red
        
        let customImageView = UIImageView(image: #imageLiteral(resourceName: "swift-image-1"))
        customImageView.contentMode = .scaleAspectFill
        customImageView.sizeToFit()
        
        let customLabel = UILabel()
        customLabel.text = "1234567890"
        customLabel.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel.sizeToFit()
        
        func clicked() {
            // 更改自定义视图的大小 (x y 无效)
            customView.frame = .init(x: 100, y: 0, width: .random(in: 100 ... 200), height: .random(in: 100 ... 200))
            
            // 更改自定义图片视图的图片
            customImageView.image = #imageLiteral(resourceName: "swift-icon")
            customImageView.sizeToFit()
            // 更改自定义标签的文本
            customLabel.text = "45678"
            customLabel.sizeToFit()
            
            // 请主动调用刷新布局
            textView.attributed.layout()
        }
        
        textView.attributed.text = .init(
            """
            
            This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"))) -> Displayed in original size.
            
            This is a picture -> \(.image(#imageLiteral(resourceName: "swift-icon"), .custom(.center, size: .init(width: 50, height: 50)))) -> Displayed in custom size.
            
            This is the recommended size image -> \(.image(#imageLiteral(resourceName: "swift-icon"), .proposed(.center)))).
            
            -----------------------
            
            AsyncImageAttachment only support UITextView (以下异步图片附件仅UITextView支持):
            
            This is a remote image URL -> \(.image(url, placeholder: placeholder))
            
            -----------------------
            
            \("ViewAttachment only support UITextView (以下视图附件仅UITextView支持):", .font(.systemFont(ofSize: 24, weight: .medium)))
            
            \("Change something", .foreground(.blue), .action(clicked))
            
            aaaa\(.view(customView, .original(.center)))aaa
            
            bbbb\(.view(customLabel, .original(.origin)))bbb
            
            cccc\(.view(customImageView, .original(.origin)))ccc
            
            """,
            .font(.systemFont(ofSize: 18))
        )
    }
}

/*
 
ASAttributedString.AsyncImageAttachment.Loader = AsyncImageAttachmentKingfisherLoader.self


import Kingfisher

public class AsyncImageAttachmentKingfisherLoader: NSObject, AsyncImageAttachmentLoader {
   
    private var downloadTask: Kingfisher.DownloadTask?
    
    public var isLoading: Bool {
        return downloadTask != nil
    }
    
    public func loadImage(with url: URL, completion: @escaping (Result<Image, Error>) -> Void) {
        downloadTask = KingfisherManager.shared.retrieveImage(with: url) { [weak self] (result) in
            guard let self = self else { return }
            self.downloadTask = nil
            
            switch result {
            case .success(let value):
                completion(.success(value.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func cancel() {
        downloadTask?.cancel()
        downloadTask = nil
    }
}

*/
