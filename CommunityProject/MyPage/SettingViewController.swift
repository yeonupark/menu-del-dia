//
//  SettingViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/13.
//

import UIKit
import RxSwift

class SettingViewController: UIViewController {
    
    let mainView = SettingView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = SettingViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    func setTableView() {
        viewModel.items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element
                
                if row == 1 {
                    cell.textLabel?.textColor = .red
                }
            }
            .disposed(by: disposeBag)
        
        mainView.tableView
            .rx
            .itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, indexPath in
                switch indexPath.row {
                case 0 : owner.logout()
                case 1 : owner.withdraw()
                default: print("디폴트")
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func logout() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set("", forKey: "refreshToken")
    }
    
    func withdraw() {
        let vc = LoginViewController()
        
        viewModel.callWithdrawRequest { result in
            if result == 200 {
                self.navigationController?.setViewControllers([vc], animated: true)
                
            } else if result == 419 {
                self.viewModel.callRefreshToken { value in
                    if value {
                        // 토큰 리프레쉬 성공. 탈퇴요청 다시
                        self.viewModel.callWithdrawRequest { _ in
                            self.navigationController?.setViewControllers([vc], animated: true)
                        }
                    } else {
                        // 토큰 리프레쉬 실패. 첫화면으로 돌아가서 다시 로그인 해야됨
                        // alert
                        self.navigationController?.setViewControllers([vc], animated: true)
                    }
                }
            } else {
                print("withdraw error")
            }
        }
    }
    
}
