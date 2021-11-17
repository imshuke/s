```python
# -*- coding: utf8 -*-
import json

import requests


def main(event, context):
    info = {
        'title': '',  # 网站标题,一般写备案名称
        'url': '',  # 备案网址
        'icp': '',  # 备案号
        'gaurl': '',  # 公安备案指向链接,没有不填
        'ga_number': ''  # 公安备案号,没有不填
    }
    return {
        'statusCode': 200,
        'headers': {
            'content-type': 'text/html'
        },
        'body': requests.get('https://raw.githubusercontent.com/imsgj/static/main/icp/index.html').text.format(info=json.dumps(info))
    }
```
