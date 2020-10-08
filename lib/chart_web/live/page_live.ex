defmodule ChartWeb.PageLive do
  use ChartWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("next", _, socket) do
    {:noreply, socket |> push_event("points", %{points: get_points()})}
  end

  defp get_points, do: 1..7 |> Enum.map(fn _ -> :rand.uniform(100) end)
end
