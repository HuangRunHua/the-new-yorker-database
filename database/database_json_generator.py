from image_analyzer import ImageAnalyzer
import os
import glob
import json

class DatabaseJSON(object):
    def __init__(self) -> None:
        """
        初始化MagazineGenerator。
        - Parameters:
            - folder: 单期杂志所在的文件夹名称
        """
        self.__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__))) 
        self.database_dict = []
        self.database_url = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/"

    def generator_magazine_json(self, coverStory: str, date: str, coverImageURL: str, id: str):
        eposide_names = self.__get_eposide_names()
        index = 1
        for eposide_name in eposide_names:
            eposide_dict = {}
            eposide_dict["id"] = index
            eposide_dict["magazineURL"] = self.database_url + eposide_name + "/" + eposide_name + ".json"
            self.database_dict.append(eposide_dict)
        with open(self.__location__ + "/database.json", "w") as outfile:
            json.dump(self.database_dict, outfile)

    def __get_eposide_names(self) -> list[str]:
        """
        Get all the names of data files (.NHO format) stored in a folder.
        - Returns: the list format of file's name, i.e. `001.NHO`
        """
        """Read files' name and stored in a str list"""
        absolute_folder_path = os.path.join(self.__location__, "*")
        eposide_names = [
            absolute_path.split("/")[-1] 
            for absolute_path in glob.glob(absolute_folder_path)
            if (not "." in absolute_path.split("/")[-1]) and (absolute_path.split("/")[-1][0:2] != "__")
        ]
        return eposide_names

if __name__ == "__main__":
    magazineJSON = DatabaseJSON()
    magazineJSON.generator_magazine_json(coverStory="“Neighborhood’s Finest,” by Roz Chast.",
                                            date="November 14, 2022",
                                            coverImageURL="https://media.newyorker.com/photos/63658ae20043641f2be3b555/master/w_760,c_limit/2022_11_14.jpg",
                                            id="00000000-0000-0000-0000-000000000001")