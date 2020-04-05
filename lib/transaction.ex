defmodule StnAccount.Transaction do
  @moduledoc """
  Documentation for Transaction module.
  """

  defstruct [:id, :amount, :date]

    @typedoc "Custom type to represent transfers."
    @type t :: %__MODULE__{
      id: UUID.t(),
      amount: Money.t(),
      date: NaiveDateTime.t()
    }

    defp create_transaction(amount) do
      %{id: UUID.uuid1(), amount: Money.new(amount, :BRL), date: NaiveDateTime.utc_now()}
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

      transaction = create_transaction(amount)

      account
      |> Map.put(:balance, Money.add(account.balance, transaction.amount))
      |> Map.put(:transactions, account.transactions ++ [transaction])
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

      origin_transaction = create_transaction(-amount)
      dest_transaction = create_transaction(amount)

      origin_account
      |> Map.put(:balance, Money.add(origin_account.balance, origin_transaction.amount))
      |> Map.put(:transactions, origin_account.transactions ++ [origin_transaction])

      dest_account
      |> Map.put(:balance, Money.add(dest_account.balance, dest_transaction.amount))
      |> Map.put(:transactions, dest_account.transactions ++ [dest_transaction])

    end
end
