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

async function addDeployment(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    const data = {
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
        alert("Invalid strategy. Please select a valid strategy.");
        return;
    }

    // Invio dei dati validati al server
    try {
        const response = await fetch('/deployment', {
            method: 'POST',
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
        console.error('Error in adding the deployment:', error);
    }
}

document.getElementById('addDeploymentForm').addEventListener('submit', addDeployment);
