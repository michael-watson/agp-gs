import React, { Component } from 'react';
import './App.css';

import BooksList from './components/BooksList';

class App extends Component {
  render() {
    return (
      <div className="App">
        <BooksList />
      </div>
    );
  }
}

export default App;
