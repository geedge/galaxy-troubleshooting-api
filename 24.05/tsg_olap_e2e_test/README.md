# TSG OLAP End-to-End Test

## 概述

TSG OLAP的数据摄入分为三种类型：Logs、Metrics 和 File Chunks。为确保能够正确处理并写入相应存储系统，需要支持端到端业务自检。

## 环境依赖

- 测试数据生成工具 `e2e-mockdata-generator.jar`
- 安装`Newman`，详细参考[帮助文档](https://learning.postman.com/docs/collections/using-newman-cli/newman-options/)

## 使用方法

### Newman CLI enviroment.json 修改如下配置
`Newman CLI 使用QGW HTTP Rest API 接口输出诊断报告，一般部署至国家中心`
```json
  {
			"key": "qgw_ip",
			"value": "192.168.44.30",
			"type": "default",
			"enabled": true
		},
		{
			"key": "qgw_port",
			"value": "9999",
			"type": "default",
			"enabled": true
		}

```
### 测试数据生成工具修改Kafka地址

`Kafka需为分中心地址`

- 修改`config.properties`, 增加Kafka访问地址
```props
  kafka.server=192.168.41.29:9092 
```

### 写入测试集至Kafka
- Logs
```shell

cd e2e-mockdata-generator/

java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --topic SESSION-RECORD  -f ./datasets/logs/session_record.dat

java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --topic VOIP-RECORD  -f ./datasets/logs/voip_record.dat

java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --topic PROXY-EVENT  -f ./datasets/logs/proxy_event.dat

```
- Metrics

```shell
cd e2e-mockdata-generator/

java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --topic NETWORK-TRAFFIC-METRIC  -f ./datasets/metrics/network_traffic_metric.dat

java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --topic POLICY-RULE-METRIC  -f ./datasets/metrics/policy_rule_metric.dat

java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --topic OBJECT-STATISTICS-METRIC  -f ./datasets/metrics/object_statistics_metric.dat

java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --topic STATISTICS-RULE-METRIC  -f ./datasets/metrics/statistics_rule_metric.dat

```

- Files
	- 123e4567-e89b-12d3-a456-426614174001  监测策略 PcapNG
	- 123e4567-e89b-12d3-a456-426614174002  HTTP Request Body
	- 123e4567-e89b-12d3-a456-426614174003  HTTP Response Body
	- 123e4567-e89b-12d3-a456-426614174004  MAIL EML
	- 123e4567-e89b-12d3-a456-426614174005  RTP PcapNG
	- 123e4567-e89b-12d3-a456-426614174006  Troubleshooting PcapNG
	- 123e4567-e89b-12d3-a456-426614174007  Datapath Telemetry PcapNG

```shell
cd e2e-mockdata-generator/

java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --topic TRAFFIC-FILE-STREAM-RECORD -n 123e4567-e89b-12d3-a456-426614174001 --file_type traffic_pcapng

java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --topic TRAFFIC-FILE-STREAM-RECORD -n 123e4567-e89b-12d3-a456-426614174002 --file_type html

java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --topic TRAFFIC-FILE-STREAM-RECORD -n 123e4567-e89b-12d3-a456-426614174003 --file_type html

java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --topic TRAFFIC-FILE-STREAM-RECORD -n 123e4567-e89b-12d3-a456-426614174004 --file_type eml

java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --topic TRAFFIC-FILE-STREAM-RECORD -n 123e4567-e89b-12d3-a456-426614174005 --file_type traffic_pcapng

java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --topic TROUBLESHOOTING-FILE-STREAM-RECORD -n 123e4567-e89b-12d3-a456-426614174006 --file_type troubleshooting_pcapng

java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --topic DATAPATH-TELEMETRY-RECORD -n 123e4567-e89b-12d3-a456-426614174007 --file_type datapath_telemetry_pcapng

```

### 输出故障诊断报告（等待3-5分钟）

```shell

# -folder logs ：对日志进行故障诊断，输出诊断明细；指定data_center。
# -folder metrics：对Metrics进行故障诊断，输出诊断明细；指定data_center。
# -folder files：对文件进行故障诊断，输出诊断明细；指定分中心HOS访问地址。
newman run ./collection.json -n 1 -e ./environment.json --delay-request 500 --timeout-script 10000 --timeout-request 300000 --timeout 3600000 --insecure  --verbose --ignore-redirects --env-var "data_center=tsg_olap"  --folder logs 

newman run ./collection.json -n 1 -e ./environment.json --delay-request 500 --timeout-script 10000 --timeout-request 300000 --timeout 3600000 --insecure  --verbose --ignore-redirects --env-var "data_center=tsg_olap"  --folder metrics 

newman run ./collection.json -n 1 -e ./environment.json --delay-request 500 --timeout-script 10000 --timeout-request 300000 --timeout 3600000 --insecure  --verbose --ignore-redirects --env-var "hos_ip=127.0.0.1"  --folder files 

# -folder logs：对日志进行故障诊断，通过表情形式输出测试结果
# -folder files：对文件进行故障诊断，通过表情形式输出测试结果
newman run ./collection.json -n 1 --delay-request 500 -e ./environment.json --env-var "data_center=tsg_olap" --ignore-redirects --folder logs -r emojitrain
newman run ./collection.json -n 1 --delay-request 500 -e ./environment.json  --env-var "hos_ip=127.0.0.1"  --ignore-redirects --folder files -r emojitrain

#清除测试数据（暂支持对文件的删除）
newman run ./collection.json -n 1 --delay-request 500 -e ./environment.json --ignore-redirects --folder clear_test_data -r emojitrain


```


