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