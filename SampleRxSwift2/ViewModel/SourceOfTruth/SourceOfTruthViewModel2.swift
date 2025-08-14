//
//  Untitled.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/14.
//

import RxSwift
import RxCocoa

// 信頼できる情報源がひとつの例

final class SourceOfTruthViewModel2_1 {
    private let disposeBag: DisposeBag = .init()

    // 情報源はここだけ
    let valueRelay: BehaviorRelay<Int> = .init(value: 0)

    // サーバーと通信してデータを取得的な
    func api() {
        // 2_1の値を更新
        Observable.just(1).bind(to: valueRelay).disposed(by: disposeBag)
    }
}

// 中でリアクティブに値を処理したいだけならこう
final class SourceOfTruthViewModel2_2 {

    private let disposeBag: DisposeBag = .init()

    let valueRelay: PublishRelay<Int> = .init()

    init () {
        valueRelay
            .subscribe(onNext: { value in
                print(value)
            }).disposed(by: disposeBag)
    }
}

// 中でリアクティブor手続き的に値を処理したいならこう
final class SourceOfTruthViewModel2_3 {

    let disposeBag: DisposeBag = .init()

    private let valueRelay: BehaviorRelay<Int>

    init(valueRelay: BehaviorRelay<Int>) {
        self.valueRelay = valueRelay

        valueRelay
            .subscribe(onNext: { value in
                print(value)
            }).disposed(by: disposeBag)
    }

    func hoge() {
        print(valueRelay.value)
    }
}

// 中でリアクティブor手続き的に値を処理したいならこうも書ける
/*
 -  手っ取り早いがあまり良くない
 -  2_3のように必要なパラメータだけ渡すべき
 -  あまりにも必要なパラメータの数が多いならこう書いた方が楽だが
    そもそも必要なパラメータがそんなに多いものが2_1と2_4と分かれている設計がおかしい
 */
final class SourceOfTruthViewModel2_4 {

    let disposeBag: DisposeBag = .init()

    private let viewModel: SourceOfTruthViewModel2_1

    init(viewModel: SourceOfTruthViewModel2_1) {
        self.viewModel = viewModel

        viewModel.valueRelay
            .subscribe(onNext: { value in
                print(value)
            }).disposed(by: disposeBag)
    }

    func hoge() {
        print(viewModel.valueRelay.value)
    }
}


func testSourceOfTruthViewModel2() {

    let disposeBag = DisposeBag()

    let viewModel2_1 = SourceOfTruthViewModel2_1()

    let viewModel2_2 = SourceOfTruthViewModel2_2()
    // 2_1 -> 2_3 へバインディング
    let viewModel2_3 = SourceOfTruthViewModel2_3(valueRelay: viewModel2_1.valueRelay)
    // 2_1 -> 2_4 へバインディング
    let viewModel2_4 = SourceOfTruthViewModel2_4(viewModel: viewModel2_1)
    // 2_1 -> 2_2 へバインディング
    viewModel2_1.valueRelay.bind(to: viewModel2_2.valueRelay).disposed(by: disposeBag)

    // サーバーと通信してデータを取得的な
    viewModel2_1.api()
    // 2_1の値を参照
    print(viewModel2_1.valueRelay.value)
}
