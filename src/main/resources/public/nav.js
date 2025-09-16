document.addEventListener('DOMContentLoaded', function() {
    // Gestore per il pulsante di apertura della sidebar
    document.querySelector('.openbtn').addEventListener('click', openNav);

    // Gestore per il pulsante di chiusura della sidebar
    document.querySelector('.closebtn').addEventListener('click', closeNav);

    // Prevenire il comportamento predefinito dei link con #
    document.querySelectorAll('.sidebar a').forEach(function(element) {
        element.addEventListener('click', function(event) {
            if (this.getAttribute('href') === '#') {
                event.preventDefault();
            }
        });
    });

    // Chiamata iniziale per recuperare i dati
    fetchClusterInfo();

    // Imposta il refresh automatico ogni 10 secondi
    setInterval(fetchClusterInfo, 10000);

});

function openNav() {
    document.getElementById("mySidebar").style.width = "250px";
    document.querySelector(".container").style.marginLeft = "270px";
}

function closeNav() {
    document.getElementById("mySidebar").style.width = "0";
    document.querySelector(".container").style.marginLeft = "20px";
}

function fetchClusterInfo() {
    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                const data = JSON.parse(xhr.responseText);
                const clusterDataContainer = document.getElementById('cluster-data');
                const nodeInfoContainer = document.getElementById('node-info');
                const nodeMetricsContainer = document.getElementById('node-metrics');

                // Genera la tabella per info cluster
                let clusterHtmlContent = `
                    <div class="table-title">Cluster Info</div>
                    <table>
                        <tr>
                            <th>Name</th>
                            <td>${data.name || 'N/D'}</td>
                        </tr>
                        <tr>
                            <th>API Version</th>
                            <td>${data.apiVersion || 'N/D'}</td>
                        </tr>
                        <tr>
                            <th>Cluster Nodes Number</th>
                            <td>${data.nodeCount || 'N/D'}</td>
                        </tr>
                    </table>
                `;

                // Genera una tabella per info nodi
                let nodeInfoHtmlContent = `
                    <div class="table-title">Node Info</div>
                    <table class="node-info">
                        <thead>
                            <tr>
                                <th>Node Name</th>
                                <th>Architecture</th>
                                <th>Operating System</th>
                            </tr>
                        </thead>
                        <tbody>
                `;

                // Genera una tabella per metriche nodi
                let nodeMetricsHtmlContent = `
                    <div class="table-title">Node Metrics</div>
                    <table class="node-info">
                        <thead>
                            <tr>
                                <th>Node Name</th>
                                <th>CPU Usage (%)</th>
                                <th>Memory Usage (%)</th>
                                <th>Disk Usage (%)</th>
                            </tr>
                        </thead>
                        <tbody>
                `;

                for (const [nodeName, nodeInfo] of Object.entries(data.nodeInfoMap)) {
                    const metrics = data.nodeMetricsMap[nodeName] || {};
                    nodeInfoHtmlContent += `
                        <tr>
                            <td>${nodeName}</td>
                            <td>${nodeInfo.architecture || 'N/D'}</td>
                            <td>${nodeInfo.operatingSystem || 'N/D'}</td>
                        </tr>
                    `;
                    nodeMetricsHtmlContent += `
                        <tr>
                            <td>${nodeName}</td>
                            <td>${metrics.cpuUsage || 'N/D'}</td>
                            <td>${metrics.memUsage || 'N/D'}</td>
                            <td>${metrics.diskUsage|| 'N/D'}</td>
                        </tr>
                    `;
                }

                nodeInfoHtmlContent += `
                        </tbody>
                    </table>
                `;

                nodeMetricsHtmlContent += `
                        </tbody>
                    </table>
                `;

                clusterDataContainer.innerHTML = clusterHtmlContent;
                nodeInfoContainer.innerHTML = nodeInfoHtmlContent;
                nodeMetricsContainer.innerHTML = nodeMetricsHtmlContent;


            } else {
                console.error('HTTP Error:', xhr.status, xhr.statusText);
                document.getElementById('cluster-data').innerText = 'Error in fetching cluster info: connection interrupted.';
            }
        }
    };
    xhr.open('GET', '/cluster/info');
    xhr.send();
}
