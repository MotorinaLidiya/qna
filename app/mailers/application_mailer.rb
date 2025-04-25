class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('YANDEX_EMAIL')
  layout 'mailer'
end
