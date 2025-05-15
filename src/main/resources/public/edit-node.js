let originalIpAddress = null;

async function getNodeById(id) {
    try {
        const response = await fetch(`/node/${id}`);
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error('Error in fetching the node:', error);
    }
}

async function loadNodeData() {
    const urlParams = new URLSearchParams(window.location.search);
    const nodeId = urlParams.get('id');
    if (!nodeId) {
        console.error('Node ID not found in the URL');
        return;
    }
    const node = await getNodeById(nodeId);
    if (node) {
        document.getElementById('hostname').value = node.hostname;
        document.getElementById('ipAddress').value = node.ipAddress;
        document.getElementById('role').value = node.role;
        document.getElementById('type').value = node.type;
        document.getElementById('available').value = node.available;
        originalIpAddress = node.ipAddress;
    }
}

async function isIPAddressUnique(ip) {
    try {
        const response = await fetch(`/node/check-ip?ip=${encodeURIComponent(ip)}`);
        if (!response.ok) throw new Error('Failed to check IP uniqueness');
        const result = await response.json();
        return result.unique === true;
    } catch (error) {
        console.error('Error checking IP uniqueness:', error);
        return false; // Per sicurezza blocca l’invio se fallisce
    }
}

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

async function updateNode(event) {
    event.preventDefault();
    const urlParams = new URLSearchParams(window.location.search);
    const nodeId = urlParams.get('id');
    const formData = new FormData(event.target);
    const data = {
        id: nodeId,
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

    if (data.ipAddress !== originalIpAddress) {
        const unique = await isIPAddressUnique(data.ipAddress);
        if (!unique) {
            alert("IP Address already exists. Please provide a unique IP.");
            return;
        }
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

    // Invio dati validati al server
    try {
        const response = await fetch('/node', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        window.location.href = 'nodes.html';
    } catch (error) {
        console.error('Error in updating the node:', error);
    }
}

document.addEventListener('DOMContentLoaded', loadNodeData);
document.getElementById('editNodeForm').addEventListener('submit', updateNode);
