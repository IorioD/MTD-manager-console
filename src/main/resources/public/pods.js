let podData = [];
let dataTableInstance = null;

async function fetchPods() {
    try {
        const response = await fetch('/pods/all');
        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }
        podData = await response.json();
        renderTable();

    } catch (error) {
        console.error('Error in fetching pods:', error);
    }
}

function renderTable() {
    const tableBody = document.getElementById('podTableBody');
        
    tableBody.innerHTML = '';

    podData.forEach(pod => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${pod.name}</td>
            <td>${pod.podIp}</td>
            <td>${pod.namespace}</td>
            <td>${pod.type}</td>
            <td>${pod.status}</td>
            <td>${pod.nodeName}</td>
            <td>
                <div class="slide-button" data-id="${pod.id}" data-enabled="${pod.enabled}">
                    <div class="slider" id="slider_${pod.id}"></div>
                </div>
            </td>
        `;
        tableBody.appendChild(row);
    });

    addEventListeners();

    if (dataTableInstance) {
        dataTableInstance.destroy(); // avoid duplications
    }
    dataTableInstance = $('#podsTable').DataTable({
        pageLength: 10,
        lengthChange: false,
        order: [[0, 'asc']], // default pod name order
        language: {
            search: "Search pod name:",
            paginate: {
                previous: "Previous",
                next: "Next"
            },
            info: "Showing _START_–_END_ of _TOTAL_ pods",
            infoEmpty: "No pods found",
            zeroRecords: "No matching records found"
        }
    });
}

async function toggleEnabled(id) {
    try {
        const response = await fetch(`/pods/${id}/toggle`, {
            method: 'PATCH',
        });
        if (!response.ok) {
            throw new Error(`Errore HTTP: ${response.status}`);
        }

        const pod = podData.find(pod => pod.id == id);
        if (!pod) {
            throw new Error(`Pod not found with ID: ${id}`);
        }

        const slider = document.getElementById(`slider_${id}`);
        if (!slider) {
            throw new Error(`Slider element not found for ID: slider_${id}`);
        }

        pod.enabled = !pod.enabled;
        slider.style.left = pod.enabled ? '50%' : '0';

        const message = pod.enabled ? `MTD enabled for ${pod.name}` : `MTD disabled for ${pod.name}`;
        alert(message);

        fetchPods();

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

document.addEventListener('DOMContentLoaded', fetchPods);
