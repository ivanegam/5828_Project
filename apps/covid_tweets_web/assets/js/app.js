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
import {Socket} from "phoenix"
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

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

        
        this.handleEvent("points", ({points}) => {
          chart.data.datasets[0].data = points
          chart.update()
        })
    }
}


// var ctx = document.getElementById('myChart').getContext('2d');
// window.alert(ctx);
// var chart = new Chart(ctx, {
//     // The type of chart we want to create
//     type: 'line',
//     // The data for our dataset
//     data: {
//         labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
//         datasets: [{
//             label: 'My First dataset',
//             backgroundColor: 'rgb(255, 99, 132)',
//             borderColor: 'rgb(255, 99, 132)',
//             data: [0, 10, 5, 2, 20, 30, 45]
//         }]
//     },
//     // Configuration options go here
//     options: {}
// });

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
// window.liveSocket = liveSocket