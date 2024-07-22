// Oggetto di mappatura delle descrizioni
const strategyDescriptions = {
    1: 'Changes the IP of the pod for the<br>selected deployment making it restart',
    2: 'Creates a new replica of the pod<br>for the selected deployment',
    3: 'Migrate the pod of the selected<br>deployment to another worker node',
    4: 'Changes the Service Account of the pod<br>for the selected deployment',
    // Aggiungi altre descrizioni in base agli id delle strategie
};

async function fetchStrategies() {
    try {
        const response = await fetch('/strategy/all');
        if (!response.ok) {
            throw new Error(`Errore HTTP: ${response.status} - ${response.statusText}`);
        }
        const data = await response.json();
        const strategyList = document.getElementById('strategy-list');
        strategyList.innerHTML = '';
        data.forEach(strategy => {

            const description = strategyDescriptions[strategy.id] || 'Description unavailable';

            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${strategy.id}</td>
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

        // Aggiungi gestori di eventi ai pulsanti dopo averli creati dinamicamente
        document.querySelectorAll('.enable-button, .disable-button').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const enabled = this.getAttribute('data-enabled') === 'true';
                toggleStrategy(id, enabled);
            });
        });

    } catch (error) {
        console.error('Error in fetching the strategies:', error);
        alert(`Error in fetching the strategies: ${error.message}`);
    }
}

document.addEventListener('DOMContentLoaded', fetchStrategies);

async function toggleStrategy(id, enabled) {
    try {
        const response = await fetch(`/strategy/enable/${id}?enabled=${enabled}`, {
            method: 'PUT'
        });
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status} - ${response.statusText}`);
        }
        // Ricarica la lista delle strategie dopo aver modificato lo stato
        fetchStrategies();
    } catch (error) {
        console.error(`Error in editing the strategy ${id}:`, error);
        alert(`Error in editing strategy state ${id}: ${error.message}`);
    }
}

// Carica le strategie al caricamento della pagina
fetchStrategies();