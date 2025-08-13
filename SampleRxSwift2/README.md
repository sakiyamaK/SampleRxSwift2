# 結論

値をリアクティブに更新できて出力もする状態は双方向バインディング

SwiftUIのCombineやiOS17からのObservationも双方向バインディング

難しいことを考えずBehaviorRelayかPublishRelayをpublic letで定義してしまうのがSwiftUIへの移行もやりやすいんじゃないか

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

特にないか？

