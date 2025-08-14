# 結論

値をリアクティブに更新できて出力もする状態は双方向バインディング

SwiftUIのCombineやiOS17からのObservationも双方向バインディング

難しいことを考えずBehaviorRelayかPublishRelayをpublic letで定義してしまうのがSwiftUIへの移行もやりやすいんじゃないか

# 双方向バインディングをするための大前提

Single Source of Truth(信頼できる情報源はひとつ)を徹底すること

Appleも度々そこを強調している

https://developer.apple.com/jp/videos/play/wwdc2020/10040/?time=432

https://developer.apple.com/jp/videos/play/wwdc2019/226/?time=180

言い換えると

`var value: Int`や `let valueRelay: BehaviorRelay<Int>`

をあちこちにコピーするな

# 手続き的な読み書きの必要性

## 手続き的に値を読み込む必要性

UIKitのDelegateパターンが絡むと必要

```swift
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      // こう言う時
      return vm.valuesRelay.value.count
    }
}
```

だがUICollectionViewはDiffableDataSourceなどができて、手続き的に値を取得する必要性は減っていっている

他のUIKitのコンポーネントも同様に手続き的に取得する必要がなくなっていっている

## 手続き的に値を書き込む必要性

中途半端にRxSwiftが導入されていて、それ以前の手続き的な処理との橋渡しぐらい

ちゃんと全部がリアクティブになれば必要ないかも？
