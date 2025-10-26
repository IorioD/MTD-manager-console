// Mapping object for strategy descriptions
const strategyDescriptions = {
    1: 'Changes the IP of the pod for the<br>selected deployment making it restart',
    2: 'Creates a new replica of the pod<br>for the selected deployment',
    3: 'Migrate the pod of the selected<br>deployment to another worker node',
    4: 'Changes the Service Account of the pod<br>for the selected deployment',
    // Add more descriptions based on the strategy IDs
};

let dataTableInstance = null;

async function fetchStrategies() {
    try {
        const response = await fetch('/strategy/all');
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status} - ${response.statusText}`);
        }
        const strategyData = await response.json();
        renderTable(strategyData);

    } catch (error) {
        console.error('Error in fetching the strategies:', error);
    }
}

function renderTable(strategyData) {
    const strategyList = document.getElementById('strategyTableBody');

        strategyList.innerHTML = '';
    
        strategyData.forEach(strategy => {

            const description = strategyDescriptions[strategy.id] || 'Description unavailable';

            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${strategy.name}</td>
                <td>${description}</td>
                <td>${strategy.enabled ? 'Enabled' : 'Disabled'}</td>
                <td>
                <button class="${strategy.enabled ? 'disable-button' : 'enable-button'}"
                        data-id="${strategy.id}" data-enabled="${!strategy.enabled}">
                        ${strategy.enabled ? 'Disable' : 'Enable'}
                </button>
                </td>
            `;
            strategyList.appendChild(row);
        });

        document.querySelectorAll('.enable-button, .disable-button').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const enabled = this.getAttribute('data-enabled') === 'true';
                toggleStrategy(id, enabled);
            });
        });

        if (dataTableInstance) {
        dataTableInstance.destroy(); // avoid duplications
    }
    dataTableInstance = $('#strategyTable').DataTable({
        pageLength: 10,
        lengthChange: false,
        order: [[0, 'asc']], // default strategy name order
        language: {
            search: "Search strategy name:",
            paginate: {
                previous: "Previous",
                next: "Next"
            },
            info: "Showing _START_–_END_ of _TOTAL_ strategies",
            infoEmpty: "No strategies found",
            zeroRecords: "No matching records found"
        }
    });
}

async function toggleStrategy(id, enabled) {
    try {
        const response = await fetch(`/strategy/enable/${id}?enabled=${enabled}`, {
            method: 'PUT'
        });
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status} - ${response.statusText}`);
        }
        // Reload the strategies list after changing the state
        fetchStrategies();
        
    } catch (error) {
        console.error(`Error in editing the strategy ${id}:`, error);
        alert(`Error in editing strategy state ${id}: ${error.message}`);
    }
}

// Load strategies on page load
fetchStrategies();

document.addEventListener('DOMContentLoaded', fetchStrategies);