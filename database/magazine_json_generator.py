from image_analyzer import ImageAnalyzer
import os
import glob
import json

class MagazineJSON(object):
    def __init__(self, folder: str) -> None:
        """
        初始化MagazineGenerator。
        - Parameters:
            - folder: 单期杂志所在的文件夹名称
        """
        self.__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))
        self.__folder = folder
        self.magazine_dict = {}
        self.database_url = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/" + self.__folder

    def generator_magazine_json(self, coverStory: str, date: str, coverImageURL: str, id: str):
        self.magazine_dict["coverStory"] = coverStory
        self.magazine_dict["date"] = date
        self.magazine_dict["coverImageURL"] = coverImageURL
        self.magazine_dict["id"] = id
        cover_image_size = ImageAnalyzer.get_image_size(url=coverImageURL)
        self.magazine_dict["coverImageWidth"] = cover_image_size[0]
        self.magazine_dict["coverImageHeight"] = cover_image_size[1]
        self.magazine_dict["articles"] = []
        article_names = self.__get_article_names()
        index: int = 0
        for article_name in article_names:
            article_dict = {}
            article_dict["id"] = index
            article_dict["articleURL"] = self.database_url + "/" + article_name
            self.magazine_dict["articles"].append(article_dict)

        print(self.magazine_dict)

    def __get_article_names(self) -> list[str]:
        """
        Get all the names of data files (.NHO format) stored in a folder.
        - Returns: the list format of file's name, i.e. `001.NHO`
        """
        """Read files' name and stored in a str list"""
        absolute_folder_path = os.path.join(self.__location__, self.__folder + "/eposide" + "/*.json")
        article_names = [absolute_path.split("/")[-1] for absolute_path in glob.glob(absolute_folder_path)]
        return article_names

if __name__ == "__main__":
    magazineJSON = MagazineJSON(folder="2022-11-14")
    magazineJSON.generator_magazine_json(coverStory="“Neighborhood’s Finest,” by Roz Chast.",
                                            date="November 14, 2022",
                                            coverImageURL="https://media.newyorker.com/photos/63658ae20043641f2be3b555/master/w_760,c_limit/2022_11_14.jpg",
                                            id="00000000-0000-0000-0000-000000000001")