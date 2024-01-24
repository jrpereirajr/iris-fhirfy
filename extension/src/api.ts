import fetch from 'node-fetch';

class FHIRfyApi {
    private baseUrl: string;

    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }

    private async fetchJson(url: string, options: RequestInit = {}): Promise<any> {
        const response = await fetch(url, options);

        if (!response.ok) {
            throw new Error(`Request failed with status ${response.status}`);
        }

        return response.json();
    }

    public async analyzeData(rawData: string): Promise<string> {
        const url = `${this.baseUrl}/analyze-data`;

        const response = await this.fetchJson(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: { rawData } }),
        });

        return response.markdownResponse;
    }

    public async suggestSolution(rawData: string, analysis: string): Promise<any> {
        const url = `${this.baseUrl}/suggest-solution`;

        const response = await this.fetchJson(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: { rawData, analysis } }),
        });

        return response.solutionSuggestion;
    }

    public async generateModule(request: any): Promise<any> {
        const url = `${this.baseUrl}/generate-module`;

        const response = await this.fetchJson(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: request }),
        });

        return response;
    }
}