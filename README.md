# the-new-yorker-database
The New Yorker article database which is stored with JSON format is uses for the data base of my next **News+** app. 

### Article Structure

An article is structed with the following `JSON` format. 

```json
{
  "coverImageURL": "THE URL OF ARTICLE COVER IMAGE",
  // THE ASPECTRATIO OF COVER IMAGE, USUALLY A DOUBLE VALUE,
  "coverImageAspectRatio": 442.5/688,
  "coverImageDescription": "THE DESCRIPTION OF COVER IMAGE",
  "title": "THE TITLE OF THE ARTICLE",
  "subtitle": "THE SUBTITLE OF THE ARTICLE",
  "hashTag": "THE TAG OF THIS ARTICLE",
  "authorProfileURL": "THE IMAGE URL OF AUTHOR PROFILE",
  "authorName":"THE AUTHOR'S NAME",
  "contents": [
    {
      "role": "body",
      "text": "THE TEXT OF BODY SECTION"
    },
    {
      "role": "image",
      "imageURL": "THE URL OF CONTENT'S IMAGE THAT WILL BE INSERTED INSIDE AN ARTICLE",
      // THE ASPECTRATIO OF IMAGE, USUALLY A DOUBLE VALUE
      "imageAspectRatio": 295.88/251.67,
    },
    {
      "role": "quote",
      "text": "THE TEXT OF QUOTE PART INSIDE THE ARTICLE"
    }
    ...
  ]
}
```



