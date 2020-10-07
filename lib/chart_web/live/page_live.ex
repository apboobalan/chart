defmodule ChartWeb.PageLive do
  use ChartWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    schedule_update()
    {:ok, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    schedule_update()
    {:noreply, socket |> push_event("points", %{points: get_points()})}
  end

  defp schedule_update, do: self() |> Process.send_after(:update, 2000)
  defp get_points, do: 1..7 |> Enum.map(fn _ -> :rand.uniform(100) end)
end
