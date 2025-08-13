//
//  ViewModel.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/13.
//

import RxSwift
import RxCocoa

// RxSwiftのViewModelの書き方

final class ViewModel1 {
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

final class ViewModel2 {
    private let disposeBag = DisposeBag()
    // 1. 中からリアクティブに更新 ○
    // 2. 中からリアクティブに値を取得 ○
    // 3. 中から手続き的に更新 ○
    // 4. 中から手続き的に値を取得 ×
    // 5. 外からリアクティブに更新 ○
    // 6. 外からリアクティブに値を取得 ○
    // 7. 外から手続き的に更新 ○
    // 8. 外から手続き的に値を取得 ×
    // 9. 値を保持 ×
    //
    // 値を保持しないため副作用がない
    let valueRelay: PublishRelay<Int> = .init()

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

func test2() {
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

    let vm = ViewModel2()

    // 5. 外からリアクティブに更新 ○
    valueRelay.bind(to: vm.valueRelay).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ○
    vm.valueRelay.asObservable().subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ○
    vm.valueRelay.accept(1)

    // 8. 外から手続き的に値を取得 ×
//    print(vm.valueRelay.value)

}

final class ViewModel3 {
    private let disposeBag = DisposeBag()
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

final class ViewModel4 {
    private let disposeBag = DisposeBag()
    // 1. 中からリアクティブに更新 ○
    // 2. 中からリアクティブに値を取得 ○
    // 3. 中から手続き的に更新 ○
    // 4. 中から手続き的に値を取得 ×
    // 5. 外からリアクティブに更新 ×
    // 6. 外からリアクティブに値を取得 ○
    // 7. 外から手続き的に更新 ×
    // 8. 外から手続き的に値を取得 ×
    // 9. 値を保持 ×
    //
    // 値を保持しないため副作用がない
    // 外から更新もされないため理想的
    private let valueRelay: PublishRelay<Int> = .init()
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

func test4() {
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

    let vm = ViewModel4()

    // 5. 外からリアクティブに更新 ×
//    valueRelay.bind(to: vm.valueObserver).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ○
    vm.valueObservable.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ×
//    vm.valueRelay.accept(1)

    // 8. 外から手続き的に値を取得 ×
//    print(vm.valueRelay.value)
}

final class ViewModel5 {
    private let disposeBag = DisposeBag()
    // 1. 中からリアクティブに更新 ○
    // 2. 中からリアクティブに値を取得 ○
    // 3. 中から手続き的に更新 ○
    // 4. 中から手続き的に値を取得 ×
    // 5. 外からリアクティブに更新 ×
    // 6. 外からリアクティブに値を取得 ○
    // 7. 外から手続き的に更新 ○
    // 8. 外から手続き的に値を取得 ×
    // 9. 値を保持 ×
    //
    // 値を保持しないため副作用がない
    private let valueRelay: PublishRelay<Int> = .init()
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

    func update(value: Int) {
        valueRelay.accept(value)
    }
}

func test5() {
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

    let vm = ViewModel5()

    // 5. 外からリアクティブに更新 ×
//    valueRelay.bind(to: vm.valueObserver).disposed(by: disposeBag)

    // 6. 外からリアクティブに値を取得 ○
    vm.valueObservable.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ○
    vm.update(value: 1)

    // 8. 外から手続き的に値を取得 ×
//    print(vm.valueRelay.value)
}

final class ViewModel6 {
    private let disposeBag = DisposeBag()
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

    // 6. 外からリアクティブに値を取得 ○
    vm.outputObservable.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

    // 7. 外から手続き的に更新 ×
//    vm.update(value: 1)

    // 8. 外から手続き的に値を取得 ×
//    print(vm.valueRelay.value)
}

final class ViewModel7 {
    private let disposeBag = DisposeBag()
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
    let disposeBag = DisposeBag()

    let valueRelay = BehaviorRelay<Int>(value: 0)

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
