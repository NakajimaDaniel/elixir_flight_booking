defmodule Flightex.Bookings.Agent do

  alias Flightex.Bookings.Booking

  use Agent

  def start_link(_initial) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking) do
    uuid = UUID.uuid4()
    Agent.update(__MODULE__, fn x -> update_state(x, booking, uuid) end)
    {:ok, uuid}
  end

  defp update_state(state, %Booking{} = booking, uuid) do
    Map.put(state, uuid, booking)
  end

  def get(uuid) do
    Agent.get(__MODULE__, fn x -> get_booking(x, uuid) end)
  end

defp get_booking(state, uuid) do
  case Map.get(state, uuid) do
    nil -> {:error, "Booking not found"}
    booking -> {:ok, booking}
  end

end

end

