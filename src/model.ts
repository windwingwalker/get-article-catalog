export interface ArticleCatalog{
  id: number;
  lastModified: number;
  count: number;
  body: ArticleMetadata[];
}

export interface ArticleMetadata{
  firstPublished: number;
  lastModified: number;
  title: string;
  subtitle: string;
  type: string;
  edition: number;
  views: number;
  tags: string[];
  series: string;
}