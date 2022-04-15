export type StatusCode = number;
export type PageNumber = string;

export interface ArticleIndex{
  id: number;
  lastModified: number;
  count: number;
  body: {
    [pageNumber: string]: ArticleMetadata[]
  };
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