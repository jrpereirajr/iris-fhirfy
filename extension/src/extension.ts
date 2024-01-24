import * as vscode from 'vscode';
// import * as fs from 'fs';
// import * as path from 'path';

export function activate(context: vscode.ExtensionContext) {
    console.log('FHIRfy Extension is now active!');

    const endpoint = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('endpoint', '/csp/api/fhirfy'),
        host = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('host', 'localhost'),
        port = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('port', 32783),
        username = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('username', '_SYSTEM'),
        password = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('password', 'SYS');

    console.log(`Configured endpoint: ${endpoint}, host: ${host}, port: ${port}, username: ${username}, password: ${password}`);

    const panel = vscode.window.createWebviewPanel(
        'fhirfy',
        'FHIRfy Analyze',
        vscode.ViewColumn.One,
        {
            enableScripts: true,
            retainContextWhenHidden: true
        }
    );

    getWebviewContent(context).then(htmlContent => {
        panel.webview.html = htmlContent;

        panel.webview.onDidReceiveMessage(
            message => {
                try {
                    console.log('Received message from webview:', message);
                    switch (message.command) {
                        case 'analyzeData':
                            console.log('Analyzing data...', message.text);
                            const markdownContent = message.text;

                            // Make the HTTP POST request to the server
                            analyzeDataOnServer(markdownContent)
                                .then((response) => {
                                    // Send the server response back to the webview
                                    panel.webview.postMessage({
                                        command: 'analysisResult',
                                        result: response
                                    });
                                })
                                .catch((error) => {
                                    // Handle errors
                                    console.error('Error:', error.message);
                                    // Send an error message to the webview
                                    panel.webview.postMessage({
                                        command: 'error',
                                        error: 'Error analyzing data.'
                                    });
                                });
                            return;
                        case 'alert':
                            vscode.window.showErrorMessage(message.text);
                            return;
                    }
                } catch (error) {
                    console.error('Error handling message:', error);
                }
            },
            undefined,
            context.subscriptions
        );

    });
    const icon = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 0);
    icon.text = "$(comment-discussion) FHIRfy Analyzer";
    icon.command = 'fhirfyAnalyzer.show';
    icon.show();
    // Add an icon to the activity bar
    // Register the command to show the panel
    const disposable = vscode.commands.registerCommand('fhirfyAnalyzer.show', () => {
        panel.reveal(vscode.ViewColumn.One);
    });

    context.subscriptions.push(disposable);
}

function getWebviewContent(context: vscode.ExtensionContext): Thenable<string> {
    // Get the path to the HTML file
    const htmlPath = vscode.Uri.joinPath(context.extensionUri, 'src', 'webview', 'index.html');

    // Read the content from index.html
    return vscode.workspace.fs.readFile(htmlPath).then(content => content.toString());
}

export function deactivate() {
    console.log('FHIRfy Analyzer Extension is now deactivated!');
}


async function analyzeDataOnServer(markdownContent: string): Promise<string> {
    // Implement the logic to make the HTTP POST request to the server
    // Use your preferred HTTP library or the built-in vscode extension API
    // For example, you can use the 'request-promise' library:

    console.log('Analyzing data on ts ,', markdownContent);
    // const request = require('request-promise');

    // const options = {
    //     method: 'POST',
    //     uri: 'http://localhost:32783/csp/api/fhirfy/analyze-data',
    //     body: {
    //         input: {
    //             rawData: markdownContent
    //         }
    //     },
    //     json: true
    // };

    // return request(options);

    // Placeholder: Simulating a server response
    return new Promise<string>((resolve) => {
        // Simulate a successful analysis result
        setTimeout(() => {
            resolve('Analysis result: Lorem ipsum dolor sit amet.');
        }, 1000);
    });
}