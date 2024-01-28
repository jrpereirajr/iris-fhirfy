Class dc.jrpereira.fhirfy.core.OpenAILLMService Extends LLMService
{

Parameter ServiceID = "openai";

Method SendPrompt(prompt As %String, params As %DynamicObject = {{}}) As %DynamicObject [ Language = python ]
{
    from openai import OpenAI
    import os

    client = OpenAI(
        # This is the default and can be omitted
        api_key=self.GetAPIKey(os.environ.get("OPENAI_API_KEY")),
    )

    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": prompt,
            }
        ],
        model="gpt-3.5-turbo",
        temperature=0.0 # attemptive to reproducibility
    )
    
    generated_texts = [choice.message.content for choice in chat_completion.choices]
    response = "\n".join(generated_texts)

    return response
}

Method IsProviderException(errorDesc As %String) As %Boolean
{
    Return $FIND(errorDesc,"<class 'openai.") > 0
}

}
