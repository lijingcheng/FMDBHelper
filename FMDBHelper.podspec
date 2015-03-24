#
# Be sure to run `pod lib lint FMDBHelper.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FMDBHelper"
  s.version          = "0.0.2"
  s.summary          = "Let FMDB insert/update/delete/select becomes a little bit more simple."
  s.homepage         = "http://lijingcheng.github.io/"
  s.license          = 'MIT'
  s.author           = { "lijingcheng" => "bj_lijingcheng@163.com" }
  s.source           = { :git => "https://github.com/lijingcheng/FMDBHelper.git", :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/lijingcheng1984'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'FMDBHelper' => ['Pod/Assets/*.png']
  }
  s.platform     = :ios
  s.dependency 'FMDB', '2.5'
end