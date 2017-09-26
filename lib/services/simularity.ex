defmodule ContentIndexer.Services.Similarity do

  @moduledoc """
  ** Summary **
   This module accepts a list of tuples which contain the document id and a hash of terms
   and and their TF_IDF weights, it also accepts query terms in the form of a hash of terms and
   weights, same format as in the tuple above.

   [
     { 1, %{ "abc" => 0.001, "term1" => 0.123, "term2" => 0.934, "term3" => 0.945 } },
     { 1, %{ "abc" => 0.001, "term1" => 0.123, "term2" => 0.934, "term3" => 0.945 } }…
   ]

   The module will compute the similarity of all the provided documents to the
   query terms. It will then return an ordered set of terms and their corresponding
   weights
  """

  def compare(document_list, query_terms) do
    document_list
    |> get_similarity(query_terms)
    |> get_filenames()
  end

  # It will return an list of terms ordered by their cosine similarity
  def get_similarity(document_list, query_terms) do
    val = document_list
    |> Enum.map( fn(doc) ->
      { elem(doc, 0), compare_doc(elem(doc, 1), query_terms) }
    end )
    |> order_docs
    Enum.into(val, %{})
  end

  def get_filenames(similarity_map) do
    similarity_map
    |> sort_similarity_map()
    |> Enum.filter(fn(r) ->
      val = elem(r, 1)
      val != 0.0
    end)
    |> Enum.map(fn(r) ->
      elem(r, 0)
    end)
  end

  defp sort_similarity_map(similarity_map) do
    similarity_map
    |> Enum.sort(&(elem(&1, 1) <= elem(&2, 1)))
  end

  # return a list of documents as well as their cosime similarity to the term
  defp compare_doc(document, query) do
    d1_weights = get_relevant_weights(document, query)
    query_vals = Keyword.values query
    dot_prod = dot_product(Enum.zip(d1_weights, query_vals))

    d1_magnitude = magnitude(d1_weights)
    d2_magnitude = magnitude(query_vals)

    if d1_magnitude == 0 || d2_magnitude == 0 do
      0.0
    else
      abs(dot_prod / (d1_magnitude * d2_magnitude))
    end
  end

  defp dot_product(value_array) do
    value_array
    |> Enum.reduce(0, fn(x, acc) ->
      ( elem(x, 0) * elem(x, 1) ) + acc
     end )
  end

  defp magnitude(values) do
    # No math library wtf using erlang instead
    :math.sqrt( Enum.reduce(values, 0, fn(x, acc) ->
      (x * x) + acc
    end) )
  end

  defp get_relevant_weights(document, query) do
    # get the query keys corresponding weights from the document
    # weight is zero if the key is not in the document
    query
    |> Enum.map(fn(k) ->
      key = elem(k, 0)
      weight = document
      |> Enum.filter(fn(f) -> elem(f, 0) == key end)
      |> List.first

      case weight do
        nil ->
          {key, 0.0 }
        _ ->
          {key, elem(weight, 1) }
      end

    end)
    |> Enum.into(%{})
    |> Map.values
  end

  defp order_docs(x) do
    y = length x
    if y < 2 do
      x
    else
      halfway = round( Float.floor( y / 2 ) )
      front_half = Enum.slice(x, 0, halfway)
      back_half = Enum.slice(x, halfway, y)
      merge(order_docs( front_half ), order_docs( back_half ) )
    end
  end

  defp merge([], list) do
    list
  end

  defp merge(list, []) do
    list
  end

  defp merge(list1, list2) do
    [h1 | t1] = list1
    [h2 | t2] = list2
    {_, w1} = h1
    {_, w2} = h2

    if w1 > w2 do
      [h1 | merge( t1, list2)]
    else
      [h2 | merge( list1, t2)]
    end
  end
end

