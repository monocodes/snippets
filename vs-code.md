---
title: VS-Code
categories:
  - vs-code
  - notes
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# VS-Code

---

- [VS-Code](#vs-code)
  - [Useful Keybindings](#useful-keybindings)
  - [settings.json](#settingsjson)
  - [Extensions](#extensions)
    - [Black Formatter](#black-formatter)
    - [autoDocstring - Python Docstring Generator](#autodocstring---python-docstring-generator)

---

## Useful Keybindings

---

**Trigger Suggest**  
For example, list tags after `:` in `Dockerfile` in `FROM` section  
`cmd + shift + space`

**Trigger Parameter Hints**  
Useful hints and suggests  
`shift + option + space`

**Reload the current window**  
`cmd + shift + p` -> `Reload`

---

## settings.json

---

```json
{
    "python.defaultInterpreterPath": "/usr/local/bin/python3",
    "security.workspace.trust.untrustedFiles": "open",
    "editor.wordWrap": "on",
    "editor.rulers": [50, 79],
    "editor.stickyTabStops": true,
    "python.analysis.typeCheckingMode": "off",
    "workbench.editorAssociations": {
        "*.html": "default"
    },
    "files.associations": {
        "*.env": "properties"
    },
    "python.formatting.provider": "none",
    "[python]": {
        "editor.defaultFormatter": "ms-python.black-formatter"
    },
    "[html]": {
        "editor.tabSize": 2
    },
    "[shellscript]": {
        "editor.tabSize": 2
    },
    "[ruby]": {
        "editor.tabSize": 2
    },
    "telemetry.telemetryLevel": "off",
    "docker.images.label": "FullTag",
    "editor.indentSize": "tabSize",
    "window.autoDetectColorScheme": true,
    "workbench.preferredDarkColorTheme": "Default Dark+ Experimental",
    "workbench.colorTheme": "Default Dark+ Experimental",
    "terminal.integrated.env.osx": {
        "FIG_NEW_SESSION": "1"
    },
    "[markdown]": {
        "editor.defaultFormatter": "DavidAnson.vscode-markdownlint",
        "editor.tabSize": 2,
        "editor.quickSuggestions": {
            "other": true,
            "comments": false,
            "strings": false
        }
    },
    "markdownlint.config": {
            // "MD033": false,
            "MD025": false,
    },
    "preview.previewTheme": "Dark",
    "yaml.format.singleQuote": true,
    "yaml.recommendations.show": true,
    "yaml.schemaStore.enable": false,
}
```

---

## Extensions

---

### Black Formatter

---

ms-python.black-formatter extension

```json
"python.formatting.provider": "none",
"[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
},
```

currently doesn't work

```json
"black-formatter.args": [
    "--line-length 79"
],
"python.formatting.blackArgs": [
    "--line-length 79"
]
```

---

### autoDocstring - Python Docstring Generator

---

cursor after first `"""`  
generate docstring  
`cmd + shift + A`
