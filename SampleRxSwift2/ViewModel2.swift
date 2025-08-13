//
//  ViewModel2.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/13.
//

import RxSwift
import RxCocoa

// RxSwiftのViewModelの書き方

final class ViewModel8 {
    private let disposeBag = DisposeBag()
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
    // ダメな書き方
    // これならViewModel1と変わらない

    // privateにしてカプセル化している気になっているだけ
    private let valueRelay: BehaviorRelay<Int> = .init(value: 0)

    // 外部からリアクティブに更新できる
    lazy var valueObserver: AnyObserver<Int> = .init(eventHandler: {[weak self] event in
        self!.valueRelay.accept(event.element!)
    })
    // 外部へリアクティブに出力してる
    lazy var valueObservable: Observable<Int> = valueRelay.asObservable()
    // 外部へ手続き的に出力してる
    var value: Int {
        valueRelay.value
    }

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

    // 外部から手続き的に更新できる
    func update(value: Int) {
        valueRelay.accept(value)
    }
}

func test8() {
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

    let vm = ViewModel8()

    // 5. 外からリアクティブに更新 ○
    valueRelay.asObservable().bind(to: vm.valueObserver).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ○
    vm.valueObservable.asObservable().subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ○
    vm.update(value: 1)

    // 8. 外から手続き的に値を取得 ○
    print(vm.value)
}
