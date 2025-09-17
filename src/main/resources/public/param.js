async function fetchParameters() {
    try {
        const response = await fetch('/parameter/all');
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        const parameters = await response.json();
        const tableBody = document.getElementById('parameterTableBody');
        tableBody.innerHTML = '';

        parameters.forEach(parameter => {
            const row = document.createElement('tr');
            const isRandom = parameter.value === 'random';
            const selectedValue = isRandom ? 'random' : parameter.value;
            row.innerHTML = `
                <td>${parameter.key}</td>
                <td>
                    <select data-id="${parameter.id}">
                        <option value="60000" ${selectedValue == 60000 ? 'selected' : ''}>1 min</option>
                        <option value="300000" ${selectedValue == 300000 ? 'selected' : ''}>5 min</option>
                        <option value="600000" ${selectedValue == 600000 ? 'selected' : ''}>10 min</option>
                        <option value="random" ${isRandom ? 'selected' : ''}>Random</option>
                    </select>
                </td>
                <td>Edit this parameter to decide the time interval<br>for activating a strategy</td>
            `;
            tableBody.appendChild(row);
        });

        // Aggiungi un event listener per i cambiamenti nel menù a tendina
        document.querySelectorAll('select[data-id]').forEach(select => {
            select.addEventListener('change', updateParameterValue);
        });

    } catch (error) {
        console.error('Error in fetching the parameters:', error);
        // Gestisci l'errore appropriatamente
    }
}

async function updateParameterValue(event) {
    const select = event.target;
    const id = select.getAttribute('data-id');
    let newValue = select.value;

    if (newValue === "random") {
        newValue = generateRandomValue();
        alert(`Random value generated: ${newValue}`);
    } else {
        alert(`Selected value: ${newValue}`);
    }

    try {
        const response = await fetch(`/parameter/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ value: newValue })
        });
        if (!response.ok) {
            throw new Error(`HTTP Error: ${response.status}`);
        }
        console.log(`Parameter ${id} updated to ${newValue}`);
    } catch (error) {
        console.error('Error in updating the parameter:', error);
        // Gestisci l'errore appropriatamente
    }
}

function generateRandomValue() {
    // Genera un valore casuale tra 1 e 10 minuti in millisecondi
    const min = 60000; // 1 minuto
    const max = 600000; // 10 minuti
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

document.addEventListener('DOMContentLoaded', fetchParameters);
