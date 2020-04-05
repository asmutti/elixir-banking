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
      iex> new_balance = StnAccount.Transaction.deposit(50, account)
      iex> new_balance.balance
      %Money{amount: 50, currency: :BRL}

    """
    def deposit(amount, account) do
      unless amount > 0 do
        raise(ArgumentError, message: "The amount to deposit should be higher than zero.")
      end

      transaction = create_transaction(amount)

      account
      |> Map.put(:balance, Money.add(account.balance, transaction.amount))
      |> Map.put(:transactions, account.transactions ++ [transaction])
    end
end
