let nodesData = []; 
let dataTableInstance = null;

async function fetchNodes() {
    try {
        const response = await fetch('/node/all');
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        nodesData = await response.json();
        renderTable();

    } catch (error) {
        console.error('Error in fetching the nodes:', error);
    }
}

function renderTable() {
    const tableBody = document.getElementById('nodeTableBody');

    tableBody.innerHTML = '';

    nodesData.forEach(node => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${node.hostname}</td>
            <td>${node.ipAddress}</td>
            <td>${node.role}</td>
            <td>${node.type}</td>
            <td>${node.available}</td>
        `;
        tableBody.appendChild(row);
    });

    //addEventListeners();

    if (dataTableInstance) {
        dataTableInstance.destroy(); // avoid duplications
    }
    dataTableInstance = $('#nodesTable').DataTable({
        pageLength: 10,
        lengthChange: false,
        order: [[0, 'asc']], // default node name order
        language: {
            search: "Search node name:",
            paginate: {
                previous: "Previous",
                next: "Next"
            },
            info: "Showing _START_–_END_ of _TOTAL_ nodes",
            infoEmpty: "No nodes found",
            zeroRecords: "No matching records found"
        }
    });
}


document.addEventListener('DOMContentLoaded', fetchNodes);