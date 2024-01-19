const simulateTypingAnimation = (text) => {
    const typingSpeed = 40; // Adjust speed as needed
    let index = 0;

    function type() {
        responseText.textContent = text.slice(0, index);

        if (index < text.length) {
            index++;
            setTimeout(type, typingSpeed);
        } else {
            addResponseToChat(responseText.textContent);
            responseText.textContent = '';
        }
    }

    type();
}

const addResponseToChat = (responseTextContent) => {
    const newResponseDiv = document.createElement('div');
    newResponseDiv.className = 'response-text';
    newResponseDiv.textContent = responseTextContent;

    chatContainer.insertBefore(newResponseDiv, document.getElementById('responseContainer'));
}

document.addEventListener('DOMContentLoaded', function () {
    const themeSwitch = document.getElementById('themeSwitch'),
        markdownInput = document.getElementById('markdownInput'),
        submitButton = document.getElementById('submitButton'),
        themeIcon = document.getElementById('themeIcon'),
        spinnerIcon = document.createElement('i'),
        submitIcon = document.createElement('i'),
        chatContainer = document.getElementById('chatContainer');;

    submitIcon.className = 'fas fa-arrow-up button-icon';
    submitButton.prepend(submitIcon);

    spinnerIcon.className = 'fas fa-spinner fa-spin button-icon';

    themeSwitch.addEventListener('click', function () {
        document.body.classList.toggle('dark-theme', themeSwitch.checked);
        themeIcon.className = document.body.classList.contains('dark-theme') ? 'fas fa-moon button-icon' : 'fas fa-sun button-icon';
    });

    
    submitButton.addEventListener('click', function () {
        const markdownText = markdownInput.value,
            userPromptDiv = document.createElement('div');
        userPromptDiv.className = 'user-prompt';
        userPromptDiv.textContent = markdownInput.value;
        chatContainer.insertBefore(userPromptDiv, document.querySelector('#responseContainer'));

        submitButton.appendChild(spinnerIcon);

        simulateTypingAnimation(` # Analysis Report\n\nThe provided data is a list of patient records, each containing specific information about individual patients.` );
        return true;

        fetch('/analyze-data', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ input: { rawData: markdownText } })
        })
            .then(response => response.json())
            .then(data => {
                apiResponse = data.markdownResponse;
                simulateTypingAnimation(apiResponse);
                submitButton.innerHTML = 'Submit';
            })
            .catch(error => {
                console.error('Error:', error);
                submitButton.innerHTML = 'Submit';
            });

    });
});
