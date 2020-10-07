# Phoenix LiveView Chart.js setup gist
- mix phx.new chart --live --no-ecto
- y
- code chart
- lib > chart_web > live > page_live.ex
- lib > chart_web > live > page_live.html.leex
- lib > chart_web > templates > layout > root.html.leex
	-   `<h1>Phoenix LiveView Chart.js</h1>`
-   mix phx.server
-   https://www.chartjs.org/docs/latest/getting-started/
-   `<canvas id="myChart"></canvas><script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>`
-   assets > js > app.js
```javascript 
var ctx = document.getElementById('myChart').getContext('2d');
var chart = new Chart(ctx, {
    // The type of chart we want to create
    type: 'line',

    // The data for our dataset
    data: {
        labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
        datasets: [{
            label: 'My First dataset',
            backgroundColor: 'rgb(255, 99, 132)',
            borderColor: 'rgb(255, 99, 132)',
            data: [0, 10, 5, 2, 20, 30, 45]
        }]
    },

    // Configuration options go here
    options: {}
});
```
-	`unknown hook found for "chart" 
<canvas id="myChart" phx-hook="chart">`
- https://hexdocs.pm/phoenix_live_view/js-interop.html
```javascript
let hooks = {}
hooks.chart = {
    mounted() {
        var ctx = this.el.getContext('2d');
        var chart = new Chart(ctx, {
            // The type of chart we want to create
            type: 'line',
        
            // The data for our dataset
            data: {
                labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                datasets: [{
                    label: 'My First dataset',
                    backgroundColor: 'rgb(255, 99, 132)',
                    borderColor: 'rgb(255, 99, 132)',
                    data: [0, 10, 5, 2, 20, 30, 45]
                }]
            },
        
            // Configuration options go here
            options: {}
        });
    }
}

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})
```
- https://www.chartjs.org/docs/latest/developers/updates.html

```javascript
this.handleEvent("points", ({points}) => {
	chart.data.datasets[0].data = points
	chart.update()
})
```

```elixir
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
    {:noreply, socket |> push_event("points", %{points: get_points})}
  end

  defp schedule_update, do: self() |> Process.send_after(:update, 2000)
  defp get_points, do: 1..7 |> Enum.map(fn _ -> :rand.uniform(100) end)
end
```