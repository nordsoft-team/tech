import os
import time

import pandas as pd

# 基于python3.8
# 将此文件夹包括子文件下的所有excel文件转为csv
path = '/Users/fanfei/Downloads/202204'

print(time.asctime())
for root, dirs, files in os.walk(path):
    for file in files:
        filePath = os.path.join(root, file)
        if filePath.endswith(".xlsx"):
            print(filePath)
            excel = pd.read_excel(filePath, dtype=str, sheet_name=None)
            filename = filePath.replace('.xlsx', '.csv', 1)
            for key, value in excel.items():
                if len(excel.items()) > 1:
                    filename = filePath.replace('.xlsx', '', 1) + '_' + key + '.csv'
                value.to_csv(filename, encoding='utf_8_sig', index=False, header=False)
print(time.asctime())
