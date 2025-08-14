//
//  SourceOfTruthViewModel.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/14.
//

import RxSwift
import RxCocoa

// 信頼できる情報源がひとつじゃないダメな例

final class SourceOfTruthViewModel1_1 {

    private let disposeBag = DisposeBag()

    let valueRelay: BehaviorRelay<Int> = .init(value: 0)

    // サーバーと通信してデータを取得的な
    func api() {
        // 2_1の値を更新
        Observable.just(1).bind(to: valueRelay).disposed(by: disposeBag)
    }
}

final class SourceOfTruthViewModel1_2 {
    private let disposeBag = DisposeBag()

    let valueRelay: BehaviorRelay<Int> = .init(value: 0)

    func hoge() {
        Observable.just(1).bind(to: valueRelay).disposed(by: disposeBag)
    }
}

func testSourceOfTruthViewModel1() {
    let disposeBag = DisposeBag()
    
    let viewModel1_1 = SourceOfTruthViewModel1_1()
    let viewModel1_2 = SourceOfTruthViewModel1_2()

    // 1_1 -> 1_2 へバインディング
    viewModel1_1.valueRelay.bind(to: viewModel1_2.valueRelay).disposed(by: disposeBag)
    // 1_2 -> 1_1 へバインディング
    viewModel1_2.valueRelay.bind(to: viewModel1_1.valueRelay).disposed(by: disposeBag)

    // 1_1の値を更新すると...
    /*
     1_1.valueRelayが更新したから1_2.valueRelayへ値が伝播される
     1_2.valueRelayが更新したから1_1.valueRelayへ値が伝播される
     1_1.valueRelayが更新したから1_2.valueRelayへ値が伝播される
     1_2.valueRelayが更新したから1_1.valueRelayへ値が伝播される
     ... という無限ループになる
     */
    viewModel1_1.api()
    // 1_2の値が更新しても同じく無限ループ
    viewModel1_2.hoge()

    // 同じ情報が複数箇所にあると参照すべきデータはどっち？となる
    print(viewModel1_1.valueRelay.value)
    print(viewModel1_2.valueRelay.value)
}
