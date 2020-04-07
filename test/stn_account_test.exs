defmodule StnAccountTest do
  use ExUnit.Case
  doctest StnAccount


  # StnAccount.create(tax_id) tests:
  test "tax_id as nil" do
    assert_raise(ArgumentError, fn -> StnAccount.create(nil) end)
  end

  test "tax_id invalid" do
    assert_raise(ArgumentError, fn -> StnAccount.create("8571831203a") end)
  end

  #StnAccount.get_balance
  test "inputs an invalid map (account)" do
    assert_raise(ArgumentError, fn -> StnAccount.get_balance(%{"account": "someacc"}) end)
  end

end
