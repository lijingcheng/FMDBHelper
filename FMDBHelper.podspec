#
# Be sure to run `pod lib lint FMDBHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FMDBHelper'
  s.version          = '1.1.0'
  s.summary          = 'Easier to use FMDB, support ORM and JSON into the model class.'
  s.homepage         = 'http://lijingcheng.github.io/'
  s.license          = 'MIT'
  s.author           = { 'lijingcheng' => 'bj_lijingcheng@163.com' }
  s.source           = { :git => 'https://github.com/lijingcheng/FMDBHelper.git', :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/lijingcheng1984'
  s.source_files     = 'FMDBHelper/Classes/*.{h,m}'
  s.platform         = :ios, '9.0'
  s.dependency 'FMDB', '2.7.5'
end
