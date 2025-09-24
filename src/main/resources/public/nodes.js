let nodesData = [];

async function fetchNodes() {
    try {
        const response = await fetch('/node/all');
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        nodesData = await response.json();
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

        addEventListeners();

    } catch (error) {
        console.error('Error in fetching the nodes:', error);
    }
}

document.addEventListener('DOMContentLoaded', fetchNodes);
