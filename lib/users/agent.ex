defmodule Flightex.Users.Agent do
  alias Flightex.Users.User

  use Agent

  def start_link(_initial) do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{} = user), do: Agent.update(__MODULE__, fn x -> update_state(x, user) end)


  defp update_state(state, %User{cpf: cpf} = user) do
    Map.put(state, cpf, user)
  end

  def get(cpf), do: Agent.get(__MODULE__, fn x -> get_user(x, cpf) end)


  defp get_user(state, cpf) do
    case Map.get(state, cpf) do
      nil -> {:error, "User not found" }
      user -> {:ok, user}
    end
  end
end