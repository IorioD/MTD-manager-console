let nodesData = []; // Variabile globale per mantenere i dati dei nodi

async function fetchNodes() {
    try {
        const response = await fetch('/node/all');
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        nodesData = await response.json(); // Salva i dati dei nodi nella variabile globale
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
                <td>
                    <button class="btn btn-warning edit-button" data-id="${node.id}">Edit</button>
                    <button class="btn btn-danger delete-button" data-id="${node.id}">Delete</button>
                </td>
            `;
            tableBody.appendChild(row);
        });

        addEventListeners();

    } catch (error) {
        console.error('Error in fetching the nodes:', error);
        // Gestisci l'errore appropriatamente
    }
}

function addEventListeners() {
    document.querySelectorAll('.edit-button').forEach(button => {
        button.addEventListener('click', function() {
            editNode(this.getAttribute('data-id'));
        });
    });

    document.querySelectorAll('.delete-button').forEach(button => {
        button.addEventListener('click', function() {
            deleteNode(this.getAttribute('data-id'));
        });
    });

    document.getElementById('addNodeButton').addEventListener('click', function() {
        window.location.href = 'add-node.html';
    });
}

async function deleteNode(id) {

    const node = nodesData.find(n => n.id.toString() === id.toString());
    if (!node) {
        console.error('Node not found');
        return;
    }

    if (!confirm(`Confirm ${node.ipAddress} removal?`)) {
        return;
    }
    try {
        const response = await fetch(`/node/${id}`, {
            method: 'DELETE'
        });
        if (!response.ok) {
            throw new Error(`Errore HTTP: ${response.status}`);
        }
        
        fetchNodes();
    
    } catch (error) {
        console.error('Error in deleting the node:', error);
    }
}

function editNode(id) {
    window.location.href = `edit-node.html?id=${id}`;
}

document.addEventListener('DOMContentLoaded', fetchNodes);
