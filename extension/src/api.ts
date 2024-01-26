interface AnalysisResponse {
    markdownResponse: string;
}

interface SuggestedSolutionResponse {
    solutionSuggestion: {
        name: string;
        description: string;
        subModules?: any[]; // Adjust the type based on the actual structure
        pseudoCode: string;
    };
}

export class FHIRfyApi {
    private baseUrl: string;
    private username: string;
    private password: string;

    constructor(baseUrl: string, username?: string, password?: string) {
        this.baseUrl = baseUrl;
        this.username = username ? username : '_SYSTEM';
        this.password = password ? password : 'SYS';
    }

    private async fetchJson<T>(url: string, options: RequestInit = {}): Promise<T> {
        const response = await fetch(url, options);

        if (!response.ok) {
            throw new Error(`Request failed with status ${response.status}`);
        }

        return response.json();
    }

    public async analyzeData(rawData: string, mockName?: string): Promise<string> {
        const url = `${this.baseUrl}/analyze-data${mockName ? `?mockName=${mockName}` : ''}`;
        console.log(url);

        const response = await this.fetchJson<AnalysisResponse>(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic ' + btoa(`${this.username}:${this.password}`),
        },
        body: JSON.stringify({ input: { rawData: rawData } }),
        });

        return response.markdownResponse;
    }

    public async suggestSolution(rawData: string, analysis: string, mockName?: string): Promise<SuggestedSolutionResponse> {
        const url = `${this.baseUrl}/suggest-solution${mockName ? `?mockName=${mockName}` : ''}`;

        const response = await this.fetchJson<SuggestedSolutionResponse>(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa(`${this.username}:${this.password}`),
            },
            body: JSON.stringify({ "rawData": rawData, "analysis": analysis } ),
        });

        return response;
    }

    public async generateModule(request: string, mockName?: string): Promise<string> {
        const url = `${this.baseUrl}/generate-module${mockName ? `?mockName=${mockName}` : ''}`;

        const response = await this.fetchJson<string>(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa(`${this.username}:${this.password}`),
            },
            body: JSON.stringify({ input: request }),
        });

        return response;
    }
}