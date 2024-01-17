Class dc.jrpereira.fhirfy.core.GoogleGeminiService Extends LLMService
{

Method SendPrompt(prompt As %String, params As %DynamicObject = {{}}) As %DynamicObject [ Language = python ]
{
    import google.generativeai as genai
    import os

    gemini_api_key = os.environ["GEMINI_API_KEY"]
    genai.configure(api_key = gemini_api_key)

    model_name = 'gemini-pro'
    model = genai.GenerativeModel(model_name,
        generation_config=genai.types.GenerationConfig(
            temperature=0.0 # attemptive to reproducibility
        )
    )
    def generate_content(prompt):
        print(model.count_tokens(prompt))
        return model.generate_content(prompt)

    respose = generate_content(prompt)
    return respose.text
}

}
