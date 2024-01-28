Class dc.jrpereira.fhirfy.api.spec Extends %RegisteredObject
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger":"2.0",
  "info":{
    "title":"IRIS FHIRfy",
    "version":"1.0.0"
  },
  "securityDefinitions":{
    "BasicAuth":{
      "type":"basic"
    }
  },
  "security":[
    {
      "BasicAuth":[
      ]
    }
  ],
  "paths":{
    "/analyze-data":{
      "post":{
        "operationId":"analyzeData",
        "summary":"Analyze Data",
        "description":"Analyzes raw data and returns an analysis report.",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"input",
            "in":"body",
            "required":true,
            "schema":{
              "$ref":"#/definitions/AnalysisInput"
            }
          },
          {
            "name":"mockName",
            "in":"query",
            "type":"string",
            "required":false
          },
          {
            "name": "X-FHIRFY-LLM-PROVIDER",
            "in": "header",
            "type": "string",
            "required": false
          },
          {
            "name": "X-FHIRFY-LLM-API-KEY",
            "in": "header",
            "type": "string",
            "required": false
          }
        ],
        "responses":{
          "200":{
            "description":"Successful analysis response",
            "schema":{
              "$ref":"#/definitions/AnalysisResponse"
            }
          }
        }
      }
    },
    "/suggest-solution":{
      "post":{
        "operationId":"suggestSolution",
        "summary":"Suggest a solution",
        "description":"Suggest a solution based on the analysis report.",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"input",
            "in":"body",
            "required":true,
            "schema":{
              "$ref":"#/definitions/SolutionSuggestionInput"
            }
          },
          {
            "name":"mockName",
            "in":"query",
            "type":"string",
            "required":false
          },
          {
            "name": "X-FHIRFY-LLM-PROVIDER",
            "in": "header",
            "type": "string",
            "required": false
          },
          {
            "name": "X-FHIRFY-LLM-API-KEY",
            "in": "header",
            "type": "string",
            "required": false
          }
        ],
        "responses":{
          "200":{
            "description":"Successful solution suggestion response",
            "schema":{
              "$ref":"#/definitions/SuggestedSolutionResponse"
            }
          }
        }
      }
    },
    "/generate-module":{
      "post":{
        "operationId":"generateModule",
        "summary":"Generates the code for a solution suggestion.",
        "description":"Generates the code for a solution suggestion encapsulated as a ZPM module.",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"input",
            "in":"body",
            "required":true,
            "schema":{
              "$ref":"#/definitions/GenerateModuleRequest"
            }
          },
          {
            "name":"mockName",
            "in":"query",
            "type":"string",
            "required":false
          },
          {
            "name": "X-FHIRFY-LLM-PROVIDER",
            "in": "header",
            "type": "string",
            "required": false
          },
          {
            "name": "X-FHIRFY-LLM-API-KEY",
            "in": "header",
            "type": "string",
            "required": false
          }
        ],
        "responses":{
          "200":{
            "description":"Successful solution suggestion response",
            "schema":{
              "$ref":"#/definitions/GenerateModuleResponse"
            }
          }
        }
      }
    },
    "/download":{
      "get":{
        "operationId":"download",
        "summary":"Download the code generated for a solution.",
        "description":"Download the code generated for a solution.",
        "produces":[
          "application/octet-stream"
        ],
        "parameters":[
          {
            "name":"moduleName",
            "in":"query",
            "type":"string",
            "required":true
          }
        ],
        "responses":{
          "200":{
            "description":"Successful zip response",
            "schema":{
              "type":"string",
              "format":"binary"
            }
          }
        }
      }
    },
    "/mock/simple-csv":{
      "get":{
        "operationId":"mockSimpleCSV",
        "summary":"Mock data for a simple CSV as input",
        "description":"Get the mock data for sample of system process of a simple CSV containg basic patient information.",
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"Successful solution suggestion response",
            "schema":{
              "$ref":"#/definitions/MockDataResponse"
            }
          }
        }
      }
    },
    "/_spec":{
      "get":{
        "operationId":"getOpenAPISpec",
        "summary":"Return the OpenAPI 2.0 specification",
        "description":"Return the OpenAPI 2.0 specification.",
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"Successful solution suggestion response",
            "schema":{
              "type":"object"
            }
          }
        }
      }
    }
  },
  "definitions":{
    "AnalysisInput":{
      "type":"object",
      "properties":{
        "rawData":{
          "type":"string"
        }
      },
      "example":{
        "rawData":"Patient ID,Patient Name\n1,Patient 1\n2,Patient 2"
      }
    },
    "AnalysisResponse":{
      "type":"object",
      "properties":{
        "markdownResponse":{
          "type":"string"
        }
      },
      "example":{
        "markdownResponse":"# Analysis Report\n\nThe provided data is a list of patient records, each containing specific information about individual patients."
      }
    },
    "SolutionSuggestionInput":{
      "type":"object",
      "properties":{
        "rawData":{
          "type":"string"
        },
        "analysis":{
          "type":"string"
        }
      },
      "example":{
        "rawData":"Patient ID,Patient Name\n1,Patient 1\n2,Patient 2",
        "analysis":"# Analysis Report\n\nThe provided data is a list of patient records, each containing specific information about individual patients."
      }
    },
    "SuggestedSolutionResponse":{
      "type":"object",
      "properties":{
        "solutionSuggestion":{
          "type":"object",
          "properties":{
            "name":{
              "type":"string"
            },
            "description":{
              "type":"string"
            },
            "subModules":{
              "type":"array",
              "items":{
                "type":"object"
              }
            },
            "pseudoCode":{
              "type":"string"
            }
          }
        }
      },
      "example":{
        "solutionSuggestion":{
          "name":"CSV to HL7 FHIR Converter",
          "description":"This solution converts CSV data with patient information into the HL7 FHIR protocol."
        }
      }
    },
    "GenerateModuleRequest":{
      "type":"object",
      "allOf":[
        {
          "$ref":"#/definitions/SuggestedSolutionResponse"
        }
      ]
    },
    "GenerateModuleResponse":{
      "type":"object",
      "allOf":[
        {
          "$ref":"#/definitions/Module"
        }
      ]
    },
    "Module":{
      "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "description":{
          "type":"string"
        },
        "files":{
          "type":"array",
          "items":{
            "$ref":"#/definitions/ModuleFile"
          }
        }
      }
    },
    "ModuleFile":{
      "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "description":{
          "type":"string"
        },
        "sourceCode":{
          "type":"string"
        },
        "functions":{
          "type":"array",
          "items":{
            "$ref":"#/definitions/ModuleFunction"
          }
        }
      }
    },
    "ModuleFunction":{
      "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "description":{
          "type":"string"
        },
        "input":{
          "type":"object",
          "properties":{
            "parameters":{
              "type":"array",
              "items":{
                "$ref":"#/definitions/ModuleParameter"
              }
            }
          }
        },
        "output":{
          "type":"string"
        }
      }
    },
    "ModuleParameter":{
      "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "type":{
          "type":"string"
        },
        "description":{
          "type":"string"
        }
      }
    },
    "MockDataResponse":{
      "type":"object",
      "properties":{
        "analysisInput":{
          "$ref":"#/definitions/AnalysisInput"
        },
        "analysisRespose":{
          "$ref":"#/definitions/AnalysisResponse"
        },
        "suggestedSolutionResponse":{
          "$ref":"#/definitions/SuggestedSolutionResponse"
        },
        "generateModuleResponse":{
          "$ref":"#/definitions/GenerateModuleResponse"
        }
      }
    }
  }
}
}

}
