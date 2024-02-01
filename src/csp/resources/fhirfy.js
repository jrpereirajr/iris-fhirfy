const simulateTypingAnimation = (text, btn, container, req) => {
    const typingSpeed = 1; // Adjust speed as needed
    let index = 0;
    if (!!!text || text.length === 0) return;

    const type = () => {
        responseText.textContent = text.slice(0, index);
        let chatContainer = document.getElementById('chatContainer');
        chatContainer.scrollTop = chatContainer.scrollHeight;

        if (index < text.length) {
            index++;
            setTimeout(type, typingSpeed);
        } else {
            addResponseToChat(responseText.textContent, btn, container, req);
            responseText.innerHTML = '';
        }
    }

    type();
}

const copyCodeToClipboard = (button) => {
    const codeElement = button.previousElementSibling,
        codeToCopy = codeElement.innerText;

    navigator.clipboard.writeText(codeToCopy)
        .then(() => {
            // Provide visual feedback on successful copy
            button.innerHTML = '<span>&#10004;</span> Copied!';
            setTimeout(() => {
                button.innerHTML = '<span>&#128203;</span> Copy code';
            }, 2000);
        })
        .catch(err => {
            console.error('Failed to copy code to clipboard', err);
        });
}

const addResponseToChat = (responseTextContent, btn, container, req) => {
    const newResponseDiv = document.createElement('div'),
        chatContainer = document.getElementById('chatContainer'),
        rawData = !!!container ? '' : container.textContent;
    newResponseDiv.className = 'response-text';
    newResponseDiv.innerHTML = marked.marked(responseTextContent.replace(/```([\s\S]*?)```/g, (match, code) => {
        return `<div class="code-container">
                    <code>${code}</code>
                    <div class="copy-button" onclick="copyCodeToClipboard(this)">
                        <span>&#128203;</span> Copy code
                    </div>
                </div>`;
    }));

    let button = (btn === 'suggest') ? suggestButton(responseTextContent, rawData) : (btn === 'model') ? generateModelButton(req) : '';

    button !== '' ? newResponseDiv.appendChild(button) : '';

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
        const spinnerIcon = document.createElement('i')
        spinnerIcon.className = 'fas fa-spinner fa-spin button-icon';
        suggestButton.appendChild(spinnerIcon);
        suggestImplementation({"analysis": responseTextContent, "rawData": rawData}, suggestButton);
    });
    suggestDiv.appendChild(suggestButton);
    return suggestDiv;
}

const generateModelButton = (request) => {
    const genModelDiv = document.createElement('div'), 
        genModelButton = document.createElement('button');
    genModelButton.className = 'gen-model-button';
    genModelButton.textContent = 'Generate Model';
    genModelButton.addEventListener('click', () => {
        const spinnerIcon = document.createElement('i');
        spinnerIcon.className = 'fas fa-spinner fa-spin button-icon';
        genModelButton.appendChild(spinnerIcon);
        generateModel(request, genModelButton);
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
        const markdownText = markdownInput.value,
            responseDiv = document.createElement('div'),
            userPromptDiv = document.createElement('div');
        if (markdownText.length < 1) return

        document.getElementById('card-container').style.transform = 'translateX(-300%)';
        document.getElementById('card-container').style.display = 'none';
 
        userPromptDiv.className = 'user-prompt';
        responseDiv.className = 'response-prompt';
        userPromptDiv.textContent = markdownInput.value;
        responseDiv.appendChild(userPromptDiv);
        chatContainer.insertBefore(responseDiv, document.querySelector('#responseContainer'));
        submitButton.appendChild(spinnerIcon);

        const username = document.getElementById('username').value,
            password = document.getElementById('password').value,
            mockName = document.getElementById('mockName').value,
            llmProvider = document.getElementById('llmProvider').value,
            llmApiKey = document.getElementById('llmApiKey').value;
        window._analysis = '';
        fetch(`/csp/api/dc/fhirfy/analyze-data${ !!!mockName ? '' : `?mockName=${mockName}`}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa(`${username}:${password}`),
                'X-FHIRFY-LLM-PROVIDER': llmProvider,
                'X-FHIRFY-LLM-API-KEY': llmApiKey
            },
            body: JSON.stringify({ input: { rawData: markdownText } })
        })
            .then(response => response.json())
            .then(data => {
                apiResponse = data.markdownResponse;
                window._analysis = apiResponse
                simulateTypingAnimation(apiResponse, 'suggest', responseDiv);
                submitButton.querySelector('.fa-spinner').remove();
            })
            .catch(error => {
                console.error('Error:', error);
                displayErrorMessage('Error analyzing data. Please try again.\n' + JSON.stringify(error));
                submitButton.querySelector('.fa-spinner').remove();
            });

    });
    
    let mockName = document.getElementById('mockName');
    mockName.addEventListener('change', (evt) => {
        let markdownInput = document.getElementById('markdownInput');
        showLLMSettings(evt.target.value);
        if (evt.target.value) {
            fetch(`/csp/api/dc/fhirfy/mock/${evt.target.value}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Basic ' + btoa(`${username}:${password}`) 
                }
            })
                .then(response => response.json())
                .then(data => {
                    markdownInput.value = data.analysisInput;
                });
        } else {
            markdownInput.value = '';
        }
        markdownInput.focus();
    });

    showLLMSettings = (selectedMock) => {
        document.getElementById('llmSettings').style.display = !selectedMock ? 'block' : 'none';
    }

    showLLMSettings(document.getElementById('mockName').value);
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

