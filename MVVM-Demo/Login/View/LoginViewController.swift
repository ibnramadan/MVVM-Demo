//
//  LoginViewController.swift
//  MVVM-Demo
//
//  Created by iMac on 08/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let loginViewModel = LoginViewModel()
    //handle memory manual
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindTextFieldsToViewModel()
        subscribeToLoading()
        subscribeToResponse()
        subscribeIsLoginEnabled()
        subscribeToLoginButton()
    }
    func  bindTextFieldsToViewModel(){
        
        phoneTextField.rx.text.orEmpty.bind(to: loginViewModel.phoneBehavior).disposed(by: disposeBag)
        codeTextField.rx.text.orEmpty.bind(to: loginViewModel.codeBehavior).disposed(by: disposeBag)
        
    }

    // listen to loading behavior
    func subscribeToLoading() {
        loginViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and:  "")
            }else {
                self.hideIndicator()
            }
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        loginViewModel.loginModelObservable.subscribe(onNext: {
            if $0.statusCode == 200 {
                print($0.data?.phone ?? "")
                if let homeVC = UIStoryboard(name: "Branches", bundle: nil).instantiateViewController(withIdentifier: "BranchesViewController") as? BranchesViewController {
                   self.present(homeVC, animated: true)
                }
            } else {
                
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeIsLoginEnabled() {
        loginViewModel.isLoginButtonEnapled.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
    func subscribeToLoginButton() {
        loginButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.loginViewModel.getData()
        }).disposed(by: disposeBag)
    }

}
