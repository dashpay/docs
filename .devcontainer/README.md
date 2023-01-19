# Development Container

The development container config ([.devcontainer.json](./devcontainer.json)) enables starting a
pre-configured [GitHub Codespaces](https://github.com/features/codespaces) environment ready to
build and preview the docs in this repository.

## Building a preview

The current version of the docs will be automatically built the when a new codespace is created. To
re-build the docs after making changes, simply run this command from the terminal:

```shell
make html
```

Note: you may need go to the main menu, click `View`, then `Terminal` if the terminal isn't visible.

## Viewing the preview

To preview the docs, run the following command in the terminal:

```shell
python -m http.server 8080 -d _build/html
```

This will start a simple Python web server on port 8080 in the codespace and open a preview of the
site in VSCode's built-in simple browser. To preview in your actual browser, click the `PORTS` tab,
right-click on `Doc Preview (8080)`, and select `Open in Browser`.
