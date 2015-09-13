//
//  WPJOAuth2LoginViewController.swift
//  WordpressJSONApi
//
//  Created by Flo on 08.09.15.
//  Copyright (c) 2015 Florian Wagner. All rights reserved.
//

import UIKit
import WebKit

public protocol WPJOAuth2LoginViewControllerDelegate : NSObjectProtocol {
    /**
    
    */
    func didCompleteLogin(viewController : WPJOAuth2LoginViewController, user : WPJUser);
    func didFailLogin(viewController : WPJOAuth2LoginViewController, error : NSError);
}

public class WPJOAuth2LoginViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var progressIndicator: UIProgressView!
    @IBOutlet private weak var webViewContainer: UIView!
    private var webView : WKWebView?;
    private var currentNavigation : WKNavigation? = nil;
    
    public var delegate : WPJOAuth2LoginViewControllerDelegate?;
    public var manager : WPJOAuth2Manager = WPJOAuth2Manager();
    
    public init() {
        super.init(nibName: "WPJOAuth2LoginViewController", bundle: NSBundle(forClass: WPJOAuth2LoginViewController.self));
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public override func viewWillAppear(animated: Bool) {
        self.startAuthentication();
    }

    private func startAuthentication()
    {
        // Setup loading view
        self.progressIndicator.progress = 0;
        self.webView?.addObserver(self, forKeyPath: "estimatedProgress", options: nil, context: nil);
        
        // load authentication page from WP
        self.currentNavigation = self.webView?.loadRequest(NSURLRequest(URL: self.manager.buildAuthenticationURL()));
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "didTapCancel");
        self.navigationItem.rightBarButtonItem = cancelButton;
        
        self.webView = WKWebView();
        self.webView?.navigationDelegate = self;
        self.webViewContainer.addSubview(self.webView!);
        
        var views = [String : AnyObject]();
        views["webView"] = self.webView;
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views);
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views);
        self.webViewContainer.setTranslatesAutoresizingMaskIntoConstraints(false);
        self.webView?.setTranslatesAutoresizingMaskIntoConstraints(false);
        self.webViewContainer.addConstraints(verticalConstraints);
        self.webViewContainer.addConstraints(horizontalConstraints);
        self.webViewContainer.hidden = true;
        self.loadingView.hidden = false;
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if(self.currentNavigation == navigation)
        {
            self.currentNavigation = nil;
            self.webViewContainer.hidden = false;
            self.loadingView.hidden = true;
            self.webView!.removeObserver(self, forKeyPath: "estimatedProgress");
        }
    }
    
    public func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if(self.manager.isAuthenticationRedirect(self.webView!.URL!))
        {
            self.manager.handleRedirectWithToken(self.webView!.URL!);
            self.webView!.stopLoading();
            var api = WPJWordpressAPI(oAuthManager: self.manager);
            api.getCurrentUser().onSuccess({ (first : WPJUser) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.didCompleteLogin(self, user: first);
                    self.dismissViewControllerAnimated(true, completion: nil);
                }
            });
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if(keyPath == "estimatedProgress")
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.progressIndicator.progress = Float(self.webView!.estimatedProgress);
                return;
            }
        }
    }
    
    
    @objc private func didTapCancel() {
        self.delegate?.didCompleteLogin(self);
        self.dismissViewControllerAnimated(true) {};
    }

}
