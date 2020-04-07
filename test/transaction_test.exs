defmodule StnAccountTransactionTest do
  use ExUnit.Case
  doctest StnAccount.Transaction

  setup_all do
    {
      :ok,
      [
        account1: StnAccount.create_and_deposit("85718312036", 5000),
        account2: StnAccount.create_and_deposit("85718312035", 100),
        account3: StnAccount.create_and_deposit("85718312026", 100),
        account4: StnAccount.create_and_deposit("85718342095", 100)
      ]
    }
  end

  # StnAccount.Transaction.deposit(account, amount) tests:
  test "invalid amount to deposit" do
    assert_raise(ArgumentError, fn -> StnAccount.Transaction.deposit(%{}, 0) end)
  end

  # StnAccount.Transaction.transfer(account, amount) tests:
  test "transfer with not enough funds", %{account1: origin_account, account2: dest_account} do
    assert_raise(ArgumentError, fn ->
      StnAccount.Transaction.transfer(origin_account, dest_account, 6000)
    end)
  end

  test "invalid amount to transfer", %{account1: origin_account, account2: dest_account} do
    assert_raise(ArgumentError, fn ->
      StnAccount.Transaction.transfer(origin_account, dest_account, 0)
    end)
  end

  test "successful transter", %{account1: origin_account, account2: dest_account} do
    account = StnAccount.Transaction.transfer(origin_account, dest_account, 500)
    assert(account.balance.amount == 600)
  end

  # StnAccount.Transaction.withdraw(account, amount) tests:
  test "not enough funds to withdraw", %{account1: account} do
    assert_raise(ArgumentError, fn -> StnAccount.Transaction.withdraw(account, 10000) end)
  end

  # StnAccount.Transaction.withdraw(account, amount) tests:
  test "invalid withdraw amount", %{account1: account} do
    assert_raise(ArgumentError, fn -> StnAccount.Transaction.withdraw(account, 0) end)
  end

  # StnAccount.Transaction.deposit_foreign_currency(account, amount, currency, rate)
  test "deposit invalid amount", %{account1: account} do
    assert_raise(ArgumentError, fn ->
      StnAccount.Transaction.deposit_foreign_currency(account, 0, :USD, 5.2)
    end)
  end

  # StnAccount.Transaction.deposit_foreign_currency(account, amount, currency, rate)
  test "successful foreign currency deposit", %{account2: account} do
    account = StnAccount.Transaction.deposit_foreign_currency(account, 100, :USD, 5.2)
    assert(account.balance.amount == 620)
  end

  # StnAccount.Transaction.exchange(amount, currency, rate)
  test "invalid rate to exchange" do
    assert_raise(ArgumentError, fn -> StnAccount.Transaction.exchange(500, :USD, 0) end)
  end

  # StnAccount.Transaction.exchange(amount, currency, rate)
  test "successful exchange" do
    money = StnAccount.Transaction.exchange(500, :CAD, 3)
    assert(money.amount == 1500)
  end

  # StnAccount.Transaction.split_deposit(origin_account, dest_accounts, shares, amount)
  test "invalid list of accounts and shares", %{
    account1: origin_account,
    account2: account2,
    account3: account3,
    account4: account4
  } do
    assert_raise(ArgumentError, fn ->
      StnAccount.Transaction.split_deposit(
        origin_account,
        [account2, account3, account4],
        [0.25, 0.25, 0.25, 0.25],
        2000
      )
    end)
  end

  test "invalid sum of shares", %{
    account1: origin_account,
    account2: account2,
    account3: account3,
    account4: account4
  } do
    assert_raise(ArgumentError, fn ->
      StnAccount.Transaction.split_deposit(
        origin_account,
        [account2, account3, account4],
        [0.25, 0.25, 0.8],
        2000
      )
    end)
  end

  test "successful split deposit", %{
    account1: origin_account,
    account2: account2,
    account3: account3,
    account4: account4
  } do
    accounts =
      StnAccount.Transaction.split_deposit(
        origin_account,
        [account2, account3, account4],
        [0.25, 0.25, 0.5],
        2000
      )

      assert(Enum.at(accounts, 0).balance.amount == 600)
      assert(Enum.at(accounts, 1).balance.amount == 600)
      assert(Enum.at(accounts, 2).balance.amount == 1100)
  end
end
