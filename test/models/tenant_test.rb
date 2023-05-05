# == Schema Information
#
# Table name: tenants
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  admin_email     :string           not null
#  active          :boolean          default(TRUE)
#  code            :string           not null
#  secret_key      :string           not null
#  admin_token     :string           not null
#  admin_sdk_token :string           not null
#  preferences     :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class TenantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
