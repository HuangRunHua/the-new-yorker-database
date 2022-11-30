from image_analyzer import ImageAnalyzer
import os
import glob
import json

"""
After creating the json format of articles run 
this python file to create current magazine content json file.
"""

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
        self.database_url = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/" + self.__folder + "/eposide"

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

            # https://github.com/HuangRunHua/the-new-yorker-database/blob/main/database/2022-11-14/eposide/the-case-against-the-twitter-apology-matthew-ichihashi-potts-forgiveness-danya-ruttenberg-on-repentance-and-repair.json
            article_dict["articleURL"] = self.database_url + "/" + article_name
            self.magazine_dict["articles"].append(article_dict)
            index += 1

        with open(self.__location__ + '/' + self.__folder + "/" + self.__folder + ".json", "w") as outfile:
            json.dump(self.magazine_dict, outfile)

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

    magazineJSON = MagazineJSON(folder="2022-12-04")
    magazineJSON.generator_magazine_json(coverStory="“Off-Season,” by Jorge Colombo.",
                                            date="December 4, 2022",
                                            coverImageURL="https://media.newyorker.com/photos/637d0d8fce333787da27bbc6/master/w_760,c_limit/2022_12_05.jpg",
                                            id="00000000-0000-0000-0000-000000000010")

    # magazineJSON = MagazineJSON(folder="2022-12-05")
    # magazineJSON.generator_magazine_json(coverStory="Steven Spielberg Waited 60 Years to Tell This Story",
    #                                         date="December 5, 2022",
    #                                         coverImageURL="https://api.time.com/wp-content/uploads/2022/11/TIM221205_Spielberg-CoverFINAL.jpg?quality=85&w=840",
    #                                         id="00000000-0000-0000-0000-000000000009")


    # magazineJSON = MagazineJSON(folder="2022-11-27")
    # magazineJSON.generator_magazine_json(coverStory="The Search for a Pill That Can Help Dogs—and Humans—Live Longer",
    #                                         date="November 27, 2022",
    #                                         coverImageURL="https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/images/wired-2022-11.jpg",
    #                                         id="00000000-0000-0000-0000-000000000008")
    # magazineJSON = MagazineJSON(folder="2022-11-28")
    # magazineJSON.generator_magazine_json(coverStory="“The Future Is Here,” by Birgit",
    #                                         date="November 28, 2022",
    #                                         coverImageURL="https://media.newyorker.com/photos/63765ebf573147b2b8a313a3/master/w_760,c_limit/2022_11_28.jpg",
    #                                         id="00000000-0000-0000-0000-000000000006")
    # magazineJSON = MagazineJSON(folder="2022-11-22")
    # magazineJSON.generator_magazine_json(coverStory="How Democrats Defied History in the Midterms—And What It Means for 2024",
    #                                         date="November 22, 2022",
    #                                         coverImageURL="https://api.time.com/wp-content/uploads/2022/11/TIM221121_ElectionCover.jpg?quality=85&w=840",
    #                                         id="00000000-0000-0000-0000-000000000005")
    # magazineJSON = MagazineJSON(folder="2022-11-21")
    # magazineJSON.generator_magazine_json(coverStory="“Low Tide,” by Barry Blitt.",
    #                                         date="November 21, 2022",
    #                                         coverImageURL="https://media.newyorker.com/photos/636eba572857dc647aaac234/master/w_760,c_limit/2022_11_21.jpg",
    #                                         id="00000000-0000-0000-0000-000000000004")
    # magazineJSON = MagazineJSON(folder="2022-11-14")
    # magazineJSON.generator_magazine_json(coverStory="“Neighborhood’s Finest,” by Roz Chast.",
    #                                         date="November 14, 2022",
    #                                         coverImageURL="https://media.newyorker.com/photos/63658ae20043641f2be3b555/master/w_760,c_limit/2022_11_14.jpg",
    #                                         id="00000000-0000-0000-0000-000000000003")
    # magazineJSON = MagazineJSON(folder="2022-11-07")
    # magazineJSON.generator_magazine_json(coverStory="“Fall Sweep,” by Adrian Tomine.",
    #                                         date="November 7, 2022",
    #                                         coverImageURL="https://media.newyorker.com/photos/635c00ceb120c5ac7a42bcea/master/w_760,c_limit/2022_11_07.jpg",
    #                                         id="00000000-0000-0000-0000-000000000002")