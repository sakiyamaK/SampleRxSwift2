//
//  ViewModel3.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/14.
//

import RxSwift
import RxCocoa

// 1. 中からリアクティブに更新 ○
// 2. 中からリアクティブに値を取得 ○
// 3. 中から手続き的に更新 ○
// 4. 中から手続き的に値を取得 ×
// 5. 外からリアクティブに更新 ○
// 6. 外からリアクティブに値を取得 ○
// 7. 外から手続き的に更新 ×
// 8. 外から手続き的に値を取得 ×
// 9. 値を保持 ×
//
// 値を保持しないため副作用がない
final class ViewModel3 {
    private let disposeBag = DisposeBag()

    private let valueRelay: PublishRelay<Int> = .init()
    lazy var valueObserver: AnyObserver<Int> = .init(eventHandler: {[weak self] event in
        self!.valueRelay.accept(event.element!)
    })
    lazy var valueObservable: Observable<Int> = valueRelay.asObservable()

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

        // 4. 中から手続き的に値を取得 ×
//        print(valueRelay.value)
    }
}

func test3() {
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

    let vm = ViewModel3()

    // 5. 外からリアクティブに更新 ○
    valueRelay.bind(to: vm.valueObserver).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ○
    vm.valueObservable.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ×
//    vm.valueRelay.accept(1)

    // 8. 外から手続き的に値を取得 ×
//    print(vm.valueRelay.value)
}
