require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  # t.pattern = './test/**/*_test.rb'
  t.test_files = FileList[
    'test/order_test.rb',
    'test/recharge_test.rb',
    'test/balance_transfer_test.rb',
    'test/balance_bonus_test.rb',
    'test/withdrawal_test.rb',
    'test/batch_withdrawal_test.rb',
    'test/royalty_template_test.rb',
    'test/royalty_test.rb',
    'test/royalty_settlement_test.rb',
    'test/royalty_transaction_test.rb',
    'test/coupon_template_test.rb',
    'test/coupon_test.rb',
    # 'test/sub_app_test.rb',
    'test/agreement_test.rb',
    # 'test/balance_settlement_test.rb',
    # 'test/card_info_test.rb',
  ]
end

desc "update bundled certs"
task :update_certs do
  require "restclient"
  File.open(File.join(File.dirname(__FILE__), 'lib', 'data', 'ca-certificates.crt'), 'w') do |file|
    resp = RestClient.get "https://curl.haxx.se/ca/cacert.pem"
    abort("bad response when fetching bundle") unless resp.code == 200
    file.write(resp.to_str)
  end
end
