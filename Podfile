platform :ios, '12.0'

target 'Phanpy' do
  use_frameworks!

  pod 'DateToolsSwift', '~> 4.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'MastodonKit', :git => 'https://github.com/kylinroc/MastodonKit', :commit => '23e063d32098020c74508307db57b3e89380c789'
  pod 'SwiftLint'

  script_phase :name => 'SwiftLint', :script => '${PODS_ROOT}/SwiftLint/swiftlint'

  target 'PhanpyTests' do
    inherit! :search_paths
  end
end
