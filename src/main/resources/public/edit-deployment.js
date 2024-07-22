async function getDeploymentById(id) {
    try {
        const response = await fetch(`/deployment/${id}`);
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error('Error in fetching the deployment:', error);
    }
}

async function loadDeploymentData() {
    const urlParams = new URLSearchParams(window.location.search);
    const deploymentId = urlParams.get('id');
    if (!deploymentId) {
        console.error('Deployment ID not found in the URL');
        return;
    }
    const deployment = await getDeploymentById(deploymentId);
    if (deployment) {
        document.getElementById('name').value = deployment.name;
        document.getElementById('namespace').value = deployment.namespace;
        document.getElementById('type').value = deployment.type;
        document.getElementById('strategy').value = deployment.strategy;
    }
}

function isValidName(name) {
    return typeof name === 'string' && name.trim() !== '';
}

function isValidNamespace(namespace) {
    return typeof namespace === 'string' && namespace.trim() !== '';
}

function isValidType(type) {
    const validTypes = ['edge', 'cloud'];
    return validTypes.includes(type);
}

function isValidStrategy(strategy) {
    const validStrategies = ['1', '2', '3', '4'];
    return validStrategies.includes(strategy);
}

async function updateDeployment(event) {
    event.preventDefault();
    const urlParams = new URLSearchParams(window.location.search);
    const deploymentId = urlParams.get('id');
    const formData = new FormData(event.target);
    const data = {
        id: deploymentId,
        name: formData.get('name'),
        namespace: formData.get('namespace'),
        type: formData.get('type'),
        strategy: formData.get('strategy')
    };

    // Validazione inserimenti
    if (!isValidName(data.name)) {
        alert("Name must not be empty.");
        return;
    }

    if (!isValidNamespace(data.namespace)) {
        alert("Invalid namespace.");
        return;
    }

    if (!isValidType(data.type)) {
        alert("Invalid Type. Chose between 'edge' or 'cloud'.");
        return;
    }

    if (!isValidStrategy(data.strategy)) {
        alert("Invalid strategy. Please select a valid strategy (between 1 and 4).");
        return;
    }

    // Invio dati validati al server
    try {
        const response = await fetch('/deployment', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        window.location.href = 'deployment.html';
    } catch (error) {
        console.error('Error in updating the deployment:', error);
    }
}

document.addEventListener('DOMContentLoaded', loadDeploymentData);
document.getElementById('editDeploymentForm').addEventListener('submit', updateDeployment);
