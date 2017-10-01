use Mix.Config

alias ContentIndexer.Store.DetsAdapter

config :content_indexer,
  corpus_dets_table_name: :corpus,
  doc_counts_dets_table_name: :doc_counts,
  doc_terms_dets_table_name: :doc_terms,
  term_counts_dets_table_name: :term_counts,
  weights_indexer_dets_table_name: :weights_indexer,
  storage_adapter: DetsAdapter

