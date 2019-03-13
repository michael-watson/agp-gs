import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';

import {ApolloClient} from 'apollo-client';
import {InMemoryCache} from 'apollo-cache-inmemory';
import {HttpLink} from 'apollo-link-http';
import {ApolloProvider} from 'react-apollo';

const client = new ApolloClient({
    link: new HttpLink({ uri: 'http://localhost:4000/' }),
    cache: new InMemoryCache(),
    name: 'book-browser-web',
    version: 1.0
});

ReactDOM.render(
    <ApolloProvider client={client}>
        <App />
  </ApolloProvider>,
document.getElementById('root'));