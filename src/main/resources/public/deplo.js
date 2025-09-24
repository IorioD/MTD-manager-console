let deploymentData = [];

async function fetchDeployments() {
    try {
        const response = await fetch('/deployment/all');
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
                <td>${deployment.podIp}</td>
                <td>${deployment.namespace}</td>
                <td>${deployment.type}</td>
                <td>${deployment.status}</td>
                <td>${deployment.nodeName}</td>
                <td></td>
                <td>
                    <div class="slide-button" data-id="${deployment.id}" data-enabled="${deployment.enabled}">
                        <div class="slider" id="slider_${deployment.id}"></div>
                    </div>
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
            row.children[6].appendChild(select);
            tableBody.appendChild(row);
        });

        addEventListeners();

    } catch (error) {
        console.error('Error in fetching deployments:', error);
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

        fetchDeployments();

    } catch (error) {
        console.error('Error in toggling MTD enablement:', error);
    }
}

function addEventListeners() {
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

        alert('Strategy updated successfuly');

        fetchDeployments();
    } catch (error) {
        console.error('Error in adding the strategy:', error);
    }
}

document.addEventListener('DOMContentLoaded', fetchDeployments);
