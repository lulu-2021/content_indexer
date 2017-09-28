## Steps to take to build the index for working out TF_IDF weights for each DOC

## LOOP THROUGH ALL DOCS and follow these steps for each:

* Extract tokens (clean, stop-words, stem) = all_tokens
* Extract unique_tokens (from all_tokens) = unique_tokens


For each Doc:

* Total number of terms in document: `DocCounts.add\_document(document_name, term_count)`
* Increment total number of docs in corpus: `Corpus.increment()`

For each Term in Doc:

* Number of times term `t` appears in document: `DocTerms.add\_doc\_term\_count(document\_name, term, count)`



* Increment number of documents with term `t`: `TermCounts.increment\_term(term)`

Finally store the weights in the Indexer:

TF_IDF

weights = should be a map of unique document terms and their respective TF_IDF weights

`WeightIndexer.add(document_name, weights)`

Finally we should then be able to index a query and
compare against the `WeightIndexer.state()`
