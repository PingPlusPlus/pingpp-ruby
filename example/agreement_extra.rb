module AgreementExtra
  def self.method_missing(method_id)
    {}
  end

  def self.qpay
    {
      # 可选，签约用户的名称，用于页面展示，如商户侧账号，昵称。
      :display_account => "签约测试",
    }
  end
end
