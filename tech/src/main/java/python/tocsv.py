import os
import pandas as pd

# 基于python3.8
# 将此文件夹包括子文件下的所有excel文件转为csv
path = '/Users/fanfei/Downloads/untitled folder 2/untitled folder'

for root, dirs, files in os.walk(path):
    for file in files:
        filePath = os.path.join(root, file)
        if filePath.endswith(".xlsx"):
            print(filePath)
            excel = pd.read_excel(filePath, dtype=str, sheet_name=None)
            for key, value in excel.items():
                filename = filePath.replace('.xlsx', '', 1) + key + '.csv'
                value.to_csv(filename, encoding='utf_8_sig', index=False, header=False)
