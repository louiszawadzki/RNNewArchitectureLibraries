# Run

This run is used to show an advanced use of a component which use the state to load images on **iOS**.

Loading images on **Android** is done with Fresco, so the android component won't actually use the state. The example is still helpful to show how to configure auto-linking properly when there is some custom C++ state.

## Table of Content

* [[Setup] Create the image-component folder and the package.json](#setup)

## Steps

### <a name="setup">[[Setup] Create the image-component folder and the package.json]()

1. `mkdir image-component`
2. `touch image-component/package.json`
3. Paste the following code into the `package.json` file
```json
{
    "name": "image-component",
    "version": "0.0.1",
    "description": "Showcase Fabric component with state",
    "react-native": "src/index",
    "source": "src/index",
    "files": [
        "src",
        "android",
        "ios",
        "example-component.podspec",
        "!android/build",
        "!ios/build",
        "!**/__tests__",
        "!**/__fixtures__",
        "!**/__mocks__"
    ],
    "keywords": ["react-native", "ios", "android"],
    "repository": "https://github.com/<your_github_handle>/image-component",
    "author": "<Your Name> <your_email@your_provider.com> (https://github.com/<your_github_handle>)",
    "license": "MIT",
    "bugs": {
        "url": "https://github.com/<your_github_handle>/image-component/issues"
    },
    "homepage": "https://github.com/<your_github_handle>/image-component#readme",
    "devDependencies": {},
    "peerDependencies": {
        "react": "*",
        "react-native": "*"
    }
}
```