suggestImplementation = (request, suggestButton) => {
    const username = document.getElementById('username').value,
        password = document.getElementById('password').value,
        mockName = document.getElementById('mockName').value,
        llmProvider = document.getElementById('llmProvider').value,
        llmApiKey = document.getElementById('llmApiKey').value;
    console.log(request);

    fetch(`/csp/api/dc/fhirfy/suggest-solution${ !!!mockName ? '' : `?mockName=${mockName}`}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic ' + btoa(`${username}:${password}`),
            'X-FHIRFY-LLM-PROVIDER': llmProvider,
            'X-FHIRFY-LLM-API-KEY': llmApiKey
        },
        body: JSON.stringify({ input: request })
    })
    .then(response => response.json())
    .then(data => {
        console.log('Suggested implementation:', data);
        suggestButton.querySelector('.fa-spinner').remove();
        if (!!!data.solutionSuggestion) return console.log('No implementation found');
        let suggestion = `## ${data.solutionSuggestion.name}\n${data.solutionSuggestion.description}`;
        if (data.solutionSuggestion.hasOwnProperty("subModules")) data.solutionSuggestion.subModules.subModule.forEach((submodule) => {
            suggestion += `\n\n### ${submodule.name}\n${submodule.description}`
        })
        suggestion += !!!data.solutionSuggestion.pseudoCode ? '' : `\n## Pseudo Code\n\`\`\`\n ${data.solutionSuggestion.pseudoCode}\n\`\`\`\n`	
        // simulateTypingAnimation(suggestion, 'model', null, data.solutionSuggestion);
        simulateTypingAnimation(suggestion, 'model', null, {"analysis": window._analysis, "solutionSuggestion": data.solutionSuggestion});
    })
    .catch(error => {
        console.error('Error suggesting implementation:', error);
        displayErrorMessage('Error suggesting implementation. Please try again.\n' + JSON.stringify(error));
    });
}

generateModel = (request, genModelButton) => {
    const username = document.getElementById('username').value,
        password = document.getElementById('password').value,
        mockName = document.getElementById('mockName').value,
        llmProvider = document.getElementById('llmProvider').value,
        llmApiKey = document.getElementById('llmApiKey').value;
    fetch(`/csp/api/dc/fhirfy/generate-module${ !!!mockName ? '': `?mockName=${mockName}`}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic ' + btoa(`${username}:${password}`),
            'X-FHIRFY-LLM-PROVIDER': llmProvider,
            'X-FHIRFY-LLM-API-KEY': llmApiKey
        },
        body: JSON.stringify({"input": request})
    })
    .then(response => response.json())
    .then(data => {
        console.log('generated module:', data);
        genModelButton.querySelector('.fa-spinner').remove();

        if (!!!data) return console.log('No implementation found');
        gen_module = `## Generated Module\n\n### ${data.name}\n__${data.description}__\n**${data.dependencies}**\n [download module](/csp/api/dc/fhirfy/download?moduleName=${data.name})\n `;
        if (data.hasOwnProperty("files")) data.files.forEach((file) => {
            gen_module += `\n#### ${file.name}\n${!!!file.description ? '' : file.description}\n\`\`\`\n ${file["source-code"]}\n\`\`\`\n`
        })
        simulateTypingAnimation(gen_module, null);
    })
    .catch(error => {
        console.error('Error generating module:', error);
        displayErrorMessage('Error generating module. Please try again.\n' + JSON.stringify(error));
    });
}

const displayErrorMessage = (message) => {
    const errorMessageDiv = document.createElement('div');
    errorMessageDiv.classList.add('error-message');
    errorMessageDiv.textContent = message;

    const chatContainer = document.getElementById('chatContainer');
    chatContainer.insertBefore(errorMessageDiv, responseContainer);
};