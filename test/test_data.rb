module Pingpp
  module TestData
    @charge_id_created = nil

    def get_api_key
      'sk_test_ibbTe5jLGCi5rzfH4OqPW9KC'
    end

    def get_api_key_live
    end

    def get_app_id
      'app_1Gqj58ynP0mHeX1q'
    end

    def get_sub_app_id
      'app_mX1mPSGyTqP4mPCK'
    end

    def sub_app_id_to_delete
      'app_ayTqP4mX1PPSGCKm'
    end

    def set_charge_id(ch_id)
      @charge_id_created = ch_id
    end

    def get_charge_id
      'ch_TanbTO9OmjP4TGW5a1j1mPiL'
    end

    def get_refund_id
      're_f1iHq5CuDSSKGCS8y1SeDSqT'
    end

    def get_bat_re_id
      '1501702241124307723'
    end

    def get_bat_tr_id
      '1801702281011244578'
    end

    def get_user_id
      'test_user_001'
    end

    def get_txn_id
      '310317022810333800188901'
    end

    def get_coupon_template_id
      '300117012016532300016701'
    end

    def get_unpaid_order_id
      '2001702280000033651'
    end

    def make_charges_for_batch_refund
      [
        'ch_D8uDO4fPSS40SOSmT4WfTCm9',
        'ch_rPOO4SbDqP04O8Sa9SaDa9u1'
      ]
    end

    def get_settle_account_id
      'test_user_001'
    end

    # 订单 (order) 相关 ID 信息
    def existed_order_id
      '2001709040000026131'
    end

    def existed_charge_id_of_order
      ['2001709040000026131', 'ch_fbD0SKiPynnLznT0S0zrvDSK']
    end

    def existed_refund_id_of_order
      ['2001709040000026131', 're_mnX90SPmzjnDvv1CWPyn5arH']
    end

    def order_to_cancel
      '2001709040000028901'
    end

    def order_and_charge_to_refund
      ['2001709040000026131', 'ch_fbD0SKiPynnLznT0S0zrvDSK']
    end

    def order_to_pay
      '2001709040000027851'
    end

    # 充值 (recharge) 相关 ID 信息
    def existed_recharge_id
      '220170904816730992640002'
    end

    def recharge_to_refund
      '220170904816730992640002'
    end

    def existed_refund_id_of_recharge
      ['220170904816730992640002', 're_arDqzHPurrHGvD4KeD54O84K']
    end

    # 用户 user 相关 ID 信息
    def existed_user_id
      'user_007'
    end

    def existed_user_id_for_balance_transfer
      'test_user_001'
    end

    # 余额赠送 balance_bonus 相关 ID 信息
    def existed_balance_bonus_id
      '650170904814419589120001'
    end

    # 余额转账 balance_transfer 相关 ID 信息
    def existed_balance_transfer_id
      '660170904814247700480002'
    end

    # 提现 withdrawal 相关 ID 信息
    def existed_withdrawal_id
      '1701709081542133945'
    end

    # 批量提现 batch_withdrawal 相关 ID 信息
    def existed_batch_withdrawal_id
      '1901709081656012102'
    end

    # 分润相关 ID 信息
    def existed_royalty_template_id
      '450170908173700001'
    end

    def royalty_template_id_to_delete
      '450170908172300001'
    end

    def get_royalty_ids_to_update
      [
        '410170908205700002',
        '410170908205700001',
      ]
    end

    def existed_royalty_id
      '410170908205700001'
    end

    def get_payer_app
      'app_1Gqj58ynP0mHeX1q'
    end

    def existed_royalty_settlement_id
      '430170908211000001'
    end

    def existed_royalty_transaction_id
      '440170908213000001'
    end

    # 优惠券相关 ID 信息
    def coupon_id_and_user
      ['300317082315265100025202', 'test_user_001']
    end

    def coupon_id_and_user_to_delete
      ['300317082315160100056601', 'test_user_001']
    end

    def coupon_id_and_user_to_update
      ['300317090822145900061202', '488c35c2e06a']
    end

    def existed_coupon_template_id
      '300117090822064600031402'
    end

    def coupon_template_id_to_delete
      '300117090822195700031902'
    end
  end
end
