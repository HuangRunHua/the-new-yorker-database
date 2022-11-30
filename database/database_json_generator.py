from image_analyzer import ImageAnalyzer
import os
import glob
import json

"""
Update the all database thirdly.
"""

class DatabaseJSON(object):
    def __init__(self) -> None:
        """
        初始化DatabaseJSON。
        """
        self.__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__))) 
        self.database_dict = []
        self.database_url = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/"

    def generator_magazine_json(self):
        eposide_names = self.__get_eposide_names()
        index = 1
        for eposide_name in eposide_names:
            if eposide_name != "images":
                eposide_dict = {}
                eposide_dict["id"] = index
                eposide_dict["magazineURL"] = self.database_url + eposide_name + "/" + eposide_name + ".json"
                self.database_dict.append(eposide_dict)
                index += 1
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
            if (not "." in absolute_path.split("/")[-1]) and (absolute_path.split("/")[-1][0:2] != "__") and
            (absolute_path.split("/")[-1] != "images") and (absolute_path.split("/")[-1] != "daily-articles")
        ]
        return eposide_names

if __name__ == "__main__":
    magazineJSON = DatabaseJSON()
    magazineJSON.generator_magazine_json()