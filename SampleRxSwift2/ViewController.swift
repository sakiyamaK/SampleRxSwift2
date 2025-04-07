//
//  ViewController.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/04/08.
//

import UIKit
import RxSwift
import RxCocoa

func print<T>(_ value: T) {
    Swift.print("[\(#file.split(separator: "/").last!) \(#line)] \(value)")
}

class SampleRxSwift1 {
    // CombineでいうSet<AnyCancellable>()
    private let disposeBag = DisposeBag()

    /*
     RxSwiftの基本型
     1- 通知を受け取る
     2- 値を流す
     3- エラーを流す
     4- 完了を流す
     ができる
     */
    private let publishSubject: PublishSubject<Int> = .init()
    /*
     PublishSubjectのラッパー
     UIに値を流す場合、基本的にエラーと完了を流すことはない
        -> アプリが終了するまでUIが動き続けるため
     1- 通知を受け取る
     2- 値を流す
     ができる
     */
    private let publishRelay: PublishRelay<Int> = .init()
    /*
     PublishSubjectの値を保持する版
     リアクティブプログラミングは処理を事前に繋いでおいて値を流していくイメージ
     途中の処理で値は保持されない(メモリーを確保しない)

     しかしBehaviorSubjectはメモリーを確保して最後に流れた値を保持しておく
     そして
     1- 通知を受け取る
     2- 値を流す
     3- エラーを流す
     4- 完了を流す
     ができる
     */
    private let behaviorSubject: BehaviorSubject<Int> = .init(value: 0)
    /*
     BehaviorSubjectのRelay版

     最後に流れた値を保持する
     そして
     1- 通知を受け取る
     2- 値を流す
     ができる
     */
    private let behaviorRelay: BehaviorRelay<Int> = .init(value: 0)

    init() {
        setupSubscribe()
        stream()
    }

    // 値の受け取りを設定する
    private func setupSubscribe() {
        publishSubject
            .subscribe(onNext: {
                // 値が流れきた時のクロージャ
                print("publishSubject \($0)")
            }, onError: { error in
                // エラーが流れきた時のクロージャ
                print("publishSubject \(error)")
            }, onCompleted: {
                // 完了が流れてきた時のクロージャ
                print("publishSubject completed")
            })
            .disposed(by: disposeBag)

        publishRelay
            .subscribe(onNext: {
                // 値が流れきた時のクロージャ
                print("publishRelay \($0)")
            }, onError: { error in
                /*
                 subscribeメソッドにonErrorのクロージャがあるので指定はできるが
                 PublishRelayはエラーを流すことはないのでここに処理がくることはない
                 */
                // エラーが流れきた時のクロージャ
                print("publishRelay \(error)")
            }, onCompleted: {
                /*
                 subscribeメソッドにonCompletedのクロージャがあるので指定はできるが
                 PublishRelayはエラーを流すことはないのでここに処理がくることはない
                 */
                // 完了が流れてきた時のクロージャ
                print("publishRelay completed")

            })
            .disposed(by: disposeBag)

        behaviorSubject
            .subscribe(onNext: {
                // 値が流れきた時のクロージャ
                print("behaviorSubject \($0)")
            }, onError: { error in
                // エラーが流れきた時のクロージャ
                print("behaviorSubject \(error)")
            }, onCompleted: {
                // 完了が流れてきた時のクロージャ
                print("behaviorSubject completed")
            })
            .disposed(by: disposeBag)

        behaviorRelay
            .subscribe(onNext: {
                // 値が流れきた時のクロージャ
                print("behaviorRelay \($0)")
            }, onError: { error in
                /*
                 subscribeメソッドにonErrorのクロージャがあるので指定はできるが
                 BehaviorRelayはエラーを流すことはないのでここに処理がくることはない
                 */
                // エラーが流れきた時のクロージャ
                print("behaviorRelay \(error)")
            }, onCompleted: {
                /*
                 subscribeメソッドにonErrorのクロージャがあるので指定はできるが
                 BehaviorRelayはエラーを流すことはないのでここに処理がくることはない
                 */
                // 完了が流れてきた時のクロージャ
                print("behaviorRelay completed")
            })
            .disposed(by: disposeBag)
    }

