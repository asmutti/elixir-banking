defmodule StnAccount do
  @moduledoc """
  Documentation for StnAccount.
  """

  defstruct [:tax_id, :balance, :transactions]

  @type t :: %__MODULE__{
          tax_id: String.t(),
          balance: Money.t(),
          transactions: []
        }

  @doc """
  Creates a new BRL account.

  ## Examples

    iex> account = StnAccount.create("85718312036")
    iex> account
    %{balance: %Money{amount: 0, currency: :BRL}, tax_id: "85718312036", transactions: []}

  """
  def create(tax_id) do
    unless is_binary(tax_id) do
      raise(ArgumentError, message: "User has to provide a CPF.")
    end

    unless String.length(tax_id) == 11 && check_cpf(tax_id) do
      raise(ArgumentError, message: "Invalid CPF.")
    end

    balance = Money.new(0, :BRL)

    %{tax_id: tax_id, balance: balance, transactions: []}
  end

  defp check_cpf(cpf) do
    Regex.match?(~r{\A\d*\z}, cpf)
  end

  @doc """
    Creates a new account and immediately deposits an inital amount.

    ## Examples
      iex> account = StnAccount.create_and_deposit("85718312036", 500)
      iex> account.balance
      %Money{amount: 500, currency: :BRL}
  """
  def create_and_deposit(tax_id, initial_amount) do
    create(tax_id)
    |> StnAccount.Transaction.deposit(initial_amount)
  end

  @doc """
  Returns the current account balance from a given account.

  ## Examples
    iex> account = StnAccount.create("85718312036")
    iex> balance = StnAccount.get_balance(account)
    iex> balance
    0

  """
  @spec get_balance(map) :: any
  def get_balance(account) do
    Map.get(account, :balance)
    |> Map.get(:amount)
  end
end
