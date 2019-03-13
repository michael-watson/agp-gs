import gql from 'graphql-tag';

const BOOKS = gql`
    query BooksWithAuthor {
        books {
            author
            title
        }
    }
`; 
