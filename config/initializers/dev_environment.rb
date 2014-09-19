unless Rails.env.production?
  ENV['MASTER_ADMIN_USER'] = 'tylerdavis'
end