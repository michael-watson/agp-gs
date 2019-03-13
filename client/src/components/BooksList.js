import React, { Component } from 'react';

import { Query } from 'react-apollo';
import gql from 'graphql-tag';

const BOOKS = gql`
    query BooksWithAuthor {
        books {
			author
			
        }
    }
`; 

export default class BooksList extends Component {
	render = () => {
		return (
			<Query query={BOOKS}>
				{({ data, loading, error }) => {
				if (loading || !(data)) return <p className="loading">loading...</p>;
				if (error) return <p>ERROR</p>;
		
				return (
					<ul className="booksList">
						{data.books.map(book => {
							return (
								<li><b>{book.author}</b> - {book.title}</li>
							)
						})}
					</ul>
				);
			}}
			</Query>
		);
	}
}