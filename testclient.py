from haipproxy.client.py_cli import ProxyFetcher
args = dict(host='127.0.0.1', port=6379, password='123456', db=0)
fetcher = ProxyFetcher('zhihu', strategy='greedy', redis_args=args)
print(fetcher.get_proxy())
print(fetcher.get_proxies()) # or print(fetcher.pool)