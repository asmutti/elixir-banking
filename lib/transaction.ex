defmodule StnAccount.Transaction do
  @moduledoc """
  Documentation for Transaction module.
  """

  defstruct [:id, :amount, :date, :type]

    @typedoc "Custom type to represent transfers."
    @type t :: %__MODULE__{
      id: UUID.t(),
      amount: Money.t(),
      date: NaiveDateTime.t(),
      type: Atom.t()
    }

    defp create_transaction(amount, type) do
      unless amount != 0 && is_atom(type) do
        raise(ArgumentError, message: "invalid parameters.")
      end
      %{id: UUID.uuid1(), amount: Money.new(amount, :BRL), date: NaiveDateTime.utc_now(), type: type}
    end

  @doc """
    Deposits `money` into a given account. Appends a new transaction into
    the account struct.

    ## Examples

      iex> account = StnAccount.create("85718312036")
      iex> new_balance = StnAccount.Transaction.deposit(account, 50)
      iex> new_balance.balance
      %Money{amount: 50, currency: :BRL}

    """
    def deposit(account, amount) do
      unless amount > 0 do
        raise(ArgumentError, message: "The amount to deposit should be higher than zero.")
      end

      transaction = create_transaction(amount, :deposit)

      process_transaction(account, transaction)
    end

    @doc """
      Transfers money from `origin_account` to `dest_account` if `origin_account`
      has enough funds to transfer.

      ## Examples

        iex> account_origin = StnAccount.create_and_deposit("85718312036", 500)
        iex> account_dest = StnAccount.create("98310751028")
        iex> account_dest = StnAccount.Transaction.transfer(account_origin, account_dest, 50)
        iex> account_dest.balance
        %Money{amount: 50, currency: :BRL}

    """
    def transfer(origin_account, dest_account, amount) do
      unless amount > 0 do
        raise(ArgumentError, message: "The amount to deposit should be higher than zero.")
      end

      unless StnAccount.get_balance(origin_account) > amount do
        raise(ArgumentError, message: "Not enough funds to transfer.")
      end

      origin_transaction = create_transaction(-amount, :transfer)
      dest_transaction = create_transaction(amount, :transfer)

      process_transaction(origin_account, origin_transaction)

      process_transaction(dest_account, dest_transaction)
    end

    defp process_transaction(account, transaction) do
      account
      |> Map.put(:balance, Money.add(account.balance, transaction.amount))
      |> Map.put(:transactions, account.transactions ++ [transaction])
    end

    @doc """
      Withdraws money from a given account.

      ## Examples

        iex> account = StnAccount.create_and_deposit("85718312036", 500)
        iex> account = StnAccount.Transaction.withdraw(account, 100)
        iex> account.balance
        %Money{amount: 400, currency: :BRL}

    """
    def withdraw(account, amount) do
      unless amount > 0 do
        raise(ArgumentError, "The amount to withdraw should be greater than zero.")
      end

      unless StnAccount.get_balance(account) >= amount do
        raise(ArgumentError, "The account does not have enough funds to withdraw.")
      end

      withdraw_transaction = create_transaction(-amount, :withdraw)

      process_transaction(account, withdraw_transaction)
    end

    @doc """
      Deposits an amount on foreign currency. The amount gets converted into
      :BRL currency and then deposited.

      @@ Examples

        iex> account = StnAccount.create_and_deposit("85718312036", 500)
        iex> account = StnAccount.Transaction.deposit_foreign_currency(account, 100, :USD, 5.3)
        iex> account.balance
        %Money{amount: 1030, currency: :BRL}
    """
    def deposit_foreign_currency(account, amount, currency, rate) do
      unless rate > 0 && amount > 0 && is_atom(currency) do
        raise(ArgumentError, message: "Wrong input.")
      end

      brl_amount = exchange(amount, currency, rate)

      exchange_transaction = create_transaction(brl_amount.amount, :exchange)

      process_transaction(account, exchange_transaction)
    end

    @doc """
      Exchanges a foreign currency into :BRL currency.

      ## Examples

        iex> usd_to_brl = StnAccount.Transaction.exchange(100, :USD, 5.3)
        iex> usd_to_brl.amount
        530
    """
    def exchange(amount, currency, rate) do
      foreign_amount = Money.new(amount, currency)

      brl_amount = Money.multiply(foreign_amount, rate)

      Money.new(brl_amount.amount, :BRL)
    end

        @doc """
      Method deposits an given amount to one or many accounts,
      each account needs an value `share` as the percentage of the total amount to be
      split.

      In case `origin_account` is nil, the function assumes that the money is originated from
      an external source.

      The `dest_account` is a list of accounts.
      The `shares` is a list of percentage shares.

      The number of `dest_account` and `shares` should be equal.
      The sum of all items in the `shares` list should be equal to 1.0.

      ## Examples

        iex> account1 = StnAccount.create_and_deposit("85718312036", 500)
        iex> account2 = StnAccount.create_and_deposit("85718312036", 500)
        iex> account_origin = StnAccount.create_and_deposit("85718312036", 2000)
        iex> accounts = StnAccount.Transaction.split_deposit(account_origin, [account1, account2], [0.4, 0.6], 2000)
        iex> account1 = Enum.at(accounts, 0)
        iex> account1.balance
        %Money{amount: 1300, currency: :BRL}
    """
    def split_deposit(origin_account, dest_accounts, shares, amount) when is_list(dest_accounts) do
      unless length(dest_accounts) == length(shares) do
        raise(ArgumentError, message: "The number of account should match the number of shares")
      end

      verify_shares(shares)

      if origin_account == nil do
        withdraw(origin_account, amount)
      end

      Enum.map(Enum.with_index(dest_accounts), fn {acc, s} -> StnAccount.Transaction.deposit(acc, round(amount * Enum.at(shares, s))) end)

    end

    defp verify_shares(shares) do
      unless Enum.sum(shares) == 1.0 do
        raise(ArgumentError, message: "The sum of all shares must be equal to one.")
      end
    end
end
