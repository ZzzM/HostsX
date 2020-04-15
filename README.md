# HostsTool For macOS


#### [**HostsTool For macOS**](https://github.com/ZzzM/HostToolforMac)是Mac平台下的一个简易工具，来获取最新的[**hosts**](https://github.com/racaljk/hosts.git)更新。
开发语言：Swift 5<br/>
运行环境：macOS 10.10 或以上<br/>
最新版本：2.5.0 <br/>
支持语言：中、英 <br/>
下载地址：[Release](https://github.com/ZzzM/HostsToolforMac/releases)

### Version 2.5.0：
-增加主页入口
-重构设置面板<br/>
-更新Hosts下载源

#### 增加主页入口
![截屏2020-04-15 下午5.13.29.png](https://ws1.sinaimg.cn/large/77a575a6ly1gdukwnakwnj203g07c0u2.jpg)

#### 重构设置面板
![截屏2020-04-15 下午5.13.53.png](https://ws1.sinaimg.cn/large/77a575a6ly1gdukwna7jrj20c00fqgme.jpg)

#### 更新Hosts下载源
[coding](https://scaffrey.coding.net/p/hosts/d/hosts/git/raw/master/hosts-files/hosts)<br/>
[gogs](https://git.qvq.network/googlehosts/hosts/raw/master/hosts-files/hosts)<br/>
[github](https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts)


#### 网络更新机制
第一次更新会完全覆盖原hosts，然后生成“# My Hosts Start”、“# My Hosts End”标识,需要添加的话，只要在“# My Hosts Start”、“# My Hosts End”范围内编辑，

#### 效果
防止覆盖自己添加的hosts，只要在“# My Hosts Start”、“# My Hosts End”范围内编辑即可：
![](https://ws1.sinaimg.cn/large/77a575a6gy1fgqag558xxj20kj0e70ul.jpg)
