// Mapping object for strategy descriptions
const strategyDescriptions = {
    1: 'Changes the IP of the pod for the<br>selected deployment making it restart',
    2: 'Creates a new replica of the pod<br>for the selected deployment',
    3: 'Migrate the pod of the selected<br>deployment to another worker node',
    4: 'Changes the Service Account of the pod<br>for the selected deployment',
    // Add more descriptions based on the strategy IDs
};

let dataTableInstance = null;

// Load strategies on page load
document.addEventListener('DOMContentLoaded', async () => {
    initDataTable();
    await fetchStrategies();
});


// initialize DataTable
function initDataTable() {
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

// fetch strategies from the db
async function fetchStrategies() {
    try {
        const response = await fetch('/strategy/all');
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status} - ${response.statusText}`);
        }
        const strategyData = await response.json();
        updateTable(strategyData);

    } catch (error) {
        console.error('Error in fetching the strategies:', error);
        alert(`Error in fetching the strategies: ${error.message}`);
    }
}

// update DataTable with fetched strategies
function updateTable(strategyData) {
    dataTableInstance.clear(); // Clear existing data

    strategyData.forEach(strategy => {

        const description = strategyDescriptions[strategy.id] || 'Description unavailable';

        dataTableInstance.row.add([
            strategy.name,
            description,
            strategy.enabled ? 'Enabled' : 'Disabled',
            `
                <button class="${strategy.enabled ? 'disable-button' : 'enable-button'}"
                        data-id="${strategy.id}" data-enabled="${!strategy.enabled}">
                    ${strategy.enabled ? 'Disable' : 'Enable'}
                </button>
            `
        ]);
    });

    dataTableInstance.draw(); // redraw table

    attachButtonListeners(); // reattach toggle handlers
}

function attachButtonListeners() {
    document.querySelectorAll('.enable-button, .disable-button').forEach(button => {
        button.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            const enabled = this.getAttribute('data-enabled') === 'true';
            toggleStrategy(id, enabled);
        });
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
        await fetchStrategies();
        
    } catch (error) {
        console.error(`Error in editing the strategy ${id}:`, error);
        alert(`Error in editing strategy state ${id}: ${error.message}`);
    }
}
