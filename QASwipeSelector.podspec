Pod::Spec.new do |s|

# Library description
  s.name         = 'QASwipeSelector'
  s.version      = '0.0.1'
  s.author       = { 'Quentin ARNAULT' => 'quentin.arnault@gmail.com' }
  s.license      = {
  	:type => 'MIT',
  	:text => 'MIT Licence'
  }
  s.homepage     = 'https://github.com/QuentinArnault/QASwipeSelector'
  s.summary      = 'QASwipeSelector is a new graphical component which offers the possibility to swipe between items.'
  s.description  = <<-DESC
                   QASwipeSelector is a new graphical component which offers the possibility to swipe between items.
                   DESC
  s.source       = {
  	:git => 'https://github.com/QuentinArnault/QASwipeSelector.git',
  	:branch => 'develop'
  }
  s.source_files = 'QASwipeSelector/QASwipeSelector/*.{h,m}'

# Platform setup
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

# Subspecs

end
