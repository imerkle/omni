# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :omni, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:omni, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

config :pbkdf2_elixir, :rounds, 1

config :omni,
    coins: 
        %{
        "BTC" => %{
            "api" => "https://insight.bitpay.com/api",
            "name" => "Bitcoin",
            "code" => 0,
            "decimals" => 8,
            "forks" => ["LTC", "DASH"],
            "base" => true,
            "network" => %{
                "versions" => %{
                    "private" => <<0x80>>,
                    "public" => <<0x00>>,
                }
            }
        },
        "LTC" => %{
            "api" => "https://insight.litecore.io/api",
            "name" => "Litecoin",
            "code" => 2,
            "decimals" => 8,
            "base" => false,
            "network" => %{
                "versions" => %{
                    "private" => <<0xb0>>,
                    "public" => <<0x30>>,
                }
            }
        },
        "DASH" => %{
            "api" => "https://insight.dash.org/api",
            "name" => "Dash",
            "code" => 5,
            "decimals" => 8,
            "base" => false,
            "network" => %{
                "versions" => %{
                    "private" => <<0xcc>>,
                    "public" => <<0x4c>>,
                }
            }
        },
        "ETH" => %{
            "api" => "https://api.etherscan.io/api",
            "api_tokens" => "https://tokenbalance.herokuapp.com/api/balance",
            "rpc" => "https://mainnet.infura.io/v3/2294f3b338ad4524aa9186012810e412",
            "name" => "Ethereum",
            "code" => 60,
            "decimals" => 18,
            "base" => true,
            "forks" => [],
        },
        "VET" => %{
            "api" => "https://veforge.com/api",
            "api_tokens" => "https://tokenbalance.herokuapp.com/api/balance",
            "name" => "Vechain",
            "code" => 818,
            "decimals" => 18,
            "base" => true,
            "forks" => [],
        },
        "EOS" => %{
            "api" => "https://api.neoscan.io/api/main_net/v1",
            "name" => "EOS",
            "code" => 194,
            "decimals" => 0,
            "base" => true,
            "forks" => [],
            "network" => %{
                "versions" => %{
                    "private" => <<0x80>>,
                    "public" => <<0x00>>,
                }
            }            
        },
        "NEO" => %{
            "api" => "https://api.neoscan.io/api/main_net/v1",
            "name" => "Neo",
            "code" => 888,
            "decimals" => 0,
            "base" => true,
            "forks" => [],
            "network" => %{
                "versions" => %{
                    "private" => <<0x80>>,
                    "public" => <<0x00>>,
                }
            }            
        },        
    }