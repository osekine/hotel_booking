import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { ApolloProvider } from "@apollo/client";
import { client } from "./apollo/client";
import { ErrorBoundary } from "./components/ui/ErrorBoundary";
import { App } from "./App";
import "./index.css";

const root = document.getElementById("root");
if (!root) throw new Error("#root element not found");

createRoot(root).render(
  <StrictMode>
    <ApolloProvider client={client}>
      {/* Top-level boundary catches catastrophic render failures */}
      <ErrorBoundary>
        <App />
      </ErrorBoundary>
    </ApolloProvider>
  </StrictMode>
);