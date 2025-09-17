let deploymentData = []; // Variabile globale per mantenere i dati dei nodi

async function fetchDeployments() {
    try {
        const response = await fetch('/deployment/all'); // Assicurati che l'endpoint sia corretto
        if (!response.ok) {
            throw new Error(`Errore HTTP: ${response.status}`);
        }
        deploymentData = await response.json();
        const tableBody = document.getElementById('deploymentTableBody');
        tableBody.innerHTML = '';
        deploymentData.forEach(deployment => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${deployment.name}</td>
                <td>${deployment.namespace}</td>
                <td>${deployment.type}</td>
                <td></td>
                <td>
                    <div class="slide-button" data-id="${deployment.id}" data-enabled="${deployment.enabled}">
                        <div class="slider" id="slider_${deployment.id}"></div>
                    </div>
                </td>
                <td>
                    <button class="btn btn-warning edit-button" data-id="${deployment.id}">Edit</button>
                    <button class="btn btn-danger delete-button" data-id="${deployment.id}">Delete</button>
                </td>
            `;
            const select = document.createElement('select');
            select.addEventListener('change', function() {
                updateStrategy(deployment.id, this.value);
            });
            select.innerHTML = `
                <option value="1" ${deployment.strategy === 1 ? 'selected' : ''}>IP Shuffling</option>
                <option value="2" ${deployment.strategy === 2 ? 'selected' : ''}>Dynamic Pod Replica</option>
                <option value="3" ${deployment.strategy === 3 ? 'selected' : ''}>Node Migration</option>
                <option value="4" ${deployment.strategy === 4 ? 'selected' : ''}>Service Account Shuffling</option>
            `;
            row.children[4].appendChild(select); // Aggiunge il select alla quinta colonna della riga
            tableBody.appendChild(row);
        });

        addEventListeners(); // Aggiungi gli event listeners dopo aver creato gli elementi

    } catch (error) {
        console.error('Errore nel recupero dei deployment:', error);
        // Gestisci l'errore in modo appropriato
    }
}

async function toggleEnabled(id) {
    try {
        const response = await fetch(`/deployment/${id}/toggle`, {
            method: 'PATCH',
        });
        if (!response.ok) {
            throw new Error(`Errore HTTP: ${response.status}`);
        }

        const deployment = deploymentData.find(dep => dep.id == id);
        if (!deployment) {
            throw new Error(`Deployment not found with ID: ${id}`);
        }

        const slider = document.getElementById(`slider_${id}`);
        if (!slider) {
            throw new Error(`Slider element not found for ID: slider_${id}`);
        }

        // Inverti lo stato corrente del deployment
        deployment.enabled = !deployment.enabled;
        slider.style.left = deployment.enabled ? '50%' : '0';

        const message = deployment.enabled ? `MTD enabled for ${deployment.name}` : `MTD disabled for ${deployment.name}`;
        alert(message);

        fetchDeployments(); // Aggiorna l'elenco dei deployment dopo l'aggiornamento

    } catch (error) {
        console.error('Errore nel toggle dell\'abilitazione MTD:', error);
        // Gestisci l'errore in modo appropriato
    }
}

function addEventListeners() {
    document.querySelectorAll('.edit-button').forEach(button => {
        button.addEventListener('click', function() {
            editDeployment(this.getAttribute('data-id'));
        });
    });

    document.querySelectorAll('.delete-button').forEach(button => {
        button.addEventListener('click', function() {
            deleteDeployment(this.getAttribute('data-id'));
        });
    });

    document.getElementById('addDeploymentButton').addEventListener('click', function() {
        window.location.href = 'add-deployment.html';
    });

    document.querySelectorAll('.slide-button').forEach(slideButton => {
        slideButton.addEventListener('click', () => {
            const id = slideButton.getAttribute('data-id');
            toggleEnabled(id);
        });
    });
}

async function updateStrategy(id, strategy) {
    try {
        const response = await fetch(`/deployment/${id}/strategy?strategy=${strategy}`, {
            method: 'PUT',
        });
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }

        // Mostra un messaggio di conferma
        alert('Strategy updated successfuly');

        // Aggiorna la tabella dopo aver aggiornato la strategia
        fetchDeployments();
    } catch (error) {
        console.error('Error in adding the strategy:', error);
    }
}

async function deleteDeployment(id) {
    
    const deployment = deploymentData.find(n => n.id.toString() === id.toString());
      
    if (!deployment) {
        console.error('Deployment not found');
        return;
    }

    if (!confirm(`Confirm ${deployment.name} removal?`)) {
        return;
    }
    try {
        const response = await fetch(`/deployment/${id}`, {
            method: 'DELETE'
        });
        if (!response.ok) {
            throw new Error(`Errore HTTP: ${response.status}`);
        }
        
        fetchDeployments();
    
    } catch (error) {
        console.error('Error in deleting the deployment:', error);
    }
}

function editDeployment(id) {
    window.location.href = `edit-deployment.html?id=${id}`;
}

// Inizializza la tabella dei deployment al caricamento della pagina
document.addEventListener('DOMContentLoaded', fetchDeployments);
