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

    iex> StnAccount.create("85718312036")

  """
  def create(tax_id) do
    unless is_binary(tax_id) && String.length(tax_id) == 11 do
      raise(ArgumentError, message: "Invalid CPF.")
    end

    balance = Money.new(0, :BRL)

    %{tax_id: tax_id, balance: balance, transactions: []}
  end
end
