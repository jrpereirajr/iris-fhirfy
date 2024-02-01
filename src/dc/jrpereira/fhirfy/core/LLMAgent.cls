Class dc.jrpereira.fhirfy.core.LLMAgent Extends %RegisteredObject
{

Method GetLLMResponse(input) As %String [ Language = python ]
{
    prompt = self.GetSystemPrompt(input)
    try:
        response = self.llm.SendPrompt(prompt)
    except ValueError as e:
        if str(e).find("This response is not simple text.Use the `result.parts` accessor or the full `result.candidates[index].content.parts` lookup instead") != -1:
            raise Exception("Your prompt seems to let the LLM to produce a very long response, which was denied. Prompt: " + str(e))
        raise e
    except Exception as e:
        raise e
    self.SaveLLMResponseToFile(response)
    return response
}

Method SaveLLMResponseToFile(response As %String) [ Language = python ]
{
    import os
    import uuid
    # save the response to a text file in the /tmp/fhirfy directory
    try:
        # generate a unique filename
        filename = f"{str(uuid.uuid4())}.txt"

        # create the directory if it doesn't exist
        directory = "/tmp/fhirfy"
        if not os.path.exists(directory):
            os.makedirs(directory)
        
        f = open(f"{directory}/{filename}", "w")
        f.write(response)
        f.close()
    except Exception as e:
        #; raise Exception("Failed to save the response to a text file: " + str(e))
        # todo: log the error but continue
        pass
}

}
