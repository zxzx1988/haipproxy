"""
We use this validator to filter ip that can access mobile xweb website.
"""
from haipproxy.config.settings import (TEMP_XWEB_QUEUE, VALIDATED_XWEB_QUEUE, TTL_XWEB_QUEUE, SPEED_XWEB_QUEUE)
from ..redis_spiders import ValidatorRedisSpider
from .base import BaseValidator


class XWebValidator(BaseValidator, ValidatorRedisSpider):
    """This validator checks the liveness of xweb proxy resources"""
    name = 'xweb'   ###能访问广告联盟的代理IP即认为是可用的IP
    urls = [
        'https://a.exosrv.com/ads.js'   
    ]
    task_queue = TEMP_XWEB_QUEUE
    score_queue = VALIDATED_XWEB_QUEUE
    ttl_queue = TTL_XWEB_QUEUE
    speed_queue = SPEED_XWEB_QUEUE
    success_key = ''
