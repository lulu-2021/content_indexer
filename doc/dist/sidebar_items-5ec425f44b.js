sidebarNodes={"extras":[{"id":"api-reference","title":"API Reference","group":"","headers":[{"id":"Modules","anchor":"modules"},{"id":"Summary","anchor":"summary"}]}],"exceptions":[],"modules":[{"id":"ContentIndexer","title":"ContentIndexer","functions":[{"id":"start/2","anchor":"start/2"}]},{"id":"ContentIndexer.Index","title":"ContentIndexer.Index","functions":[{"id":"new/2","anchor":"new/2"}]},{"id":"ContentIndexer.IndexInitialiser","title":"ContentIndexer.IndexInitialiser","functions":[{"id":"get_corpus_of_tokens/1","anchor":"get_corpus_of_tokens/1"},{"id":"initialise_index/0","anchor":"initialise_index/0"},{"id":"initialise_index/1","anchor":"initialise_index/1"}]},{"id":"ContentIndexer.Indexer","title":"ContentIndexer.Indexer","functions":[{"id":"add/2","anchor":"add/2"},{"id":"calculate/0","anchor":"calculate/0"},{"id":"corpus_of_tokens/0","anchor":"corpus_of_tokens/0"},{"id":"documents/0","anchor":"documents/0"},{"id":"init_indexer/0","anchor":"init_indexer/0"},{"id":"reset_index/0","anchor":"reset_index/0"},{"id":"retrieve_index/0","anchor":"retrieve_index/0"},{"id":"start_link/0","anchor":"start_link/0"},{"id":"store_index/1","anchor":"store_index/1"}]},{"id":"ContentIndexer.Services.Calculator","title":"ContentIndexer.Services.Calculator","functions":[{"id":"calculate_content_indexer_documents/2","anchor":"calculate_content_indexer_documents/2"},{"id":"calculate_content_indexer_documents/3","anchor":"calculate_content_indexer_documents/3"},{"id":"calculate_content_indexer_query/1","anchor":"calculate_content_indexer_query/1"},{"id":"calculate_tf_document/1","anchor":"calculate_tf_document/1"},{"id":"calculate_token_count_document/1","anchor":"calculate_token_count_document/1"},{"id":"init_calculator/0","anchor":"init_calculator/0"},{"id":"list_contains/2","anchor":"list_contains/2"},{"id":"start_link/0","anchor":"start_link/0"},{"id":"total/1","anchor":"total/1"}]},{"id":"ContentIndexer.Services.ListCheckerServer","title":"ContentIndexer.Services.ListCheckerServer","functions":[{"id":"count/2","anchor":"count/2"},{"id":"current_state/0","anchor":"current_state/0"},{"id":"init_server/0","anchor":"init_server/0"},{"id":"initialise_collection/2","anchor":"initialise_collection/2"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"ContentIndexer.Services.ListCheckerWorker","title":"ContentIndexer.Services.ListCheckerWorker","functions":[{"id":"init_worker/0","anchor":"init_worker/0"},{"id":"list/3","anchor":"list/3"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"ContentIndexer.Services.PreProcess","title":"ContentIndexer.Services.PreProcess","functions":[{"id":"pre_process_content/2","anchor":"pre_process_content/2"},{"id":"pre_process_query/1","anchor":"pre_process_query/1"}]},{"id":"ContentIndexer.Services.SearchUtils","title":"ContentIndexer.Services.SearchUtils","functions":[{"id":"accum_list/1","anchor":"accum_list/1"},{"id":"accum_list/2","anchor":"accum_list/2"},{"id":"build_index/2","anchor":"build_index/2"},{"id":"build_index_data/2","anchor":"build_index_data/2"},{"id":"build_weight_index/2","anchor":"build_weight_index/2"},{"id":"compile_query/2","anchor":"compile_query/2"},{"id":"crawl/2","anchor":"crawl/2"},{"id":"crawl_async/2","anchor":"crawl_async/2"}]},{"id":"ContentIndexer.Services.Similarity","title":"ContentIndexer.Services.Similarity","functions":[{"id":"compare/2","anchor":"compare/2"},{"id":"get_filenames/1","anchor":"get_filenames/1"},{"id":"get_similarity/2","anchor":"get_similarity/2"}]},{"id":"ContentIndexer.TfIdf.Calculate","title":"ContentIndexer.TfIdf.Calculate","functions":[{"id":"tf_idf/2","anchor":"tf_idf/2"}]},{"id":"ContentIndexer.TfIdf.Corpus","title":"ContentIndexer.TfIdf.Corpus","functions":[{"id":"count/0","anchor":"count/0"},{"id":"decrement/0","anchor":"decrement/0"},{"id":"increment/0","anchor":"increment/0"},{"id":"reset/0","anchor":"reset/0"}]},{"id":"ContentIndexer.TfIdf.Corpus.Impl","title":"ContentIndexer.TfIdf.Corpus.Impl","functions":[{"id":"decrement/1","anchor":"decrement/1"},{"id":"increment/1","anchor":"increment/1"},{"id":"reset/0","anchor":"reset/0"}]},{"id":"ContentIndexer.TfIdf.Corpus.Server","title":"ContentIndexer.TfIdf.Corpus.Server","functions":[{"id":"init_corpus/0","anchor":"init_corpus/0"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"ContentIndexer.TfIdf.DocCounts","title":"ContentIndexer.TfIdf.DocCounts","functions":[{"id":"add_document/2","anchor":"add_document/2"},{"id":"document_term_count/1","anchor":"document_term_count/1"},{"id":"reset/0","anchor":"reset/0"},{"id":"state/0","anchor":"state/0"}]},{"id":"ContentIndexer.TfIdf.DocCounts.Impl","title":"ContentIndexer.TfIdf.DocCounts.Impl","functions":[{"id":"add_new_document/3","anchor":"add_new_document/3"},{"id":"find_term_count/2","anchor":"find_term_count/2"},{"id":"reset/0","anchor":"reset/0"},{"id":"state/1","anchor":"state/1"}]},{"id":"ContentIndexer.TfIdf.DocCounts.Server","title":"ContentIndexer.TfIdf.DocCounts.Server","functions":[{"id":"init_doc_counts/0","anchor":"init_doc_counts/0"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"ContentIndexer.TfIdf.DocTerms","title":"ContentIndexer.TfIdf.DocTerms","functions":[{"id":"add_doc_term_count/3","anchor":"add_doc_term_count/3"},{"id":"get_doc_term_count/2","anchor":"get_doc_term_count/2"},{"id":"reset/0","anchor":"reset/0"},{"id":"state/0","anchor":"state/0"}]},{"id":"ContentIndexer.TfIdf.DocTerms.Impl","title":"ContentIndexer.TfIdf.DocTerms.Impl","functions":[{"id":"add_document_term_count/4","anchor":"add_document_term_count/4"},{"id":"get_document_term_count/3","anchor":"get_document_term_count/3"},{"id":"reset/0","anchor":"reset/0"},{"id":"state/1","anchor":"state/1"}]},{"id":"ContentIndexer.TfIdf.DocTerms.Server","title":"ContentIndexer.TfIdf.DocTerms.Server","functions":[{"id":"init_doc_terms/0","anchor":"init_doc_terms/0"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"ContentIndexer.TfIdf.TermCounter","title":"ContentIndexer.TfIdf.TermCounter","functions":[{"id":"unique_term_count/1","anchor":"unique_term_count/1"}]},{"id":"ContentIndexer.TfIdf.TermCounts","title":"ContentIndexer.TfIdf.TermCounts","functions":[{"id":"increment_term/1","anchor":"increment_term/1"},{"id":"reset/0","anchor":"reset/0"},{"id":"state/0","anchor":"state/0"},{"id":"term_count/1","anchor":"term_count/1"}]},{"id":"ContentIndexer.TfIdf.TermCounts.Impl","title":"ContentIndexer.TfIdf.TermCounts.Impl","functions":[{"id":"get_term_count/2","anchor":"get_term_count/2"},{"id":"increment_term_count/2","anchor":"increment_term_count/2"},{"id":"reset/0","anchor":"reset/0"},{"id":"state/1","anchor":"state/1"}]},{"id":"ContentIndexer.TfIdf.TermCounts.Server","title":"ContentIndexer.TfIdf.TermCounts.Server","functions":[{"id":"init_term_counts/0","anchor":"init_term_counts/0"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"ContentIndexer.TfIdf.WeightsIndexer","title":"ContentIndexer.TfIdf.WeightsIndexer","functions":[{"id":"add/2","anchor":"add/2"},{"id":"init_weights_index/0","anchor":"init_weights_index/0"},{"id":"reset/0","anchor":"reset/0"},{"id":"start_link/0","anchor":"start_link/0"},{"id":"state/0","anchor":"state/0"}]}],"protocols":[],"tasks":[]}