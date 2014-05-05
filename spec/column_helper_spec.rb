require 'spec_helper'

describe BingAdsApi::Helpers::ColumnHelper do
  include BingAdsApi::Helpers::ColumnHelper

  it "should return true if all the columns are found in the valid column list" do
    expect{
      valid_columns(
        {account_name: "AccountName"},
        [:account_name, "AccountName"]
      )
    }.to raise_error
  end

  it "should raise column exception when symbol is not in valid column keys" do
    expect{
      valid_columns(
        {account_name: "UnknownColumn"},
        [:account_name, :unknown_column]
      )
    }.to raise_error
  end

  it "should raise column exception when string is not in valid column values" do
    expect{
      valid_columns(
        {unknown_column: "Acct"},
        [:account_name, "UnknownColumn" ],
      )
    }.to raise_error
  end
end
