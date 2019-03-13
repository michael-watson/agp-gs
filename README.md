# Getting Started

## Setup

Add a `.env` file to each project folder (vscode-only, client and server) and paste in your key: `ENGINE_API_KEY=service:9823uronvdoijfewfoij`.

Make sure your Apollo Engine Service name is reflected in the `apollo.config.js` files located in each project structure.

## Workflow

1. Clone/Download repo
2. Open `server` folder in terminal
3. Run the server locally  
```sh
npm install
node src/index.js
```
4. In another terminal window, open the `server` folder and register the initial schema
```sh
apollo service:push
```

**Note**: You should be able to run `apollo service:check` from the `server` folder as well

5. Now change to the `client` folder and run the client project locally:
```sh
npm install
npm run start
```

6. Refresh the client project a few times to get some query traffic flowing
7. Check that intellisense is working in VS Code with the client project
8. Setup the `vscode-only` project and verify the intellisense is working