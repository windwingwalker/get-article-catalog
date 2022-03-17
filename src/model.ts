type Timestamp = number;
type ArticleTitle = string;
type Edition = number;
export type StatusCode = number;
export type PageNumber = string;

export interface ArticleIndex{
  id: number;
  lastModified: Timestamp;
  count: number;
  body: {
    [pageNumber: string]: ArticleMetadata[]
  };
}

export interface ArticleMetadata{
  firstPublished: Timestamp;
  lastModified: Timestamp;
  title: ArticleTitle;
  subtitle: ArticleTitle;
  type: string;
  edition: Edition;
}