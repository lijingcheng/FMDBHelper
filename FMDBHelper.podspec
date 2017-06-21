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
  s.version          = "1.0.5"
  s.summary          = "Easier to use FMDB, support ORM and JSON into the model class."
  s.homepage         = "http://lijingcheng.github.io/"
  s.license          = 'MIT'
  s.author           = { "lijingcheng" => "bj_lijingcheng@163.com" }
  s.source           = { :git => "https://github.com/lijingcheng/FMDBHelper.git", :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/lijingcheng1984'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.platform     = :ios, "8.0"
  s.dependency 'FMDB', '2.6.2'
end
