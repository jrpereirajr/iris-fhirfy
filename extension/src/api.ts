
interface AnalysisInput {
    rawData: string;
}

interface AnalysisResponse {
    markdownResponse: string;
}

interface SolutionSuggestionInput {
    rawData: string;
    analysis: string;
}

interface SuggestedSolutionResponse {
    solutionSuggestion: {
        name: string;
        description: string;
        subModules?: any[]; // Adjust the type based on the actual structure
        pseudoCode: string;
    };
}

interface GenerateModuleRequest { }

interface GenerateModuleResponse { }

class FHIRfyApi {
    private baseUrl: string;

    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }

    private async fetchJson<T>(url: string, options: RequestInit = {}): Promise<T> {
        const response = await fetch(url, options);

        if (!response.ok) {
            throw new Error(`Request failed with status ${response.status}`);
        }

        return response.json();
    }

    public async analyzeData(rawData: string): Promise<string> {
        const url = `${this.baseUrl}/analyze-data`;

        const response = await this.fetchJson<AnalysisResponse>(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: { rawData } } as AnalysisInput),
        });

        return response.markdownResponse;
    }

    public async suggestSolution(rawData: string, analysis: string): Promise<SuggestedSolutionResponse> {
        const url = `${this.baseUrl}/suggest-solution`;

        const response = await this.fetchJson<SuggestedSolutionResponse>(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: { rawData, analysis } } as SolutionSuggestionInput),
        });

        return response;
    }

    public async generateModule(request: GenerateModuleRequest): Promise<GenerateModuleResponse> {
        const url = `${this.baseUrl}/generate-module`;

        const response = await this.fetchJson<GenerateModuleResponse>(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: request }),
        });

        return response;
    }
}