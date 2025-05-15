function isValidHostname(hostname) {
    return typeof hostname === 'string' && hostname.trim() !== '';
}

function isValidIPAddress(ipAddress) {
    const ipPattern = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    return ipPattern.test(ipAddress);
}

function isValidRole(role) {
    const validRoles = ['worker', 'master', 'edge'];
    return validRoles.includes(role);
}

function isValidType(type) {
    const validTypes = ['edge', 'cloud'];
    return validTypes.includes(type);
}

function isValidAvailable(available) {
    return available === 'true' || available === 'false';
}

async function isIPAddressUnique(ip) {
    try {
        const response = await fetch(`/api/nodes/check-ip?ip=${encodeURIComponent(ip)}`);
        if (!response.ok) throw new Error('Failed to check IP uniqueness');
        const result = await response.json();
        return result.unique === true;
    } catch (error) {
        console.error('Error checking IP uniqueness:', error);
        return false; // Per sicurezza blocca l’invio se fallisce
    }
}

async function addNode(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    const data = {
        hostname: formData.get('hostname'),
        ipAddress: formData.get('ipAddress'),
        role: formData.get('role'),
        type: formData.get('type'),
        available: formData.get('available')
    };

    // Validazione inserimenti
    if (!isValidHostname(data.hostname)) {
        alert("Hostname must not be empty.");
        return;
    }

    if (!isValidIPAddress(data.ipAddress)) {
        alert("Invalid IP Address.");
        return;
    }

    const unique = await isIPAddressUnique(data.ipAddress);
    if (!unique) {
        alert("IP Address already exists. Please provide a unique IP.");
        return;
    }

    if (!isValidRole(data.role)) {
        alert("Invalid Role. Chose between 'worker', 'master' or 'edge'.");
        return;
    }

    if (!isValidType(data.type)) {
        alert("Invalid Type. Chose between 'edge' or 'cloud'.");
        return;
    }

    if (!isValidAvailable(data.available)) {
        alert("Available must be 'true' or 'false'.");
        return;
    }

    // Invio dei dati validati al server
    try {
        const response = await fetch('/node', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        if (!response.ok) {
            throw new Error(`Errore HTTP: ${response.status}`);
        }
        window.location.href = 'nodes.html';
    } catch (error) {
        console.error('Error in adding the node:', error);
    }
}

document.getElementById('addNodeForm').addEventListener('submit', addNode);
