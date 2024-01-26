import * as vscode from 'vscode';
import * as api from './api';
// import * as fs from 'fs';
// import * as path from 'path';

export function activate(context: vscode.ExtensionContext) {
    console.log('FHIRfy Extension is now active!');

    const endpoint = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('endpoint', '/csp/api/dc/fhirfy'),
        host = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('host', 'localhost'),
        port = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('port', 32783),
        username = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('username', '_SYSTEM'),
        password = vscode.workspace.getConfiguration('fhirfyAnalyzer').get('password', 'SYS'),
        apiURL = `http://${host}:${port}${endpoint}`,
        fhirfyApi = new api.FHIRfyApi(apiURL, username, password),
        iconPath = vscode.Uri.joinPath(context.extensionUri, 'src', 'webview', 'icon.png');

    console.log(`Configured endpoint: ${endpoint}, host: ${host}, port: ${port}, username: ${username}, password: ${password} API URL: ${apiURL}`);

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
                            console.log('Analyzing data...', message.text, message.mock);
                            const markdownContent = message.text;

                            fhirfyApi.analyzeData(message.text, message.mock)
                                .then((response) => {
                                    console.log('Analysis Result:', response)
                                    panel.webview.postMessage({
                                        command: 'analysisResult',
                                        result: response
                                    });
                                })
                                .catch((error) => {
                                    console.error('Error:', error.message)
                                    panel.webview.postMessage({
                                        command: 'error',
                                        result: error.message
                                    });
                                });

                            return;

                        case 'suggestSolution':
                            console.log('Suggest Solution...', message.text, message.mock);
                            const suggest = JSON.parse(message.text);
                            fhirfyApi.suggestSolution(suggest.rawData, suggest.analysis, message.mock)
                                .then((response) => {
                                    console.log('Solution Result:', response)
                                    panel.webview.postMessage({
                                        command: 'solutionResult',
                                        result: response
                                    });
                                })
                                .catch((error) => {
                                    console.error('Error:', error.message)
                                    panel.webview.postMessage({
                                        command: 'error',
                                        result: error.message
                                    });
                                });

                            return;

                        case 'generateModule':
                            console.log('Generate Module...', message.text, message.mock);
                            fhirfyApi.generateModule(JSON.parse(message.text), message.mock)
                                .then((response) => {
                                    console.log('Model Result:', response)
                                    panel.webview.postMessage({
                                        command: 'modelResult',
                                        result: response
                                    });
                                })
                                .catch((error) => {
                                    console.error('Error:', error.message)
                                    panel.webview.postMessage({
                                        command: 'error',
                                        result: error.message
                                    });
                                });

                            return;

                        case 'alert':
                            vscode.window.showErrorMessage(message.text);
                            return;
                    }
                } catch (error) {
                    console.error('Error handling message:', error);
                    panel.webview.postMessage({
                        command: 'error',
                        result: error
                    });
                }
            },
            undefined,
            context.subscriptions
        );

    });

    console.log(iconPath);
    const disposable = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 0);
    disposable.text = "$(comment-discussion) FHIRfy Analyzer";
    disposable.command = 'fhirfyAnalyzer.show';
    disposable.tooltip = 'FHIRfy Analyzer';
    disposable.show();
    const showCommand = vscode.commands.registerCommand('fhirfyAnalyzer.show', () => {
        panel.reveal(vscode.ViewColumn.One);
    });

    context.subscriptions.push(disposable, showCommand);
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
