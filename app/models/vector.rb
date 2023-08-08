COLLECTION_NAME = 'dev_documents'.freeze

COLLECTION = Chroma::Resources::Collection.get_or_create(COLLECTION_NAME, { lang: 'ruby', gem: 'chroma-rb' })

class Vector
  def self.create(id:, embedding:, metadata:, document:)
    record = Chroma::Resources::Embedding.new(id: id, embedding: embedding, metadata: metadata, document: document)
    COLLECTION.add([record])
  end

  def self.query(embedding:)
    COLLECTION.query(query_embeddings: [embedding])
  end

  def self.count
    COLLECTION.count
  end
end
