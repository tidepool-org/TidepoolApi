//
// This is a template file used to generate openapi-merge.json configuration file
// for the openapi-merge-cli tool (https://www.npmjs.com/package/openapi-merge-cli).
//
// NOTE: the values for sourceFolder and outputFile variables must be to locations relative
// to the location of the configuration file passed to the openapi-merge-cli tool.
//
{
  "output": std.extVar('outputFile'),
  "inputs": [
    {
      "inputFile": std.extVar('sourceFolder') + "general.v1.yaml",
      "dispute": {
        "suffix": "_general"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "auth.v1.yaml",
      "dispute": {
        "suffix": "_auth"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "auth.v2.yaml",
      "dispute": {
        "suffix": "_auth"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "access.v1.yaml",
      "dispute": {
        "suffix": "_access"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "blob.v1.yaml",
      "dispute": {
        "suffix": "_blob"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "clinic.v1.yaml",
      "dispute": {
        "suffix": "_clinic"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "confirm.v1.yaml",
      "dispute": {
        "suffix": "_confirm"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "data.v1.yaml",
      "dispute": {
        "suffix": "_data"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "export.v1.yaml",
      "dispute": {
        "suffix": "_export"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "message.v1.yaml",
      "dispute": {
        "suffix": "_message"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "metadata.v1.yaml",
      "dispute": {
        "suffix": "_metadata"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "metrics.v1.yaml",
      "dispute": {
        "suffix": "_metrics"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "prescription.v1.yaml",
      "dispute": {
        "suffix": "_prescription"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "summary.v1.yaml",
      "dispute": {
        "suffix": "_summary"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    },
    {
      "inputFile": std.extVar('sourceFolder') + "task.v1.yaml",
      "dispute": {
        "suffix": "_task"
      },
      "operationSelection": {
        "excludeTags": [ std.extVar('excludeTags') ]
      }
    }
  ]
}
