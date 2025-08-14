//
//  SwiftUI.swift
//  SampleRxSwift2
//
//  Created by sakiyamaK on 2025/08/13.
//

import SwiftUI
import Observation

@Observable
final class SwiftUIViewModel {
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
    // Observableを使うとSwiftUIでもUIKitでも手続き的に更新すればリアクティブに反応させることができる
    var value: Int = 0

    private func hoge() {
        // 1. 中からリアクティブに更新 ○
        // 3. 中から手続き的に更新 ○
        value = 1

        // 2. 中からリアクティブに値を取得 ○
        // 4. 中から手続き的に値を取得 ○
        print(value)
    }
}

struct SwiftUIView: View {
    var viewModel: SwiftUIViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // 6. 外からリアクティブに値を取得 ○
            // 8. 外から手続き的に値を取得 ○
            Text("\(viewModel.value)")
            Button("Tap Me") {
                // 5. 外からリアクティブに更新 ○
                // 7. 外から手続き的に更新 ○
                self.viewModel.value += 1
            }
        }
    }
}

#Preview {
    SwiftUIView(viewModel: SwiftUIViewModel())
}
