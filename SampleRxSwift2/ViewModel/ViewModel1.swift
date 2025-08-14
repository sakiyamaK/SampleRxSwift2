//
//  ViewModel.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/13.
//

import RxSwift
import RxCocoa

// 1. 中からリアクティブに更新 ○
// 2. 中からリアクティブに値を取得 ○
// 3. 中から手続き的に更新 ○
// 4. 中から手続き的に値を取得 ○
// 5. 外からリアクティブに更新 ○
// 6. 外からリアクティブに値を取得 ○
// 7. 外から手続き的に更新 ○
// 8. 外から手続き的に値を取得 ○
// 9. 値を保持 ○
//
// 最も書く量が少ないが、最も安全性が低い
// だが信頼できる情報源をひとつにすることを徹底したら理想系

final class ViewModel1 {

    private let disposeBag = DisposeBag()

    let valueRelay: BehaviorRelay<Int> = .init(value: 0)

    init() {
        // 1. 中からリアクティブに更新 ○
        Observable.just(1).bind(to: valueRelay).disposed(by: disposeBag)

        // 2. 中からリアクティブに値を取得 ○
        valueRelay
            .asObservable()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }

    private func hoge() {
        // 3. 中から手続き的に更新 ○
        valueRelay.accept(1)
        // 4. 中から手続き的に値を取得 ○
        print(valueRelay.value)
    }
}

func test1() {
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

    let vm = ViewModel1()

    // 5. 外からリアクティブに更新 ○
    valueRelay.asObservable().bind(to: vm.valueRelay).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ○
    vm.valueRelay.asObservable().subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ○
    vm.valueRelay.accept(1)

    // 8. 外から手続き的に値を取得 ○
    print(vm.valueRelay.value)
}