    // 値を流す
    private func stream() {
        /*
         onNextとかonErrorとかのメソッドを呼ぶことでこれまでのプログラミングみたいに値を流すこともできる
        */

        // -------- PublishSubjectに値を流す
        publishSubject.onNext(1)
        publishSubject.onNext(2)
        // errorかcompletedが流れるとそれ以降は値が流れない
        publishSubject.onError(NSError(domain: "エラー", code: 100))
        // エラーが流れた後だから流れない
        publishSubject.onCompleted()
        publishSubject.onNext(3)

        // -------- PublishRelayに値を流す
        // publishRelayはonNextではなくacceptメソッドで値を流す
        publishRelay.accept(1)
        publishRelay.accept(2)
        // onErrorはonCompletedはない (流せない)
        publishRelay.accept(3)



        /*
         BehaviorSubjectとBehaviorRelayは初期値を持っているため最初にそれが流れる
         */

        // -------- BehaviorSubjectに値を流す
        behaviorSubject.onNext(1)
        behaviorSubject.onNext(2)
        // BehaviorSubjectとBehaviorRelayは初期値を持っているため最初にそれが流れる
        let behaviorSubjectValue1 = try! behaviorSubject.value()
        print("behaviorSubjectが最後に流した値は \(behaviorSubjectValue1)")
        behaviorSubject.onError(NSError(domain: "エラー", code: 100))
        behaviorSubject.onCompleted()
        // エラーやonCompletedが流れた後は取得できない
        let behaviorSubjectValue2 = try? behaviorSubject.value()
        print("behaviorSubjectが最後に流した値は \(behaviorSubjectValue2 ?? -1)")

        // -------- BehaviorRelayに値を流す
        behaviorRelay.accept(1)
        behaviorRelay.accept(2)
        // BehaviorRelayはエラーやcompleteを流すことがないのでtryの必要がない
        print("publishRelayが最後に流した値は \(behaviorRelay.value)")
    }
}

class SampleRxSwift2 {
    // privateじゃなくせば外から値を受け取れるし外に値を流せる
    /*
     なんでこんな別クラスで分ける意味があるのかという点は置いておいて
     今は外のクラスから値を受け取ったり外に流したりできるという「機能」だけ理解しよう
     */
    let publishSubject: PublishSubject<Int> = .init()
    let publishRelay: PublishRelay<Int> = .init()
    let behaviorSubject: BehaviorSubject<Int> = .init(value: 0)
    let behaviorRelay: BehaviorRelay<Int> = .init(value: 0)

    init() {
    }
}

class SampleRxSwift3 {
    private let disposeBag = DisposeBag()

    // 入力と出力で分ける
    let outputRelay: PublishRelay<Int> = .init()
    let inputRelay: PublishRelay<Int> = .init()

    init() {
        // inputRleayから流れてきたものに対してロジックを通してoutputRelayに渡す
        // 本来ならここでAPI通信など複雑な処理がはいってoutputRelayに流す
        inputRelay.subscribe(onNext: {[weak self] value in
            let outputValue = value * 10
            self!.outputRelay.accept(outputValue)
        })
        .disposed(by: disposeBag)
    }
}

class SampleRxSwift4 {
    private let disposeBag = DisposeBag()

    // privateにして外部には見せない
    private let inputRelay: PublishRelay<Int> = .init()
    private let outputRelay: PublishRelay<Int> = .init()

    // 外部から見えるパラメータは入力と出力で専用の型を使う
    lazy var inputObserver: AnyObserver<Int> = .init { [weak self] event in
        // 値が外からきたら何をするか決めるクロージャ
        // ここではinputRelayに渡してる
        self?.inputRelay.accept(event.element!)
        return
    }
    // RelayのasObservable()メソッドで外に出力だけするObservable型に変換する
    lazy var outputObservable: Observable<Int> = outputRelay.asObservable()

    init() {
        inputRelay.subscribe(onNext: {[weak self] value in
            let outputValue = value * 10
            self!.outputRelay.accept(outputValue)
        })
        .disposed(by: disposeBag)
    }
}

class SampleRxSwift5 {
    private let disposeBag = DisposeBag()

    private let inputRelay: PublishRelay<Int> = .init()
    private let outputRelay: PublishRelay<Int> = .init()

    lazy var inputObserver: AnyObserver<Int> = .init { [weak self] event in
        self?.inputRelay.accept(event.element!)
        return
    }
    lazy var outputObservable: Observable<Int> = outputRelay.asObservable()

    init() {
        /*
         これまでのsubscribeのクロージャの中で色々とロジックを書いたが宣言的とはいえない
         */
        // bindすると直接流れてきた値をoutputRelayに流す
        inputRelay
            .map({
                $0 * 10
            })
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}

class SampleRxSwift6 {
    private let disposeBag = DisposeBag()

    /*
     パラメータが増えてくると何がinput用で何がoutput用か分からなくなってくる
     そのためenumやstructやprotocolを利用するなどして、グルーピングしたりする
     */
    struct Input {
        let value: PublishRelay<Int> = .init()
    }
    struct Output {
        let value: PublishRelay<Int> = .init()
    }

    let input: Input = .init()
    let output: Output = .init()

    init() {
        /*
         これまでのsubscribeのクロージャの中で色々とロジックを書いたが宣言的とはいえない
         */
        // bindすると直接流れてきた値をoutputRelayに流す
        input.value
            .map({
                $0 * 10
            })
            .bind(to: output.value)
            .disposed(by: disposeBag)
    }
}

class SampleRxSwift7 {
    private let disposeBag = DisposeBag()

    /*
     InputとOutputの中身をさらに厳密にやるとこうなる
     */
    struct Input {
        var inputObserver: AnyObserver<Int>
    }
    struct Output {
        var outputObservable: Observable<Int>
    }

    private let inputRelay: PublishRelay<Int> = .init()
    private let outputRelay: PublishRelay<Int> = .init()

    lazy var input: Input = .init(inputObserver: .init(eventHandler: {[weak self] event in
        self!.inputRelay.accept(event.element!)
    }))
    lazy var output: Output = .init(outputObservable: outputRelay.asObservable())

