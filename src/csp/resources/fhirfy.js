const simulateTypingAnimation = (text, btn, container) => {
    const typingSpeed = 15; // Adjust speed as needed
    let index = 0;
    if (text.length === 0) return;

    const type = () => {
        responseText.textContent = text.slice(0, index);

        if (index < text.length) {
            index++;
            setTimeout(type, typingSpeed);
        } else {
            addResponseToChat(responseText.textContent, btn, container);
            responseText.innerHTML = '';
        }
    }

    type();
}

const addResponseToChat = (responseTextContent, btn, container) => {
    const newResponseDiv = document.createElement('div'),
        chatContainer = document.getElementById('chatContainer'),
        rawData = !!!container ? '' : container.textContent;
    newResponseDiv.className = 'response-text';
    newResponseDiv.innerHTML = marked.marked(responseTextContent);

    let button = (btn === 'suggest') ? suggestButton(responseTextContent, rawData) : (btn === 'model') ? generateModelButton() : '';

    newResponseDiv.appendChild(button);

    if (!!!container) {
        chatContainer.insertBefore(newResponseDiv, document.getElementById('responseContainer'));
        return
    }
    container.appendChild(newResponseDiv);
}

const suggestButton = (responseTextContent, rawData) => {
    const suggestDiv = document.createElement('div'), 
        suggestButton = document.createElement('button');
    suggestButton.className = 'suggest-button';
    suggestButton.textContent = 'Suggest Implementation';
    suggestButton.addEventListener('click', () => {
        suggestImplementation({"analysis": responseTextContent, "rawData": rawData});
    });
    suggestDiv.appendChild(suggestButton);
    return suggestDiv;
}

const generateModelButton = (responseTextContent, rawData) => {
    const genModelDiv = document.createElement('div'), 
        genModelButton = document.createElement('button');
    genModelButton.className = 'gen-model-button';
    genModelButton.textContent = 'Generate Model';
    genModelButton.addEventListener('click', () => {
        suggestImplementation({"analysis": responseTextContent, "rawData": rawData}, 'model');
    });
    genModelDiv.appendChild(genModelButton);
    return genModelDiv;
}

document.addEventListener('DOMContentLoaded', () => {
    const themeSwitch = document.getElementById('themeSwitch'),
        markdownInput = document.getElementById('markdownInput'),
        submitButton = document.getElementById('submitButton'),
        themeIcon = document.getElementById('themeIcon'),
        spinnerIcon = document.createElement('i'),
        chatContainer = document.getElementById('chatContainer');;

    spinnerIcon.className = 'fas fa-spinner fa-spin button-icon';

    themeSwitch.addEventListener('click', () => {
        document.body.classList.toggle('dark-theme', themeSwitch.checked);
        themeIcon.className = document.body.classList.contains('dark-theme') ? 'fas fa-sun button-icon' : 'fas fa-moon button-icon';
    });
    
    submitButton.addEventListener('click', () => {
        document.getElementById('card-container').style.transform = 'translateX(-300%)';
        document.getElementById('card-container').style.display = 'none';
 
        const markdownText = markdownInput.value,
            responseDiv = document.createElement('div'),
            userPromptDiv = document.createElement('div');
        userPromptDiv.className = 'user-prompt';
        responseDiv.className = 'response-prompt';
        userPromptDiv.textContent = markdownInput.value;
        responseDiv.appendChild(userPromptDiv);
        chatContainer.insertBefore(responseDiv, document.querySelector('#responseContainer'));
        submitButton.appendChild(spinnerIcon);

        const username = document.getElementById('username').value,
            password = document.getElementById('password').value,
            mockName = document.getElementById('mockName').value;
        fetch(`/csp/api/dc/fhirfy/analyze-data${ !!!mockName ? '' : `?mockName=${mockName}`}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa(`${username}:${password}`) 
            },
            body: JSON.stringify({ input: { rawData: markdownText } })
        })
            .then(response => response.json())
            .then(data => {
                apiResponse = data.markdownResponse;
                simulateTypingAnimation(apiResponse, 'suggest', responseDiv);
                submitButton.querySelector('.fa-spinner').remove();
            })
            .catch(error => {
                console.error('Error:', error);
                submitButton.querySelector('.fa-spinner').remove();
            });

    });
});

document.addEventListener('keydown', (event) => {
    if (event.ctrlKey && event.code === 'Semicolon') {
        console.log('settings');
        toggleSettingsForm();
    }
});

const toggleSettingsForm = () => {
    document.getElementById('settings-container').classList.toggle('hidden');
}

const saveSettings = () => {
    toggleSettingsForm(); 
}

suggestImplementation = (request) => {
    const username = document.getElementById('username').value,
        password = document.getElementById('password').value,
        mockName = document.getElementById('mockName').value;
    console.log(request);

    fetch(`/csp/api/dc/fhirfy/suggest-solution${ !!!mockName ? '' : `?mockName=${mockName}`}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa(`${username}:${password}`)
        },
        body: JSON.stringify(request)
    })
    .then(response => response.json())
    .then(data => {
        console.log('Suggested implementation:', data);
        if (!!!data.solutionSuggestion) return console.log('No implementation found');
        let suggestion = `## ${data.solutionSuggestion.name}\n${data.solutionSuggestion.description}`;
        if (data.solutionSuggestion.hasOwnProperty("subModules")) data.solutionSuggestion.subModules.subModule.forEach((submodule) => {
            suggestion += `\n\n### ${submodule.name}\n${submodule.description}`
        })
        suggestion += !!!data.solutionSuggestion.pseudoCode ? '' : `\n## Pseudo Code\n\`\`\`\n ${data.solutionSuggestion.pseudoCode}\`\`\`\n`	
        simulateTypingAnimation(suggestion, 'model');
    })
    .catch(error => {
        console.error('Error suggesting implementation:', error);
    });
}

generateModel = (request) => {
    const username = document.getElementById('username').value,
        password = document.getElementById('password').value,
        mockName = document.getElementById('mockName').value;
    fetch(`/csp/api/dc/fhirfy/generate-module${ !!!mockName ? '': `?mockName=${mockName}`}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic ' + btoa(`${username}:${password}`)
        },
        body: request
    })
    .then(response => response.json())
    .then(data => {
        console.log('generated module:', data);
    })
    .catch(error => {
        console.error('Error generating module:', error);
    });
}