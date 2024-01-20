const simulateTypingAnimation = (text, btn, container) => {
    const typingSpeed = 30; // Adjust speed as needed
    let index = 0;

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
        const markdownText = markdownInput.value,
            responseDiv = document.createElement('div'),
            userPromptDiv = document.createElement('div');
        userPromptDiv.className = 'user-prompt';
        responseDiv.className = 'response-prompt';
        userPromptDiv.textContent = markdownInput.value;
        responseDiv.appendChild(userPromptDiv);
        chatContainer.insertBefore(responseDiv, document.querySelector('#responseContainer'));
        submitButton.appendChild(spinnerIcon);

        fetch('/csp/dc/jrpereira/fhirfy/api/analyze-data', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
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

suggestImplementation = (request) => {
    // Make a request to the suggest-solution API endpoint
    fetch('/csp/dc/jrpereira/fhirfy/api/suggest-solution', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: request
    })
    .then(response => response.json())
    .then(data => {
      // Handle the response from the suggest-solution endpoint
        console.log('Suggested implementation:', data);
        simulateTypingAnimation(`${data.name}\n${data.description}`, 'model');
    })
    .catch(error => {
      // Handle errors
        console.error('Error suggesting implementation:', error);
    });
}

generateModel = (request) => {
    // Make a request to the suggest-solution API endpoint
    fetch('/csp/dc/jrpereira/fhirfy/api/generate-module', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: request
    })
    .then(response => response.json())
    .then(data => {
      // Handle the response from the suggest-solution endpoint
        console.log('generated module:', data);
    })
    .catch(error => {
      // Handle errors
        console.error('Error generating module:', error);
    });
}