    init() {
        inputRelay
            .map({
                $0 * 10
            })
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}

class SampleRxSwift8 {
    private let disposeBag = DisposeBag()

    /*
     自分なりの落とし所

     1. PublishRelayとBehaviorRelayしか使わない
     2. Inputはこれまで通りメソッドを使う
     3. OutputだけObservableに任せる
     4.
     mapとか色々RxSwiftは便利なメソッドがあるか膨大で機能を把握してられないためやってられない
     そのためsubscribeでクロージャを使ってロジックを自分で書く
     */

    private let inputRelay: PublishRelay<Int> = .init()

    private let outputRelay: PublishRelay<Int> = .init()
    lazy var outputObservable: Observable<Int> = outputRelay.asObservable()

    init() {
        // ここをBinder(self)にしちゃうとメインスレッドで処理しちゃうので困る場合がある
        inputRelay
            .subscribe(onNext: {[weak self] value in
                let newValue = value * 10
                self!.outputRelay.accept(newValue)
            })
            .disposed(by: disposeBag)
    }

    func input(value: Int) {
        inputRelay.accept(value)
    }
}



class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        testSample1()
//        testSample2()
        testSample3()
    }

    func testSample1() {
        _ = SampleRxSwift1()
    }

    func testSample2() {

        let sample = SampleRxSwift2()

        // SampleRxSwift2の外でsubscribe
        sample.publishRelay
            .subscribe(onNext: {
                print("publishRelay \($0)")
            }, onError: { error in
                print("publishRelay \(error)")
            }, onCompleted: {
                print("publishRelay completed")

            })
            .disposed(by: disposeBag)

        // SampleRxSwift2の外から値を流す
        sample.publishRelay.accept(1)
        sample.publishRelay.accept(2)
    }

    func testSample3() {

        let sample = SampleRxSwift3()
        sample.outputRelay
            .subscribe(onNext: {
                print("outputRelay \($0)")
            })
            .disposed(by: disposeBag)

        sample.inputRelay.accept(1)
        sample.inputRelay.accept(2)

        /*
         全部PublishRelayにする問題点
         入力用のPublishRelayなのか
         出力用のPublishRelayなのか
         間違える可能性がある
         */
        // これは出力用のRelayなのにacceptして値を流せてしまう
        sample.outputRelay.accept(10)
    }

    func testSample4() {
        let sample = SampleRxSwift4()

        sample.outputObservable.subscribe(onNext: {
            print("outputRelay \($0)")
        }).disposed(by: disposeBag)

        // Observableは値を受け取れるが流せない
//        sample.outputObservable.accept(1)

        sample.inputObserver.on(.next(1))
        sample.inputObserver.on(.next(2))
        // Observerは値を流せるが受け取れない
//        sample.inputObserver.subscribe(onNext: {
//
//        }).disposed(by: disposeBag)
    }

    func testSample5() {
        let sample = SampleRxSwift5()

        sample.outputObservable.subscribe(onNext: {
            print("outputRelay \($0)")
        }).disposed(by: disposeBag)
        sample.inputObserver.on(.next(1))
        sample.inputObserver.on(.next(2))
    }

    func testSample6() {
        let sample = SampleRxSwift6()

        sample.output.value.subscribe(onNext: {
            print("outputRelay \($0)")
        }).disposed(by: disposeBag)

        sample.input.value.accept(1)
    }

    func testSample7() {
        let sample = SampleRxSwift7()

        sample.output.outputObservable.subscribe(onNext: {
            print("outputObservable \($0)")
        }).disposed(by: disposeBag)

        sample.input.inputObserver.onNext(1)
    }

    func testSample7_2() {
        let sample = SampleRxSwift7()

        /*
         RxSwiftは基本はサブスレッドで動く可能性があるため
         最終的なView側の受け取りは明示的にメインスレッドで行う
         */
        sample.output
            .outputObservable
            .subscribe(on: MainScheduler.instance) // これ以降はメインスレッド
            .subscribe(onNext: {
                print("outputObservable \($0)")
            }).disposed(by: disposeBag)

        sample.input.inputObserver.onNext(1)
    }

    func testSample7_3() {
        let sample = SampleRxSwift7()

        /*
         subscribeで受け取るのはクロージャのため
         [weak self]を毎回つけて循環参照に気をつけるべきだがめんどくさい
         .bind(to: Binder(self) { _self, value in
         })
         とやると
         「メインスレッドになる」し「Binder()で囲った部分は循環参照しなくなる」
         のでView側でやるならこれが楽だと思う
         */
        sample.output
            .outputObservable
            .bind(to: Binder(self) { _self, value in
                print("outputObservable \(value)")
            }).disposed(by: disposeBag)

        sample.input.inputObserver.onNext(1)
    }

    func testSample8() {
        let sample = SampleRxSwift8()

        sample.outputObservable
            .bind(to: Binder(self) { _self, value in
                print("outputObservable \(value)")
            }).disposed(by: disposeBag)

        sample.input(value: 1)
        sample.input(value: 2)
    }


}

#Preview {
    ViewController()
}
