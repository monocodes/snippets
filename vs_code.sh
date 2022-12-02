# reload the current window
cmd + shift + p -> Reload



### settings.json -------------------------------
{
    "workbench.colorTheme": "Default Dark+",
    "python.defaultInterpreterPath": "/usr/local/bin/python3",
    "security.workspace.trust.untrustedFiles": "open",
    "editor.wordWrap": "on",
    "editor.rulers": [50, 79],
    "editor.stickyTabStops": true,
    "python.analysis.typeCheckingMode": "off",
    "workbench.editorAssociations": {
        "*.html": "default"
    },
    "python.formatting.provider": "none",
    "[python]": {
        "editor.defaultFormatter": "ms-python.black-formatter"
    },
}


### Black Formatter -----------------------------
### ms-python.black-formatter extension

    "python.formatting.provider": "none",
    "[python]": {
        "editor.defaultFormatter": "ms-python.black-formatter"
    },


### currently doesn't work
    "black-formatter.args": [
        "--line-length 79"
    ],
    "python.formatting.blackArgs": [
        "--line-length 79"
    ]
