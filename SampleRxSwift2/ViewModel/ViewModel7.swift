//
//  ViewModel3.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/14.
//

import RxSwift
import RxCocoa

// 1. 中からリアクティブに更新　×
// 2. 中からリアクティブに値を取得 ×
// 3. 中から手続き的に更新 ○
// 4. 中から手続き的に値を取得 ○
// 5. 外からリアクティブに更新 ×
// 6. 外からリアクティブに値を取得 ×
// 7. 外から手続き的に更新 ○
// 8. 外から手続き的に値を取得 ○
// 9. 値を保持 ○
//
// 値を保持するから副作用に注意
// いわゆるリアクティブじゃない普通のプログラミング

final class ViewModel7 {
    private let disposeBag = DisposeBag()

    private(set) var value: Int = 0

    init() {
        // 1. 中からリアクティブに更新 ×
//        Observable.just(1).bind(to: valueRelay).disposed(by: disposeBag)

        // 2. 中からリアクティブに値を取得 ×
//        inputObservable
//            .subscribe(onNext: {
//                print($0)
//            })
//            .disposed(by: disposeBag)
    }

    private func hoge() {
        // 3. 中から手続き的に更新 ○
        value = 10

        // 4. 中から手続き的に値を取得 ○
        print(value)
    }

    func update(value: Int) {
        self.value = 2 * value
    }
}

func test7() {
//    let disposeBag = DisposeBag()
//
//    let valueRelay = BehaviorRelay<Int>(value: 0)

    let vm = ViewModel7()

    // 5. 外からリアクティブに更新 ×
//    valueRelay.bind(to: vm.valueObserver).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ×
//    vm.outputObservable.subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ○
    vm.update(value: 1)

    // 8. 外から手続き的に値を取得 ○
    print(vm.value)
}
