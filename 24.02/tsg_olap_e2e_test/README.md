# TSG OLAP End-to-End Test

## 环境依赖

- 安装 kafka CLI  `kafka-operation.sh` ，详细参考[帮助文档](https://docs.geedge.net/pages/viewpage.action?pageId=8029767)
 
- 安装`Newman`，详细参考[帮助文档](https://learning.postman.com/docs/collections/using-newman-cli/newman-options/)

## 使用方法

### 配置QGW API 地址

- 修改 `enviroment.json`，配置QGW的IP地址和端口 (首次安装)
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
### 写入测试集至Kafka
- Logs
```shell
cd tsg_olap_e2e_test/ 

kafka-operation.sh producer SESSION-RECORD < ./datasets/logs/session_record.dat

kafka-operation.sh producer VOIP-RECORD < ./datasets/logs/voip_record.dat

kafka-operation.sh producer PROXY-EVENT < ./datasets/logs/proxy_event.dat
```
- Metrics

```shell
cd tsg_olap_e2e_test/ 

kafka-operation.sh producer NETWORK-TRAFFIC-METRIC < ./datasets/metrics/network_traffic_metric.dat

kafka-operation.sh producer POLICY-RULE-METRIC < ./datasets/metrics/policy_rule_metric.dat

kafka-operation.sh producer OBJECT-STATISTICS-METRIC < ./datasets/logs/object_statistics_metric.dat

kafka-operation.sh producer STATISTICS-RULE-METRIC < ./datasets/logs/statistics_rule_metric.dat
```

- Files

### 输出测试报告

- 不指定folder进行全部故障诊断，包括logs, metrics, files
```shell

# Logs进行故障诊断，输出诊断明细
newman run ./collection.json -n 3 -e ./enviroment.json --delay-request 1000 --timeout-script 10000 --timeout-request 300000 --timeout 3600000 --insecure  --verbose --ignore-redirects --folder logs 

#Logs进行故障诊断，通过表情形式输出测试结果
newman run ./collection.json -n 3 --delay-request 1000 -e ./enviroment.json --ignore-redirects --folder logs -r emojitrain

#Logs进行故障诊断，输出报告json格式，自动存储newman目录
newman run ./collection.json -n 3 --delay-request 1000 -e ./enviroment.json --ignore-redirects --folder logs -r json

```





