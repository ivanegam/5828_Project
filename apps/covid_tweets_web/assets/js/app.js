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




// ----- Chart.js Graph, graph doesn't render -----
let hooks = {}
hooks.chart = {
    mounted() {
        var ctx = this.el.getContext('2d');
        var chart = new Chart(ctx, {
            // The type of chart we want to create
            type: 'line',
            // The data for our dataset
            data: {
                labels: [],
                datasets: [{
                    label: 'Dates',
                    backgroundColor: 'rgb(255, 99, 132)',
                    borderColor: 'rgb(255, 99, 132)',
                    data: []
                }]
            },
            // Configuration options go here
            options: {}
        });

        
        this.handleEvent("points", ({points}) => {
          chart.data.datasets[0].data = points
          chart.update()
        })



        function parseDate(str) {
            var yyyy_mm_dd = str.split('-');
            return new Date(yyyy_mm_dd[0], yyyy_mm_dd[1]-1, yyyy_mm_dd[2]);
        }

        Date.prototype.addDays = function(days) {
            var date = new Date(this.valueOf());
            date.setDate(date.getDate() + days);
            return date;
        }

        function getDates(startDate, stopDate) {
            var dateArray = new Array();
            var currentDate = startDate;
            while (currentDate <= stopDate) {
                dateArray.push(new Date (currentDate));
                currentDate = currentDate.addDays(1);
            }
            return dateArray;
        }



        this.handleEvent("dates", ({start_date, end_date}) => {
            var dates = getDates(parseDate(start_date), parseDate(end_date));
            var date_strings = new Array()
            for (var i = 0; i < dates.length; i++) {
                date_strings.push(dates[i].toDateString());
            }


            chart.data.labels = date_strings;//[...Array(array_test.length).keys()];//
            // chart.labels = [...Array(labels.length).keys()]
            chart.data.datasets[0].data = [...Array(date_strings.length).keys()]; //new Array(labels.length).fill(1);
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