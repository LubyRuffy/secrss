# 分析订阅源

## 背景
腾讯玄武实验室的安全技术动态更新的比较快，而且全面。想要知道他们的订阅了哪些源（是的，我就是这么无聊任性）。好在他们的代码是用github.io管理的，所以，直接分析吧。

## 结论
通过数据分析，截止2017年5月11日，总文章数9492，总来源数2048。

另外一些很有意思的内容出来了：

### 采用内容来源最多的几个源
应用数超过20个的来源是
```
Dinosn:	1465
binitamshah:	1265
unpacker:	176
SecLists:	161
_jsoo_:	128
Mike_Mimoso:	98
TrendLabs:	96
cedoxX:	96
gN3mes1s:	92
threatpost:	92
ProjectZeroBugs:	80
subTee:	72
cn0Xroot:	71
aszy:	62
revskills:	55
securxcess:	55
Unit42_Intel:	54
FireEye:	50
PythonArsenal:	48
Enno_Insinuator:	46
安全客:	43
FreeBuf:	41
NCCGroupInfosec:	38
virqdroid:	38
daniel_bilar:	38
GitHub:	37
Seebug:	36
seebug:	35
McAfee_Labs:	33
Github:	33
cyb3rops:	32
tiraniddo:	31
mattifestation:	31
WEareTROOPERS:	31
0xroot:	29
jedisct1:	29
mwrlabs:	28
claud_xiao:	27
virusbtn:	27
MottoIN:	25
benhawkes:	24
PhysicalDrive0:	24
capstone_engine:	22
hosselot:	22
0x6D6172696F:	22
PaloAltoNtwks:	21
dragosr:	21
jwgoerlich:	21
cynicalsecurity:	21
FuzzySec:	21
JohnLaTwC:	20
IntrusionSkills:	20
quequero:	20
x0rz:	20
taviso:	20
```
可以看到前两位来源占了总比例的 28%，说明这两个新闻源的质量很高。

### 参考网站
2541个外链，排序情况如下：
```
github.com:	1126
t.co:	338
bit.ly:	302
goo.gl:	254
bugs.chromium.org:	175
threatpost.com:	159
ow.ly:	122
twitter.com:	97
securityaffairs.co:	91
www.slideshare.net:	90
paper.seebug.org:	75
www.exploit-db.com:	70
:	68
www.blackhat.com:	66
packetstormsecurity.com:	65
www.zerodayinitiative.com:	63
www.freebuf.com:	60
gist.github.com:	56
securelist.com:	54
mp.weixin.qq.com:	54
bobao.360.cn:	51
```
看到没有，github才是学习安全的top1来源；github才是学习安全的top1来源；github才是学习安全的top1来源。重要的事情说三遍。

paper.seebug.org排名比较高，说明大家对heige的工作还是比较认可滴，甚至超过了www.exploit-db.com和安全客播报。里面有一些软连接没有跟进展开，空了再说。


### 标签
共发现59个标签，排序结果如下：
```
 Others :	1143
 Tools :	965
 Windows :	692
 Android :	586
 Malware :	527
 Browser :	479
 Popular Software :	410
 Attack :	400
 Web Security :	332
 Linux :	329
 MalwareAnalysis :	261
 Pentest :	243
 iOS :	213
 Hardware :	198
 Network :	176
 Vulnerability :	151
 WirelessSecurity :	147
 Detect :	139
 IoTDevice :	127
 macOS :	123
 Fuzzing :	109
 SecurityProduct :	107
 OpenSourceProject :	104
 ReverseEngineering :	102
 Crypto :	101
 Conference :	93
 Defend :	90
 Industry News :	89
 Mac OS X :	78
 Exploit :	76
 Debug :	69
 Virtualization :	68
 NetworkDevice :	62
 Mobile :	57
 Programming :	51
 SecurityReport :	50
 ThirdParty :	42
 Forensics :	40
 Operating System :	40
 Challenges :	40
 Firmware :	39
 Protocol :	38
 Mitigation :	36
 Obfuscation :	33
 MachineLearning :	33
 Sandbox :	30
 Backdoor :	23
 Rootkit :	23
 Cloud :	22
 ThreatIntelligence :	21
 Language :	13
 SCADA :	13
 Device :	11
 Attrack :	11
 Private :	11
 APT :	10
 Bug Bounty :	9
  :	6
 Symbolic Execution :	1
```
从这里可以看出来关注点还是比较明确的，偏二进制。相对来说，不太满足各位小白帽的"求知欲望"，他们希望偏Web漏洞多一点，所以大家大部分反馈的是看不懂。

## 运行
```
bundle install
ruby analysis_xuanwu.rb
```

## 查询
### 查询参考网站排序
```sql
select host,count(*) cnt from articles group by host order by cnt desc
```