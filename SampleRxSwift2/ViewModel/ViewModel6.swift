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
// 3. 中から手続き的に更新 ×
// 4. 中から手続き的に値を取得 ×
// 5. 外からリアクティブに更新  ○
// 6. 外からリアクティブに値を取得 ○
// 7. 外から手続き的に更新 ×
// 8. 外から手続き的に値を取得 ×
// 9. 値を保持 ×
//
// 値を保持しないため副作用がない
// 外から受け取った値をリアクティブに何か処理してリアクティブに返すだけ

final class ViewModel6 {
    private let disposeBag = DisposeBag()

    let outputObservable: Observable<Int>

    init(inputObservable: Observable<Int>) {
        // 1. 中からリアクティブに更新 ○
//        Observable.just(1).bind(to: valueRelay).disposed(by: disposeBag)

        // 2. 中からリアクティブに値を取得 ○
        inputObservable
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)

        outputObservable = inputObservable.compactMap({ 2 * $0 })
    }

    private func hoge() {
        // 3. 中から手続き的に更新 ×
//        valueRelay.accept(1)

        // 4. 中から手続き的に値を取得 ×
//        print(valueRelay.value)
    }
}

func test6() {
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

    // 5. 外からリアクティブに更新 ○
    let vm = ViewModel6(inputObservable: valueRelay.asObservable())
    // 5. 外からリアクティブに更新 ○
    Observable.just(1).bind(to: valueRelay).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ○
    vm.outputObservable.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ×
//    vm.update(value: 1)

    // 8. 外から手続き的に値を取得 ×
//    print(vm.valueRelay.value)
}
