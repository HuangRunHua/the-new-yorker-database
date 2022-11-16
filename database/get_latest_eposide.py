from image_analyzer import ImageAnalyzer
import os
import glob
import json


"""
Finally fetch the latest magazine by calling this.
"""

class DatabaseJSON(object):
    def __init__(self) -> None:
        """
        初始化DatabaseJSON。
        """
        self.__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__))) 
        self.latest_dict = []
        self.database_url = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/"

    def generator_latest_magazine_json(self):
        eposide_names = self.__get_eposide_names()
        latest = {
            "magazineURL": self.database_url + max(eposide_names) + "/" + max(eposide_names) + ".json"
        }
        self.latest_dict.append(latest) 
        with open(self.__location__ + "/latest.json", "w") as outfile:
            json.dump(self.latest_dict, outfile)

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
    magazineJSON.generator_latest_magazine_json()