# the-new-yorker-database
The New Yorker article database which is stored with JSON format is uses for the data base of my next **News+** app. 

### Article Structure

An `Article` is structed with the following `JSON` format. 

```json
{
  "coverImageURL": "THE URL OF ARTICLE COVER IMAGE",
  "coverImageWidth": 442.5,
  "coverImageHeight": 688,
  "coverImageDescription": "THE DESCRIPTION OF COVER IMAGE",
  "title": "THE TITLE OF THE ARTICLE",
  "subtitle": "THE SUBTITLE OF THE ARTICLE",
  "hashTag": "THE TAG OF THIS ARTICLE",
  "authorName":"THE AUTHOR'S NAME",
  "publishDate": "THE DATE OF ARTICLE IS PUBLISHED"
  "contents": [
    {
      "role": "body",
      "text": "THE TEXT OF BODY SECTION"
    },
    {
      "role": "image",
      "imageURL": "THE URL OF CONTENT'S IMAGE THAT WILL BE INSERTED INSIDE AN ARTICLE",
      "imageWidth": 295.88,
      "imageHeight": 251.67,
      "imageDescription": "THE DESCRIPTION OF IMAGE",
    },
    {
      "role": "quote",
      "text": "THE TEXT OF QUOTE PART INSIDE THE ARTICLE"
    }
    ...
  ]
}
```

### Magazine Structure

A `Magazine` contains multiple `Article` structures and some other data and is stored in `JOSN` format.

```json
{
  "id": "00000000-0000-0000-0000-000000000000",
  "date": "Oct 3rh 2022",
  "coverStory": "Mark Ulriksen’s “All Rise!”",
  "coverImageWidth": 555,
  "coverImageHeight": 688,
  "coverImageURL": "https://media.newyorker.com/photos/632de17e882c6ff52b2d3b1f/master/w_380,c_limit/2022_10_03.jpg",
  "articles": [
    {
      "articleURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_10_03/the-shock-and-aftershocks-of-the-waste-land/article.json"
    },
    {
      "articleURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_10_03/how-to-recover-from-a-happy-childhood.json"
    }
  ]
}
```

### Database Structure

The `Database` contains all the magazines that are stored in the server. The structure of `Database` is also `JSON` style format.

```json
[
  {
    "id": 0,
    "magazineURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_09_26/2022_09_26.json"
  },
  {
    "id": 1,
    "magazineURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_10_03/2022_10_03.json"
  }
]
```

### Example

The attached `example` folder contains the code level example of how to fetch the `JSON` data and form a news app according to the data format mentioned above. The core UI of this app is shown in the following photo:

![](https://github.com/HuangRunHua/the-new-yorker-database/raw/main/cover.jpg)

### Last but not least

This repository will no longer be updated. Feel free to fork it for your own purpose.
