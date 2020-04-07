# StnAccount - a financial system. [![Build Status](https://travis-ci.org/asmutti/elixir-banking.svg?branch=master)](https://travis-ci.org/asmutti/elixir-banking) [![Coverage Status](https://coveralls.io/repos/github/asmutti/elixir-banking/badge.svg?branch=master)](https://coveralls.io/github/asmutti/elixir-banking?branch=master)

The StnAccount is a software that can create accounts and handle various types of transactions, including exchange transactions and split deposits. All accounts created by the system are BRL accounts. The account supports deposit of foreign currencies, providing its exchange rate at the moment of the deposit.

The project is part of `some company` hiring process.

## Project

The project uses a dependency in its core, called Money. The library that handles the creation of the [Money](https://github.com/elixirmoney/money) attribute of every StnAccount. Travis handles the continuous integration. The library Money is the solution deal with transactions in compliance to the [ISO 4217](https://pt.wikipedia.org/wiki/ISO_4217) as requested as requirement.

There are two structs definied in the project, account and transaction. Account has an unique identifier called tax_id, which translates into the CPF in Brazil or SSN in US. Account has also an amount, which is a Money struct and also an collection of transactions.

Every account has a collection of transactions. Every transaction has a uuid, date, amount and type. Every transaction is added to the collection in the Account struct.

## Usage

You need Elixir installed on you system. [Elixir Installation](https://elixir-lang.org/install.html)

After downloading the project run:
`mix deps.get`

After all dependencies are installed, you can run all the commands listed down:

`mix docs` to generate the project documentation.
`iex -S mix` to run in an interactive mode.
`mix test` to run all the unit tests.
`mix coveralls` to run the unit tests with an analisys on the coverage.
`mix coveralls.html` also to run unit testes with detailed analisys in a generated html page.

## Dependencies

* [uuid](https://github.com/zyro/elixir-uuid)
* [Money](https://github.com/elixirmoney/money)
* [ExDoc](https://github.com/elixir-lang/ex_doc)
* [ExCoveralls](https://github.com/parroty/excoveralls)


## Resources

* [Elixir Docs](https://elixir-lang.org/docs.html)
* [Elixir School](https://elixirschool.com/pt/)
* [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/course/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/)
* [Getting Started with Elixir](https://app.pluralsight.com/library/courses/elixir-getting-started/table-of-contents)
* [Money Documentation](https://hexdocs.pm/money/Money.html)
* [Stackoverflow](https://stackoverflow.com/search?q=elixir)



