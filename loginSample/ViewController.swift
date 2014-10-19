//
//  ViewController.swift
//  loginSample
//
//  Created by Yuta Chiba on 2014/10/18.
//  Copyright (c) 2014年 yuinchirn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLConnectionDelegate {
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeAlertViewController()
    }
    
    override func viewDidAppear(animated: Bool) {
        showLoginAlert()
    }
    
    /* ログイン用のアラートビューを作成 */
    func makeAlertViewController(){
        alertController = UIAlertController(title: "Login", message: "", preferredStyle: .Alert)
        
        // ログインボタンが押された時のアクション
        let otherAction = UIAlertAction(title: "Login", style: .Default) {
            action in
            
            let textFields:Array<UITextField>? =  self.alertController.textFields as Array<UITextField>?
            if textFields != nil {
                
                var userArray = [String]()
                
                for textField:UITextField in textFields! {
                    println(textField.text)
                    userArray.append(textField.text)
                }
                NSLog("ログインします。")
                self.login(userArray[0], password: userArray[1])
            }
        }
        alertController.addAction(otherAction)
        
        
        alertController.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "UserName"
        })
        
        alertController.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "Password"
            text.secureTextEntry = true
        })
    }
    
    /* ログイン用アラートを表示 */
    func showLoginAlert(){
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /* ログイン認証処理 */
    func login(userName:NSString?, password:NSString?){
        
        println("userName:\(userName)。。password:\(password)")
        if userName == nil || password == nil {
            return self.showLoginAlert()
        }
        
        let str = "userName=\(userName!)&password=\(password!)"
        let strData = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        // TODO URLの本番、devを分岐(application.conf)
        var url = NSURL.URLWithString("http://localhost:9000/login")
        var request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        // NSURLConnectionを使ってアクセス
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: self.fetchResponse)
    }
    
    /* レスポンスの処理 */
    func fetchResponse(res: NSURLResponse?, data: NSData?, error: NSError?) {
        
        // ステータスコード取得
        let status = (res as NSHTTPURLResponse).statusCode
        
        // ステータス200:成功 それ以外:失敗
        if status != 200{
            println("ログイン失敗")
            self.showLoginAlert()
        }else{
            println("ログイン成功")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
