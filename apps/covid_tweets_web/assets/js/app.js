// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import 'bootstrap';
import {Socket} from "phoenix"
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")




// ----- Chart.js Graph, graph doesn't render -----
let hooks = {}
hooks.covid_chart = {
    mounted() {
        var ctx = this.el.getContext('2d');
                var chart = new Chart(ctx, {
            // The type of chart we want to create
            type: 'line',
            // The data for our dataset
            data: {
                labels: [],
                datasets: [{
                    label: 'Daily Covid Case Count',
                    yAxisID: 'covid',
                    backgroundColora: 'rgb(255, 99, 132, 0.2)',
                    borderColor: 'rgb(255, 99, 132)',
                    data: []
                },
                {
                    label: 'Daily Covid Tweet Count',
                    yAxisID: 'tweets',
                    backgroundColor: 'rgba(255, 132, 99, 0.2)',
                    borderColor: 'rgb(255, 132, 99)',
                    data: []
                }]
            },
            // Configuration options go here
            options: {
                scales: {
                  yAxes: [{
                    id: 'covid',
                    type: 'linear',
                    position: 'left',
                    scaleLabel: {
                      display: true,
                      labelString: 'Daily Covid Case Count'
                    }
                  }, {
                    id: 'tweets',
                    type: 'linear',
                    position: 'right',
                    scaleLabel: {
                      display: true,
                      labelString: 'Daily Covid Tweet Count'
                    }
                  }]
                }
              }
        });

        this.handleEvent("update_covid_chart", ({dates, covid_counts, tweet_counts}) => {
            chart.data.labels = dates
            chart.data.datasets[0].data = covid_counts;
            chart.data.datasets[1].data = tweet_counts;
            chart.update();
        })
    }
}

hooks.vaccine_chart = {
    mounted() {
        var ctx = this.el.getContext('2d');
        var chart = new Chart(ctx, {
            // The type of chart we want to create
            type: 'line',
            // The data for our dataset
            data: {
                labels: [],
                datasets: [{
                    label: 'Daily Number of Administered Vaccines',
                    yAxisID: 'vaccines',
                    backgroundColora: 'rgb(132, 99, 255, 0.2)',
                    borderColor: 'rgb(132, 99, 255)',
                    data: []
                },
                {
                    label: 'Daily Vaccine Tweet Count',
                    yAxisID: 'tweets',
                    backgroundColor: 'rgba(99, 132, 255, 0.2)',
                    borderColor: 'rgb(99, 132, 255)',
                    data: []
                }]
            },
            // Configuration options go here
            options: {
                scales: {
                  yAxes: [{
                    id: 'vaccines',
                    type: 'linear',
                    position: 'left',
                    scaleLabel: {
                      display: true,
                      labelString: 'Daily Number of Administered Vaccines'
                    }
                  }, {
                    id: 'tweets',
                    type: 'linear',
                    position: 'right',
                    scaleLabel: {
                      display: true,
                      labelString: 'Daily Vaccine Tweet Count'
                    }
                  }]
                }
              }
        });

        this.handleEvent("update_vaccine_chart", ({dates, vaccine_counts, tweet_counts}) => {
            chart.data.labels = dates;
            chart.data.datasets[0].data = vaccine_counts;
            chart.data.datasets[1].data = tweet_counts;
            chart.update();
        })
    }
}
// --- End of Graph.js code --- 


let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

liveSocket.enableDebug()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
